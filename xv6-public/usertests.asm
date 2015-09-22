
_usertests:     file format elf32-i386


Disassembly of section .text:

00000000 <iputtest>:
int stdout = 1;

// does chdir() call iput(p->cwd) in a transaction?
void
iputtest(void)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 08             	sub    $0x8,%esp
  printf(stdout, "iput test\n");
       6:	a1 a8 62 00 00       	mov    0x62a8,%eax
       b:	83 ec 08             	sub    $0x8,%esp
       e:	68 02 44 00 00       	push   $0x4402
      13:	50                   	push   %eax
      14:	e8 1d 40 00 00       	call   4036 <printf>
      19:	83 c4 10             	add    $0x10,%esp

  if(mkdir("iputdir") < 0){
      1c:	83 ec 0c             	sub    $0xc,%esp
      1f:	68 0d 44 00 00       	push   $0x440d
      24:	e8 f8 3e 00 00       	call   3f21 <mkdir>
      29:	83 c4 10             	add    $0x10,%esp
      2c:	85 c0                	test   %eax,%eax
      2e:	79 1b                	jns    4b <iputtest+0x4b>
    printf(stdout, "mkdir failed\n");
      30:	a1 a8 62 00 00       	mov    0x62a8,%eax
      35:	83 ec 08             	sub    $0x8,%esp
      38:	68 15 44 00 00       	push   $0x4415
      3d:	50                   	push   %eax
      3e:	e8 f3 3f 00 00       	call   4036 <printf>
      43:	83 c4 10             	add    $0x10,%esp
    exit();
      46:	e8 6e 3e 00 00       	call   3eb9 <exit>
  }
  if(chdir("iputdir") < 0){
      4b:	83 ec 0c             	sub    $0xc,%esp
      4e:	68 0d 44 00 00       	push   $0x440d
      53:	e8 d1 3e 00 00       	call   3f29 <chdir>
      58:	83 c4 10             	add    $0x10,%esp
      5b:	85 c0                	test   %eax,%eax
      5d:	79 1b                	jns    7a <iputtest+0x7a>
    printf(stdout, "chdir iputdir failed\n");
      5f:	a1 a8 62 00 00       	mov    0x62a8,%eax
      64:	83 ec 08             	sub    $0x8,%esp
      67:	68 23 44 00 00       	push   $0x4423
      6c:	50                   	push   %eax
      6d:	e8 c4 3f 00 00       	call   4036 <printf>
      72:	83 c4 10             	add    $0x10,%esp
    exit();
      75:	e8 3f 3e 00 00       	call   3eb9 <exit>
  }
  if(unlink("../iputdir") < 0){
      7a:	83 ec 0c             	sub    $0xc,%esp
      7d:	68 39 44 00 00       	push   $0x4439
      82:	e8 82 3e 00 00       	call   3f09 <unlink>
      87:	83 c4 10             	add    $0x10,%esp
      8a:	85 c0                	test   %eax,%eax
      8c:	79 1b                	jns    a9 <iputtest+0xa9>
    printf(stdout, "unlink ../iputdir failed\n");
      8e:	a1 a8 62 00 00       	mov    0x62a8,%eax
      93:	83 ec 08             	sub    $0x8,%esp
      96:	68 44 44 00 00       	push   $0x4444
      9b:	50                   	push   %eax
      9c:	e8 95 3f 00 00       	call   4036 <printf>
      a1:	83 c4 10             	add    $0x10,%esp
    exit();
      a4:	e8 10 3e 00 00       	call   3eb9 <exit>
  }
  if(chdir("/") < 0){
      a9:	83 ec 0c             	sub    $0xc,%esp
      ac:	68 5e 44 00 00       	push   $0x445e
      b1:	e8 73 3e 00 00       	call   3f29 <chdir>
      b6:	83 c4 10             	add    $0x10,%esp
      b9:	85 c0                	test   %eax,%eax
      bb:	79 1b                	jns    d8 <iputtest+0xd8>
    printf(stdout, "chdir / failed\n");
      bd:	a1 a8 62 00 00       	mov    0x62a8,%eax
      c2:	83 ec 08             	sub    $0x8,%esp
      c5:	68 60 44 00 00       	push   $0x4460
      ca:	50                   	push   %eax
      cb:	e8 66 3f 00 00       	call   4036 <printf>
      d0:	83 c4 10             	add    $0x10,%esp
    exit();
      d3:	e8 e1 3d 00 00       	call   3eb9 <exit>
  }
  printf(stdout, "iput test ok\n");
      d8:	a1 a8 62 00 00       	mov    0x62a8,%eax
      dd:	83 ec 08             	sub    $0x8,%esp
      e0:	68 70 44 00 00       	push   $0x4470
      e5:	50                   	push   %eax
      e6:	e8 4b 3f 00 00       	call   4036 <printf>
      eb:	83 c4 10             	add    $0x10,%esp
}
      ee:	c9                   	leave  
      ef:	c3                   	ret    

000000f0 <exitiputtest>:

// does exit() call iput(p->cwd) in a transaction?
void
exitiputtest(void)
{
      f0:	55                   	push   %ebp
      f1:	89 e5                	mov    %esp,%ebp
      f3:	83 ec 18             	sub    $0x18,%esp
  int pid;

  printf(stdout, "exitiput test\n");
      f6:	a1 a8 62 00 00       	mov    0x62a8,%eax
      fb:	83 ec 08             	sub    $0x8,%esp
      fe:	68 7e 44 00 00       	push   $0x447e
     103:	50                   	push   %eax
     104:	e8 2d 3f 00 00       	call   4036 <printf>
     109:	83 c4 10             	add    $0x10,%esp

  pid = fork();
     10c:	e8 a0 3d 00 00       	call   3eb1 <fork>
     111:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid < 0){
     114:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     118:	79 1b                	jns    135 <exitiputtest+0x45>
    printf(stdout, "fork failed\n");
     11a:	a1 a8 62 00 00       	mov    0x62a8,%eax
     11f:	83 ec 08             	sub    $0x8,%esp
     122:	68 8d 44 00 00       	push   $0x448d
     127:	50                   	push   %eax
     128:	e8 09 3f 00 00       	call   4036 <printf>
     12d:	83 c4 10             	add    $0x10,%esp
    exit();
     130:	e8 84 3d 00 00       	call   3eb9 <exit>
  }
  if(pid == 0){
     135:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     139:	0f 85 92 00 00 00    	jne    1d1 <exitiputtest+0xe1>
    if(mkdir("iputdir") < 0){
     13f:	83 ec 0c             	sub    $0xc,%esp
     142:	68 0d 44 00 00       	push   $0x440d
     147:	e8 d5 3d 00 00       	call   3f21 <mkdir>
     14c:	83 c4 10             	add    $0x10,%esp
     14f:	85 c0                	test   %eax,%eax
     151:	79 1b                	jns    16e <exitiputtest+0x7e>
      printf(stdout, "mkdir failed\n");
     153:	a1 a8 62 00 00       	mov    0x62a8,%eax
     158:	83 ec 08             	sub    $0x8,%esp
     15b:	68 15 44 00 00       	push   $0x4415
     160:	50                   	push   %eax
     161:	e8 d0 3e 00 00       	call   4036 <printf>
     166:	83 c4 10             	add    $0x10,%esp
      exit();
     169:	e8 4b 3d 00 00       	call   3eb9 <exit>
    }
    if(chdir("iputdir") < 0){
     16e:	83 ec 0c             	sub    $0xc,%esp
     171:	68 0d 44 00 00       	push   $0x440d
     176:	e8 ae 3d 00 00       	call   3f29 <chdir>
     17b:	83 c4 10             	add    $0x10,%esp
     17e:	85 c0                	test   %eax,%eax
     180:	79 1b                	jns    19d <exitiputtest+0xad>
      printf(stdout, "child chdir failed\n");
     182:	a1 a8 62 00 00       	mov    0x62a8,%eax
     187:	83 ec 08             	sub    $0x8,%esp
     18a:	68 9a 44 00 00       	push   $0x449a
     18f:	50                   	push   %eax
     190:	e8 a1 3e 00 00       	call   4036 <printf>
     195:	83 c4 10             	add    $0x10,%esp
      exit();
     198:	e8 1c 3d 00 00       	call   3eb9 <exit>
    }
    if(unlink("../iputdir") < 0){
     19d:	83 ec 0c             	sub    $0xc,%esp
     1a0:	68 39 44 00 00       	push   $0x4439
     1a5:	e8 5f 3d 00 00       	call   3f09 <unlink>
     1aa:	83 c4 10             	add    $0x10,%esp
     1ad:	85 c0                	test   %eax,%eax
     1af:	79 1b                	jns    1cc <exitiputtest+0xdc>
      printf(stdout, "unlink ../iputdir failed\n");
     1b1:	a1 a8 62 00 00       	mov    0x62a8,%eax
     1b6:	83 ec 08             	sub    $0x8,%esp
     1b9:	68 44 44 00 00       	push   $0x4444
     1be:	50                   	push   %eax
     1bf:	e8 72 3e 00 00       	call   4036 <printf>
     1c4:	83 c4 10             	add    $0x10,%esp
      exit();
     1c7:	e8 ed 3c 00 00       	call   3eb9 <exit>
    }
    exit();
     1cc:	e8 e8 3c 00 00       	call   3eb9 <exit>
  }
  wait();
     1d1:	e8 eb 3c 00 00       	call   3ec1 <wait>
  printf(stdout, "exitiput test ok\n");
     1d6:	a1 a8 62 00 00       	mov    0x62a8,%eax
     1db:	83 ec 08             	sub    $0x8,%esp
     1de:	68 ae 44 00 00       	push   $0x44ae
     1e3:	50                   	push   %eax
     1e4:	e8 4d 3e 00 00       	call   4036 <printf>
     1e9:	83 c4 10             	add    $0x10,%esp
}
     1ec:	c9                   	leave  
     1ed:	c3                   	ret    

000001ee <openiputtest>:
//      for(i = 0; i < 10000; i++)
//        yield();
//    }
void
openiputtest(void)
{
     1ee:	55                   	push   %ebp
     1ef:	89 e5                	mov    %esp,%ebp
     1f1:	83 ec 18             	sub    $0x18,%esp
  int pid;

  printf(stdout, "openiput test\n");
     1f4:	a1 a8 62 00 00       	mov    0x62a8,%eax
     1f9:	83 ec 08             	sub    $0x8,%esp
     1fc:	68 c0 44 00 00       	push   $0x44c0
     201:	50                   	push   %eax
     202:	e8 2f 3e 00 00       	call   4036 <printf>
     207:	83 c4 10             	add    $0x10,%esp
  if(mkdir("oidir") < 0){
     20a:	83 ec 0c             	sub    $0xc,%esp
     20d:	68 cf 44 00 00       	push   $0x44cf
     212:	e8 0a 3d 00 00       	call   3f21 <mkdir>
     217:	83 c4 10             	add    $0x10,%esp
     21a:	85 c0                	test   %eax,%eax
     21c:	79 1b                	jns    239 <openiputtest+0x4b>
    printf(stdout, "mkdir oidir failed\n");
     21e:	a1 a8 62 00 00       	mov    0x62a8,%eax
     223:	83 ec 08             	sub    $0x8,%esp
     226:	68 d5 44 00 00       	push   $0x44d5
     22b:	50                   	push   %eax
     22c:	e8 05 3e 00 00       	call   4036 <printf>
     231:	83 c4 10             	add    $0x10,%esp
    exit();
     234:	e8 80 3c 00 00       	call   3eb9 <exit>
  }
  pid = fork();
     239:	e8 73 3c 00 00       	call   3eb1 <fork>
     23e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid < 0){
     241:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     245:	79 1b                	jns    262 <openiputtest+0x74>
    printf(stdout, "fork failed\n");
     247:	a1 a8 62 00 00       	mov    0x62a8,%eax
     24c:	83 ec 08             	sub    $0x8,%esp
     24f:	68 8d 44 00 00       	push   $0x448d
     254:	50                   	push   %eax
     255:	e8 dc 3d 00 00       	call   4036 <printf>
     25a:	83 c4 10             	add    $0x10,%esp
    exit();
     25d:	e8 57 3c 00 00       	call   3eb9 <exit>
  }
  if(pid == 0){
     262:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     266:	75 3b                	jne    2a3 <openiputtest+0xb5>
    int fd = open("oidir", O_RDWR);
     268:	83 ec 08             	sub    $0x8,%esp
     26b:	6a 02                	push   $0x2
     26d:	68 cf 44 00 00       	push   $0x44cf
     272:	e8 82 3c 00 00       	call   3ef9 <open>
     277:	83 c4 10             	add    $0x10,%esp
     27a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0){
     27d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     281:	78 1b                	js     29e <openiputtest+0xb0>
      printf(stdout, "open directory for write succeeded\n");
     283:	a1 a8 62 00 00       	mov    0x62a8,%eax
     288:	83 ec 08             	sub    $0x8,%esp
     28b:	68 ec 44 00 00       	push   $0x44ec
     290:	50                   	push   %eax
     291:	e8 a0 3d 00 00       	call   4036 <printf>
     296:	83 c4 10             	add    $0x10,%esp
      exit();
     299:	e8 1b 3c 00 00       	call   3eb9 <exit>
    }
    exit();
     29e:	e8 16 3c 00 00       	call   3eb9 <exit>
  }
  sleep(1);
     2a3:	83 ec 0c             	sub    $0xc,%esp
     2a6:	6a 01                	push   $0x1
     2a8:	e8 9c 3c 00 00       	call   3f49 <sleep>
     2ad:	83 c4 10             	add    $0x10,%esp
  if(unlink("oidir") != 0){
     2b0:	83 ec 0c             	sub    $0xc,%esp
     2b3:	68 cf 44 00 00       	push   $0x44cf
     2b8:	e8 4c 3c 00 00       	call   3f09 <unlink>
     2bd:	83 c4 10             	add    $0x10,%esp
     2c0:	85 c0                	test   %eax,%eax
     2c2:	74 1b                	je     2df <openiputtest+0xf1>
    printf(stdout, "unlink failed\n");
     2c4:	a1 a8 62 00 00       	mov    0x62a8,%eax
     2c9:	83 ec 08             	sub    $0x8,%esp
     2cc:	68 10 45 00 00       	push   $0x4510
     2d1:	50                   	push   %eax
     2d2:	e8 5f 3d 00 00       	call   4036 <printf>
     2d7:	83 c4 10             	add    $0x10,%esp
    exit();
     2da:	e8 da 3b 00 00       	call   3eb9 <exit>
  }
  wait();
     2df:	e8 dd 3b 00 00       	call   3ec1 <wait>
  printf(stdout, "openiput test ok\n");
     2e4:	a1 a8 62 00 00       	mov    0x62a8,%eax
     2e9:	83 ec 08             	sub    $0x8,%esp
     2ec:	68 1f 45 00 00       	push   $0x451f
     2f1:	50                   	push   %eax
     2f2:	e8 3f 3d 00 00       	call   4036 <printf>
     2f7:	83 c4 10             	add    $0x10,%esp
}
     2fa:	c9                   	leave  
     2fb:	c3                   	ret    

000002fc <opentest>:

// simple file system tests

void
opentest(void)
{
     2fc:	55                   	push   %ebp
     2fd:	89 e5                	mov    %esp,%ebp
     2ff:	83 ec 18             	sub    $0x18,%esp
  int fd;

  printf(stdout, "open test\n");
     302:	a1 a8 62 00 00       	mov    0x62a8,%eax
     307:	83 ec 08             	sub    $0x8,%esp
     30a:	68 31 45 00 00       	push   $0x4531
     30f:	50                   	push   %eax
     310:	e8 21 3d 00 00       	call   4036 <printf>
     315:	83 c4 10             	add    $0x10,%esp
  fd = open("echo", 0);
     318:	83 ec 08             	sub    $0x8,%esp
     31b:	6a 00                	push   $0x0
     31d:	68 ec 43 00 00       	push   $0x43ec
     322:	e8 d2 3b 00 00       	call   3ef9 <open>
     327:	83 c4 10             	add    $0x10,%esp
     32a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
     32d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     331:	79 1b                	jns    34e <opentest+0x52>
    printf(stdout, "open echo failed!\n");
     333:	a1 a8 62 00 00       	mov    0x62a8,%eax
     338:	83 ec 08             	sub    $0x8,%esp
     33b:	68 3c 45 00 00       	push   $0x453c
     340:	50                   	push   %eax
     341:	e8 f0 3c 00 00       	call   4036 <printf>
     346:	83 c4 10             	add    $0x10,%esp
    exit();
     349:	e8 6b 3b 00 00       	call   3eb9 <exit>
  }
  close(fd);
     34e:	83 ec 0c             	sub    $0xc,%esp
     351:	ff 75 f4             	pushl  -0xc(%ebp)
     354:	e8 88 3b 00 00       	call   3ee1 <close>
     359:	83 c4 10             	add    $0x10,%esp
  fd = open("doesnotexist", 0);
     35c:	83 ec 08             	sub    $0x8,%esp
     35f:	6a 00                	push   $0x0
     361:	68 4f 45 00 00       	push   $0x454f
     366:	e8 8e 3b 00 00       	call   3ef9 <open>
     36b:	83 c4 10             	add    $0x10,%esp
     36e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
     371:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     375:	78 1b                	js     392 <opentest+0x96>
    printf(stdout, "open doesnotexist succeeded!\n");
     377:	a1 a8 62 00 00       	mov    0x62a8,%eax
     37c:	83 ec 08             	sub    $0x8,%esp
     37f:	68 5c 45 00 00       	push   $0x455c
     384:	50                   	push   %eax
     385:	e8 ac 3c 00 00       	call   4036 <printf>
     38a:	83 c4 10             	add    $0x10,%esp
    exit();
     38d:	e8 27 3b 00 00       	call   3eb9 <exit>
  }
  printf(stdout, "open test ok\n");
     392:	a1 a8 62 00 00       	mov    0x62a8,%eax
     397:	83 ec 08             	sub    $0x8,%esp
     39a:	68 7a 45 00 00       	push   $0x457a
     39f:	50                   	push   %eax
     3a0:	e8 91 3c 00 00       	call   4036 <printf>
     3a5:	83 c4 10             	add    $0x10,%esp
}
     3a8:	c9                   	leave  
     3a9:	c3                   	ret    

000003aa <writetest>:

void
writetest(void)
{
     3aa:	55                   	push   %ebp
     3ab:	89 e5                	mov    %esp,%ebp
     3ad:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int i;

  printf(stdout, "small file test\n");
     3b0:	a1 a8 62 00 00       	mov    0x62a8,%eax
     3b5:	83 ec 08             	sub    $0x8,%esp
     3b8:	68 88 45 00 00       	push   $0x4588
     3bd:	50                   	push   %eax
     3be:	e8 73 3c 00 00       	call   4036 <printf>
     3c3:	83 c4 10             	add    $0x10,%esp
  fd = open("small", O_CREATE|O_RDWR);
     3c6:	83 ec 08             	sub    $0x8,%esp
     3c9:	68 02 02 00 00       	push   $0x202
     3ce:	68 99 45 00 00       	push   $0x4599
     3d3:	e8 21 3b 00 00       	call   3ef9 <open>
     3d8:	83 c4 10             	add    $0x10,%esp
     3db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd >= 0){
     3de:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     3e2:	78 22                	js     406 <writetest+0x5c>
    printf(stdout, "creat small succeeded; ok\n");
     3e4:	a1 a8 62 00 00       	mov    0x62a8,%eax
     3e9:	83 ec 08             	sub    $0x8,%esp
     3ec:	68 9f 45 00 00       	push   $0x459f
     3f1:	50                   	push   %eax
     3f2:	e8 3f 3c 00 00       	call   4036 <printf>
     3f7:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
     3fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     401:	e9 8f 00 00 00       	jmp    495 <writetest+0xeb>
  printf(stdout, "small file test\n");
  fd = open("small", O_CREATE|O_RDWR);
  if(fd >= 0){
    printf(stdout, "creat small succeeded; ok\n");
  } else {
    printf(stdout, "error: creat small failed!\n");
     406:	a1 a8 62 00 00       	mov    0x62a8,%eax
     40b:	83 ec 08             	sub    $0x8,%esp
     40e:	68 ba 45 00 00       	push   $0x45ba
     413:	50                   	push   %eax
     414:	e8 1d 3c 00 00       	call   4036 <printf>
     419:	83 c4 10             	add    $0x10,%esp
    exit();
     41c:	e8 98 3a 00 00       	call   3eb9 <exit>
  }
  for(i = 0; i < 100; i++){
    if(write(fd, "aaaaaaaaaa", 10) != 10){
     421:	83 ec 04             	sub    $0x4,%esp
     424:	6a 0a                	push   $0xa
     426:	68 d6 45 00 00       	push   $0x45d6
     42b:	ff 75 f0             	pushl  -0x10(%ebp)
     42e:	e8 a6 3a 00 00       	call   3ed9 <write>
     433:	83 c4 10             	add    $0x10,%esp
     436:	83 f8 0a             	cmp    $0xa,%eax
     439:	74 1e                	je     459 <writetest+0xaf>
      printf(stdout, "error: write aa %d new file failed\n", i);
     43b:	a1 a8 62 00 00       	mov    0x62a8,%eax
     440:	83 ec 04             	sub    $0x4,%esp
     443:	ff 75 f4             	pushl  -0xc(%ebp)
     446:	68 e4 45 00 00       	push   $0x45e4
     44b:	50                   	push   %eax
     44c:	e8 e5 3b 00 00       	call   4036 <printf>
     451:	83 c4 10             	add    $0x10,%esp
      exit();
     454:	e8 60 3a 00 00       	call   3eb9 <exit>
    }
    if(write(fd, "bbbbbbbbbb", 10) != 10){
     459:	83 ec 04             	sub    $0x4,%esp
     45c:	6a 0a                	push   $0xa
     45e:	68 08 46 00 00       	push   $0x4608
     463:	ff 75 f0             	pushl  -0x10(%ebp)
     466:	e8 6e 3a 00 00       	call   3ed9 <write>
     46b:	83 c4 10             	add    $0x10,%esp
     46e:	83 f8 0a             	cmp    $0xa,%eax
     471:	74 1e                	je     491 <writetest+0xe7>
      printf(stdout, "error: write bb %d new file failed\n", i);
     473:	a1 a8 62 00 00       	mov    0x62a8,%eax
     478:	83 ec 04             	sub    $0x4,%esp
     47b:	ff 75 f4             	pushl  -0xc(%ebp)
     47e:	68 14 46 00 00       	push   $0x4614
     483:	50                   	push   %eax
     484:	e8 ad 3b 00 00       	call   4036 <printf>
     489:	83 c4 10             	add    $0x10,%esp
      exit();
     48c:	e8 28 3a 00 00       	call   3eb9 <exit>
    printf(stdout, "creat small succeeded; ok\n");
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
     491:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     495:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
     499:	7e 86                	jle    421 <writetest+0x77>
    if(write(fd, "bbbbbbbbbb", 10) != 10){
      printf(stdout, "error: write bb %d new file failed\n", i);
      exit();
    }
  }
  printf(stdout, "writes ok\n");
     49b:	a1 a8 62 00 00       	mov    0x62a8,%eax
     4a0:	83 ec 08             	sub    $0x8,%esp
     4a3:	68 38 46 00 00       	push   $0x4638
     4a8:	50                   	push   %eax
     4a9:	e8 88 3b 00 00       	call   4036 <printf>
     4ae:	83 c4 10             	add    $0x10,%esp
  close(fd);
     4b1:	83 ec 0c             	sub    $0xc,%esp
     4b4:	ff 75 f0             	pushl  -0x10(%ebp)
     4b7:	e8 25 3a 00 00       	call   3ee1 <close>
     4bc:	83 c4 10             	add    $0x10,%esp
  fd = open("small", O_RDONLY);
     4bf:	83 ec 08             	sub    $0x8,%esp
     4c2:	6a 00                	push   $0x0
     4c4:	68 99 45 00 00       	push   $0x4599
     4c9:	e8 2b 3a 00 00       	call   3ef9 <open>
     4ce:	83 c4 10             	add    $0x10,%esp
     4d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd >= 0){
     4d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     4d8:	78 3c                	js     516 <writetest+0x16c>
    printf(stdout, "open small succeeded ok\n");
     4da:	a1 a8 62 00 00       	mov    0x62a8,%eax
     4df:	83 ec 08             	sub    $0x8,%esp
     4e2:	68 43 46 00 00       	push   $0x4643
     4e7:	50                   	push   %eax
     4e8:	e8 49 3b 00 00       	call   4036 <printf>
     4ed:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(stdout, "error: open small failed!\n");
    exit();
  }
  i = read(fd, buf, 2000);
     4f0:	83 ec 04             	sub    $0x4,%esp
     4f3:	68 d0 07 00 00       	push   $0x7d0
     4f8:	68 00 8b 00 00       	push   $0x8b00
     4fd:	ff 75 f0             	pushl  -0x10(%ebp)
     500:	e8 cc 39 00 00       	call   3ed1 <read>
     505:	83 c4 10             	add    $0x10,%esp
     508:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(i == 2000){
     50b:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
     512:	75 57                	jne    56b <writetest+0x1c1>
     514:	eb 1b                	jmp    531 <writetest+0x187>
  close(fd);
  fd = open("small", O_RDONLY);
  if(fd >= 0){
    printf(stdout, "open small succeeded ok\n");
  } else {
    printf(stdout, "error: open small failed!\n");
     516:	a1 a8 62 00 00       	mov    0x62a8,%eax
     51b:	83 ec 08             	sub    $0x8,%esp
     51e:	68 5c 46 00 00       	push   $0x465c
     523:	50                   	push   %eax
     524:	e8 0d 3b 00 00       	call   4036 <printf>
     529:	83 c4 10             	add    $0x10,%esp
    exit();
     52c:	e8 88 39 00 00       	call   3eb9 <exit>
  }
  i = read(fd, buf, 2000);
  if(i == 2000){
    printf(stdout, "read succeeded ok\n");
     531:	a1 a8 62 00 00       	mov    0x62a8,%eax
     536:	83 ec 08             	sub    $0x8,%esp
     539:	68 77 46 00 00       	push   $0x4677
     53e:	50                   	push   %eax
     53f:	e8 f2 3a 00 00       	call   4036 <printf>
     544:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(stdout, "read failed\n");
    exit();
  }
  close(fd);
     547:	83 ec 0c             	sub    $0xc,%esp
     54a:	ff 75 f0             	pushl  -0x10(%ebp)
     54d:	e8 8f 39 00 00       	call   3ee1 <close>
     552:	83 c4 10             	add    $0x10,%esp

  if(unlink("small") < 0){
     555:	83 ec 0c             	sub    $0xc,%esp
     558:	68 99 45 00 00       	push   $0x4599
     55d:	e8 a7 39 00 00       	call   3f09 <unlink>
     562:	83 c4 10             	add    $0x10,%esp
     565:	85 c0                	test   %eax,%eax
     567:	79 38                	jns    5a1 <writetest+0x1f7>
     569:	eb 1b                	jmp    586 <writetest+0x1dc>
  }
  i = read(fd, buf, 2000);
  if(i == 2000){
    printf(stdout, "read succeeded ok\n");
  } else {
    printf(stdout, "read failed\n");
     56b:	a1 a8 62 00 00       	mov    0x62a8,%eax
     570:	83 ec 08             	sub    $0x8,%esp
     573:	68 8a 46 00 00       	push   $0x468a
     578:	50                   	push   %eax
     579:	e8 b8 3a 00 00       	call   4036 <printf>
     57e:	83 c4 10             	add    $0x10,%esp
    exit();
     581:	e8 33 39 00 00       	call   3eb9 <exit>
  }
  close(fd);

  if(unlink("small") < 0){
    printf(stdout, "unlink small failed\n");
     586:	a1 a8 62 00 00       	mov    0x62a8,%eax
     58b:	83 ec 08             	sub    $0x8,%esp
     58e:	68 97 46 00 00       	push   $0x4697
     593:	50                   	push   %eax
     594:	e8 9d 3a 00 00       	call   4036 <printf>
     599:	83 c4 10             	add    $0x10,%esp
    exit();
     59c:	e8 18 39 00 00       	call   3eb9 <exit>
  }
  printf(stdout, "small file test ok\n");
     5a1:	a1 a8 62 00 00       	mov    0x62a8,%eax
     5a6:	83 ec 08             	sub    $0x8,%esp
     5a9:	68 ac 46 00 00       	push   $0x46ac
     5ae:	50                   	push   %eax
     5af:	e8 82 3a 00 00       	call   4036 <printf>
     5b4:	83 c4 10             	add    $0x10,%esp
}
     5b7:	c9                   	leave  
     5b8:	c3                   	ret    

000005b9 <writetest1>:

void
writetest1(void)
{
     5b9:	55                   	push   %ebp
     5ba:	89 e5                	mov    %esp,%ebp
     5bc:	83 ec 18             	sub    $0x18,%esp
  int i, fd, n;

  printf(stdout, "big files test\n");
     5bf:	a1 a8 62 00 00       	mov    0x62a8,%eax
     5c4:	83 ec 08             	sub    $0x8,%esp
     5c7:	68 c0 46 00 00       	push   $0x46c0
     5cc:	50                   	push   %eax
     5cd:	e8 64 3a 00 00       	call   4036 <printf>
     5d2:	83 c4 10             	add    $0x10,%esp

  fd = open("big", O_CREATE|O_RDWR);
     5d5:	83 ec 08             	sub    $0x8,%esp
     5d8:	68 02 02 00 00       	push   $0x202
     5dd:	68 d0 46 00 00       	push   $0x46d0
     5e2:	e8 12 39 00 00       	call   3ef9 <open>
     5e7:	83 c4 10             	add    $0x10,%esp
     5ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
     5ed:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     5f1:	79 1b                	jns    60e <writetest1+0x55>
    printf(stdout, "error: creat big failed!\n");
     5f3:	a1 a8 62 00 00       	mov    0x62a8,%eax
     5f8:	83 ec 08             	sub    $0x8,%esp
     5fb:	68 d4 46 00 00       	push   $0x46d4
     600:	50                   	push   %eax
     601:	e8 30 3a 00 00       	call   4036 <printf>
     606:	83 c4 10             	add    $0x10,%esp
    exit();
     609:	e8 ab 38 00 00       	call   3eb9 <exit>
  }

  for(i = 0; i < MAXFILE; i++){
     60e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     615:	eb 4b                	jmp    662 <writetest1+0xa9>
    ((int*)buf)[0] = i;
     617:	ba 00 8b 00 00       	mov    $0x8b00,%edx
     61c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     61f:	89 02                	mov    %eax,(%edx)
    if(write(fd, buf, 512) != 512){
     621:	83 ec 04             	sub    $0x4,%esp
     624:	68 00 02 00 00       	push   $0x200
     629:	68 00 8b 00 00       	push   $0x8b00
     62e:	ff 75 ec             	pushl  -0x14(%ebp)
     631:	e8 a3 38 00 00       	call   3ed9 <write>
     636:	83 c4 10             	add    $0x10,%esp
     639:	3d 00 02 00 00       	cmp    $0x200,%eax
     63e:	74 1e                	je     65e <writetest1+0xa5>
      printf(stdout, "error: write big file failed\n", i);
     640:	a1 a8 62 00 00       	mov    0x62a8,%eax
     645:	83 ec 04             	sub    $0x4,%esp
     648:	ff 75 f4             	pushl  -0xc(%ebp)
     64b:	68 ee 46 00 00       	push   $0x46ee
     650:	50                   	push   %eax
     651:	e8 e0 39 00 00       	call   4036 <printf>
     656:	83 c4 10             	add    $0x10,%esp
      exit();
     659:	e8 5b 38 00 00       	call   3eb9 <exit>
  if(fd < 0){
    printf(stdout, "error: creat big failed!\n");
    exit();
  }

  for(i = 0; i < MAXFILE; i++){
     65e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     662:	8b 45 f4             	mov    -0xc(%ebp),%eax
     665:	3d 8b 00 00 00       	cmp    $0x8b,%eax
     66a:	76 ab                	jbe    617 <writetest1+0x5e>
      printf(stdout, "error: write big file failed\n", i);
      exit();
    }
  }

  close(fd);
     66c:	83 ec 0c             	sub    $0xc,%esp
     66f:	ff 75 ec             	pushl  -0x14(%ebp)
     672:	e8 6a 38 00 00       	call   3ee1 <close>
     677:	83 c4 10             	add    $0x10,%esp

  fd = open("big", O_RDONLY);
     67a:	83 ec 08             	sub    $0x8,%esp
     67d:	6a 00                	push   $0x0
     67f:	68 d0 46 00 00       	push   $0x46d0
     684:	e8 70 38 00 00       	call   3ef9 <open>
     689:	83 c4 10             	add    $0x10,%esp
     68c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
     68f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     693:	79 1b                	jns    6b0 <writetest1+0xf7>
    printf(stdout, "error: open big failed!\n");
     695:	a1 a8 62 00 00       	mov    0x62a8,%eax
     69a:	83 ec 08             	sub    $0x8,%esp
     69d:	68 0c 47 00 00       	push   $0x470c
     6a2:	50                   	push   %eax
     6a3:	e8 8e 39 00 00       	call   4036 <printf>
     6a8:	83 c4 10             	add    $0x10,%esp
    exit();
     6ab:	e8 09 38 00 00       	call   3eb9 <exit>
  }

  n = 0;
     6b0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(;;){
    i = read(fd, buf, 512);
     6b7:	83 ec 04             	sub    $0x4,%esp
     6ba:	68 00 02 00 00       	push   $0x200
     6bf:	68 00 8b 00 00       	push   $0x8b00
     6c4:	ff 75 ec             	pushl  -0x14(%ebp)
     6c7:	e8 05 38 00 00       	call   3ed1 <read>
     6cc:	83 c4 10             	add    $0x10,%esp
     6cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(i == 0){
     6d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     6d6:	75 4c                	jne    724 <writetest1+0x16b>
      if(n == MAXFILE - 1){
     6d8:	81 7d f0 8b 00 00 00 	cmpl   $0x8b,-0x10(%ebp)
     6df:	75 1e                	jne    6ff <writetest1+0x146>
        printf(stdout, "read only %d blocks from big", n);
     6e1:	a1 a8 62 00 00       	mov    0x62a8,%eax
     6e6:	83 ec 04             	sub    $0x4,%esp
     6e9:	ff 75 f0             	pushl  -0x10(%ebp)
     6ec:	68 25 47 00 00       	push   $0x4725
     6f1:	50                   	push   %eax
     6f2:	e8 3f 39 00 00       	call   4036 <printf>
     6f7:	83 c4 10             	add    $0x10,%esp
        exit();
     6fa:	e8 ba 37 00 00       	call   3eb9 <exit>
      }
      break;
     6ff:	90                   	nop
             n, ((int*)buf)[0]);
      exit();
    }
    n++;
  }
  close(fd);
     700:	83 ec 0c             	sub    $0xc,%esp
     703:	ff 75 ec             	pushl  -0x14(%ebp)
     706:	e8 d6 37 00 00       	call   3ee1 <close>
     70b:	83 c4 10             	add    $0x10,%esp
  if(unlink("big") < 0){
     70e:	83 ec 0c             	sub    $0xc,%esp
     711:	68 d0 46 00 00       	push   $0x46d0
     716:	e8 ee 37 00 00       	call   3f09 <unlink>
     71b:	83 c4 10             	add    $0x10,%esp
     71e:	85 c0                	test   %eax,%eax
     720:	79 7c                	jns    79e <writetest1+0x1e5>
     722:	eb 5f                	jmp    783 <writetest1+0x1ca>
      if(n == MAXFILE - 1){
        printf(stdout, "read only %d blocks from big", n);
        exit();
      }
      break;
    } else if(i != 512){
     724:	81 7d f4 00 02 00 00 	cmpl   $0x200,-0xc(%ebp)
     72b:	74 1e                	je     74b <writetest1+0x192>
      printf(stdout, "read failed %d\n", i);
     72d:	a1 a8 62 00 00       	mov    0x62a8,%eax
     732:	83 ec 04             	sub    $0x4,%esp
     735:	ff 75 f4             	pushl  -0xc(%ebp)
     738:	68 42 47 00 00       	push   $0x4742
     73d:	50                   	push   %eax
     73e:	e8 f3 38 00 00       	call   4036 <printf>
     743:	83 c4 10             	add    $0x10,%esp
      exit();
     746:	e8 6e 37 00 00       	call   3eb9 <exit>
    }
    if(((int*)buf)[0] != n){
     74b:	b8 00 8b 00 00       	mov    $0x8b00,%eax
     750:	8b 00                	mov    (%eax),%eax
     752:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     755:	74 23                	je     77a <writetest1+0x1c1>
      printf(stdout, "read content of block %d is %d\n",
             n, ((int*)buf)[0]);
     757:	b8 00 8b 00 00       	mov    $0x8b00,%eax
    } else if(i != 512){
      printf(stdout, "read failed %d\n", i);
      exit();
    }
    if(((int*)buf)[0] != n){
      printf(stdout, "read content of block %d is %d\n",
     75c:	8b 10                	mov    (%eax),%edx
     75e:	a1 a8 62 00 00       	mov    0x62a8,%eax
     763:	52                   	push   %edx
     764:	ff 75 f0             	pushl  -0x10(%ebp)
     767:	68 54 47 00 00       	push   $0x4754
     76c:	50                   	push   %eax
     76d:	e8 c4 38 00 00       	call   4036 <printf>
     772:	83 c4 10             	add    $0x10,%esp
             n, ((int*)buf)[0]);
      exit();
     775:	e8 3f 37 00 00       	call   3eb9 <exit>
    }
    n++;
     77a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  }
     77e:	e9 34 ff ff ff       	jmp    6b7 <writetest1+0xfe>
  close(fd);
  if(unlink("big") < 0){
    printf(stdout, "unlink big failed\n");
     783:	a1 a8 62 00 00       	mov    0x62a8,%eax
     788:	83 ec 08             	sub    $0x8,%esp
     78b:	68 74 47 00 00       	push   $0x4774
     790:	50                   	push   %eax
     791:	e8 a0 38 00 00       	call   4036 <printf>
     796:	83 c4 10             	add    $0x10,%esp
    exit();
     799:	e8 1b 37 00 00       	call   3eb9 <exit>
  }
  printf(stdout, "big files ok\n");
     79e:	a1 a8 62 00 00       	mov    0x62a8,%eax
     7a3:	83 ec 08             	sub    $0x8,%esp
     7a6:	68 87 47 00 00       	push   $0x4787
     7ab:	50                   	push   %eax
     7ac:	e8 85 38 00 00       	call   4036 <printf>
     7b1:	83 c4 10             	add    $0x10,%esp
}
     7b4:	c9                   	leave  
     7b5:	c3                   	ret    

000007b6 <createtest>:

void
createtest(void)
{
     7b6:	55                   	push   %ebp
     7b7:	89 e5                	mov    %esp,%ebp
     7b9:	83 ec 18             	sub    $0x18,%esp
  int i, fd;

  printf(stdout, "many creates, followed by unlink test\n");
     7bc:	a1 a8 62 00 00       	mov    0x62a8,%eax
     7c1:	83 ec 08             	sub    $0x8,%esp
     7c4:	68 98 47 00 00       	push   $0x4798
     7c9:	50                   	push   %eax
     7ca:	e8 67 38 00 00       	call   4036 <printf>
     7cf:	83 c4 10             	add    $0x10,%esp

  name[0] = 'a';
     7d2:	c6 05 00 ab 00 00 61 	movb   $0x61,0xab00
  name[2] = '\0';
     7d9:	c6 05 02 ab 00 00 00 	movb   $0x0,0xab02
  for(i = 0; i < 52; i++){
     7e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     7e7:	eb 35                	jmp    81e <createtest+0x68>
    name[1] = '0' + i;
     7e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7ec:	83 c0 30             	add    $0x30,%eax
     7ef:	a2 01 ab 00 00       	mov    %al,0xab01
    fd = open(name, O_CREATE|O_RDWR);
     7f4:	83 ec 08             	sub    $0x8,%esp
     7f7:	68 02 02 00 00       	push   $0x202
     7fc:	68 00 ab 00 00       	push   $0xab00
     801:	e8 f3 36 00 00       	call   3ef9 <open>
     806:	83 c4 10             	add    $0x10,%esp
     809:	89 45 f0             	mov    %eax,-0x10(%ebp)
    close(fd);
     80c:	83 ec 0c             	sub    $0xc,%esp
     80f:	ff 75 f0             	pushl  -0x10(%ebp)
     812:	e8 ca 36 00 00       	call   3ee1 <close>
     817:	83 c4 10             	add    $0x10,%esp

  printf(stdout, "many creates, followed by unlink test\n");

  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++){
     81a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     81e:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
     822:	7e c5                	jle    7e9 <createtest+0x33>
    name[1] = '0' + i;
    fd = open(name, O_CREATE|O_RDWR);
    close(fd);
  }
  name[0] = 'a';
     824:	c6 05 00 ab 00 00 61 	movb   $0x61,0xab00
  name[2] = '\0';
     82b:	c6 05 02 ab 00 00 00 	movb   $0x0,0xab02
  for(i = 0; i < 52; i++){
     832:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     839:	eb 1f                	jmp    85a <createtest+0xa4>
    name[1] = '0' + i;
     83b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     83e:	83 c0 30             	add    $0x30,%eax
     841:	a2 01 ab 00 00       	mov    %al,0xab01
    unlink(name);
     846:	83 ec 0c             	sub    $0xc,%esp
     849:	68 00 ab 00 00       	push   $0xab00
     84e:	e8 b6 36 00 00       	call   3f09 <unlink>
     853:	83 c4 10             	add    $0x10,%esp
    fd = open(name, O_CREATE|O_RDWR);
    close(fd);
  }
  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++){
     856:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     85a:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
     85e:	7e db                	jle    83b <createtest+0x85>
    name[1] = '0' + i;
    unlink(name);
  }
  printf(stdout, "many creates, followed by unlink; ok\n");
     860:	a1 a8 62 00 00       	mov    0x62a8,%eax
     865:	83 ec 08             	sub    $0x8,%esp
     868:	68 c0 47 00 00       	push   $0x47c0
     86d:	50                   	push   %eax
     86e:	e8 c3 37 00 00       	call   4036 <printf>
     873:	83 c4 10             	add    $0x10,%esp
}
     876:	c9                   	leave  
     877:	c3                   	ret    

00000878 <dirtest>:

void dirtest(void)
{
     878:	55                   	push   %ebp
     879:	89 e5                	mov    %esp,%ebp
     87b:	83 ec 08             	sub    $0x8,%esp
  printf(stdout, "mkdir test\n");
     87e:	a1 a8 62 00 00       	mov    0x62a8,%eax
     883:	83 ec 08             	sub    $0x8,%esp
     886:	68 e6 47 00 00       	push   $0x47e6
     88b:	50                   	push   %eax
     88c:	e8 a5 37 00 00       	call   4036 <printf>
     891:	83 c4 10             	add    $0x10,%esp

  if(mkdir("dir0") < 0){
     894:	83 ec 0c             	sub    $0xc,%esp
     897:	68 f2 47 00 00       	push   $0x47f2
     89c:	e8 80 36 00 00       	call   3f21 <mkdir>
     8a1:	83 c4 10             	add    $0x10,%esp
     8a4:	85 c0                	test   %eax,%eax
     8a6:	79 1b                	jns    8c3 <dirtest+0x4b>
    printf(stdout, "mkdir failed\n");
     8a8:	a1 a8 62 00 00       	mov    0x62a8,%eax
     8ad:	83 ec 08             	sub    $0x8,%esp
     8b0:	68 15 44 00 00       	push   $0x4415
     8b5:	50                   	push   %eax
     8b6:	e8 7b 37 00 00       	call   4036 <printf>
     8bb:	83 c4 10             	add    $0x10,%esp
    exit();
     8be:	e8 f6 35 00 00       	call   3eb9 <exit>
  }

  if(chdir("dir0") < 0){
     8c3:	83 ec 0c             	sub    $0xc,%esp
     8c6:	68 f2 47 00 00       	push   $0x47f2
     8cb:	e8 59 36 00 00       	call   3f29 <chdir>
     8d0:	83 c4 10             	add    $0x10,%esp
     8d3:	85 c0                	test   %eax,%eax
     8d5:	79 1b                	jns    8f2 <dirtest+0x7a>
    printf(stdout, "chdir dir0 failed\n");
     8d7:	a1 a8 62 00 00       	mov    0x62a8,%eax
     8dc:	83 ec 08             	sub    $0x8,%esp
     8df:	68 f7 47 00 00       	push   $0x47f7
     8e4:	50                   	push   %eax
     8e5:	e8 4c 37 00 00       	call   4036 <printf>
     8ea:	83 c4 10             	add    $0x10,%esp
    exit();
     8ed:	e8 c7 35 00 00       	call   3eb9 <exit>
  }

  if(chdir("..") < 0){
     8f2:	83 ec 0c             	sub    $0xc,%esp
     8f5:	68 0a 48 00 00       	push   $0x480a
     8fa:	e8 2a 36 00 00       	call   3f29 <chdir>
     8ff:	83 c4 10             	add    $0x10,%esp
     902:	85 c0                	test   %eax,%eax
     904:	79 1b                	jns    921 <dirtest+0xa9>
    printf(stdout, "chdir .. failed\n");
     906:	a1 a8 62 00 00       	mov    0x62a8,%eax
     90b:	83 ec 08             	sub    $0x8,%esp
     90e:	68 0d 48 00 00       	push   $0x480d
     913:	50                   	push   %eax
     914:	e8 1d 37 00 00       	call   4036 <printf>
     919:	83 c4 10             	add    $0x10,%esp
    exit();
     91c:	e8 98 35 00 00       	call   3eb9 <exit>
  }

  if(unlink("dir0") < 0){
     921:	83 ec 0c             	sub    $0xc,%esp
     924:	68 f2 47 00 00       	push   $0x47f2
     929:	e8 db 35 00 00       	call   3f09 <unlink>
     92e:	83 c4 10             	add    $0x10,%esp
     931:	85 c0                	test   %eax,%eax
     933:	79 1b                	jns    950 <dirtest+0xd8>
    printf(stdout, "unlink dir0 failed\n");
     935:	a1 a8 62 00 00       	mov    0x62a8,%eax
     93a:	83 ec 08             	sub    $0x8,%esp
     93d:	68 1e 48 00 00       	push   $0x481e
     942:	50                   	push   %eax
     943:	e8 ee 36 00 00       	call   4036 <printf>
     948:	83 c4 10             	add    $0x10,%esp
    exit();
     94b:	e8 69 35 00 00       	call   3eb9 <exit>
  }
  printf(stdout, "mkdir test ok\n");
     950:	a1 a8 62 00 00       	mov    0x62a8,%eax
     955:	83 ec 08             	sub    $0x8,%esp
     958:	68 32 48 00 00       	push   $0x4832
     95d:	50                   	push   %eax
     95e:	e8 d3 36 00 00       	call   4036 <printf>
     963:	83 c4 10             	add    $0x10,%esp
}
     966:	c9                   	leave  
     967:	c3                   	ret    

00000968 <exectest>:

void
exectest(void)
{
     968:	55                   	push   %ebp
     969:	89 e5                	mov    %esp,%ebp
     96b:	83 ec 08             	sub    $0x8,%esp
  printf(stdout, "exec test\n");
     96e:	a1 a8 62 00 00       	mov    0x62a8,%eax
     973:	83 ec 08             	sub    $0x8,%esp
     976:	68 41 48 00 00       	push   $0x4841
     97b:	50                   	push   %eax
     97c:	e8 b5 36 00 00       	call   4036 <printf>
     981:	83 c4 10             	add    $0x10,%esp
  if(exec("echo", echoargv) < 0){
     984:	83 ec 08             	sub    $0x8,%esp
     987:	68 94 62 00 00       	push   $0x6294
     98c:	68 ec 43 00 00       	push   $0x43ec
     991:	e8 5b 35 00 00       	call   3ef1 <exec>
     996:	83 c4 10             	add    $0x10,%esp
     999:	85 c0                	test   %eax,%eax
     99b:	79 1b                	jns    9b8 <exectest+0x50>
    printf(stdout, "exec echo failed\n");
     99d:	a1 a8 62 00 00       	mov    0x62a8,%eax
     9a2:	83 ec 08             	sub    $0x8,%esp
     9a5:	68 4c 48 00 00       	push   $0x484c
     9aa:	50                   	push   %eax
     9ab:	e8 86 36 00 00       	call   4036 <printf>
     9b0:	83 c4 10             	add    $0x10,%esp
    exit();
     9b3:	e8 01 35 00 00       	call   3eb9 <exit>
  }
}
     9b8:	c9                   	leave  
     9b9:	c3                   	ret    

000009ba <pipe1>:

// simple fork and pipe read/write

void
pipe1(void)
{
     9ba:	55                   	push   %ebp
     9bb:	89 e5                	mov    %esp,%ebp
     9bd:	83 ec 28             	sub    $0x28,%esp
  int fds[2], pid;
  int seq, i, n, cc, total;

  if(pipe(fds) != 0){
     9c0:	83 ec 0c             	sub    $0xc,%esp
     9c3:	8d 45 d8             	lea    -0x28(%ebp),%eax
     9c6:	50                   	push   %eax
     9c7:	e8 fd 34 00 00       	call   3ec9 <pipe>
     9cc:	83 c4 10             	add    $0x10,%esp
     9cf:	85 c0                	test   %eax,%eax
     9d1:	74 17                	je     9ea <pipe1+0x30>
    printf(1, "pipe() failed\n");
     9d3:	83 ec 08             	sub    $0x8,%esp
     9d6:	68 5e 48 00 00       	push   $0x485e
     9db:	6a 01                	push   $0x1
     9dd:	e8 54 36 00 00       	call   4036 <printf>
     9e2:	83 c4 10             	add    $0x10,%esp
    exit();
     9e5:	e8 cf 34 00 00       	call   3eb9 <exit>
  }
  pid = fork();
     9ea:	e8 c2 34 00 00       	call   3eb1 <fork>
     9ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
  seq = 0;
     9f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  if(pid == 0){
     9f9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     9fd:	0f 85 89 00 00 00    	jne    a8c <pipe1+0xd2>
    close(fds[0]);
     a03:	8b 45 d8             	mov    -0x28(%ebp),%eax
     a06:	83 ec 0c             	sub    $0xc,%esp
     a09:	50                   	push   %eax
     a0a:	e8 d2 34 00 00       	call   3ee1 <close>
     a0f:	83 c4 10             	add    $0x10,%esp
    for(n = 0; n < 5; n++){
     a12:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     a19:	eb 66                	jmp    a81 <pipe1+0xc7>
      for(i = 0; i < 1033; i++)
     a1b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     a22:	eb 19                	jmp    a3d <pipe1+0x83>
        buf[i] = seq++;
     a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a27:	8d 50 01             	lea    0x1(%eax),%edx
     a2a:	89 55 f4             	mov    %edx,-0xc(%ebp)
     a2d:	89 c2                	mov    %eax,%edx
     a2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a32:	05 00 8b 00 00       	add    $0x8b00,%eax
     a37:	88 10                	mov    %dl,(%eax)
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
      for(i = 0; i < 1033; i++)
     a39:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     a3d:	81 7d f0 08 04 00 00 	cmpl   $0x408,-0x10(%ebp)
     a44:	7e de                	jle    a24 <pipe1+0x6a>
        buf[i] = seq++;
      if(write(fds[1], buf, 1033) != 1033){
     a46:	8b 45 dc             	mov    -0x24(%ebp),%eax
     a49:	83 ec 04             	sub    $0x4,%esp
     a4c:	68 09 04 00 00       	push   $0x409
     a51:	68 00 8b 00 00       	push   $0x8b00
     a56:	50                   	push   %eax
     a57:	e8 7d 34 00 00       	call   3ed9 <write>
     a5c:	83 c4 10             	add    $0x10,%esp
     a5f:	3d 09 04 00 00       	cmp    $0x409,%eax
     a64:	74 17                	je     a7d <pipe1+0xc3>
        printf(1, "pipe1 oops 1\n");
     a66:	83 ec 08             	sub    $0x8,%esp
     a69:	68 6d 48 00 00       	push   $0x486d
     a6e:	6a 01                	push   $0x1
     a70:	e8 c1 35 00 00       	call   4036 <printf>
     a75:	83 c4 10             	add    $0x10,%esp
        exit();
     a78:	e8 3c 34 00 00       	call   3eb9 <exit>
  }
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
     a7d:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
     a81:	83 7d ec 04          	cmpl   $0x4,-0x14(%ebp)
     a85:	7e 94                	jle    a1b <pipe1+0x61>
      if(write(fds[1], buf, 1033) != 1033){
        printf(1, "pipe1 oops 1\n");
        exit();
      }
    }
    exit();
     a87:	e8 2d 34 00 00       	call   3eb9 <exit>
  } else if(pid > 0){
     a8c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     a90:	0f 8e f4 00 00 00    	jle    b8a <pipe1+0x1d0>
    close(fds[1]);
     a96:	8b 45 dc             	mov    -0x24(%ebp),%eax
     a99:	83 ec 0c             	sub    $0xc,%esp
     a9c:	50                   	push   %eax
     a9d:	e8 3f 34 00 00       	call   3ee1 <close>
     aa2:	83 c4 10             	add    $0x10,%esp
    total = 0;
     aa5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    cc = 1;
     aac:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
    while((n = read(fds[0], buf, cc)) > 0){
     ab3:	eb 66                	jmp    b1b <pipe1+0x161>
      for(i = 0; i < n; i++){
     ab5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     abc:	eb 3b                	jmp    af9 <pipe1+0x13f>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     abe:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ac1:	05 00 8b 00 00       	add    $0x8b00,%eax
     ac6:	0f b6 00             	movzbl (%eax),%eax
     ac9:	0f be c8             	movsbl %al,%ecx
     acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
     acf:	8d 50 01             	lea    0x1(%eax),%edx
     ad2:	89 55 f4             	mov    %edx,-0xc(%ebp)
     ad5:	31 c8                	xor    %ecx,%eax
     ad7:	0f b6 c0             	movzbl %al,%eax
     ada:	85 c0                	test   %eax,%eax
     adc:	74 17                	je     af5 <pipe1+0x13b>
          printf(1, "pipe1 oops 2\n");
     ade:	83 ec 08             	sub    $0x8,%esp
     ae1:	68 7b 48 00 00       	push   $0x487b
     ae6:	6a 01                	push   $0x1
     ae8:	e8 49 35 00 00       	call   4036 <printf>
     aed:	83 c4 10             	add    $0x10,%esp
     af0:	e9 ac 00 00 00       	jmp    ba1 <pipe1+0x1e7>
  } else if(pid > 0){
    close(fds[1]);
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
      for(i = 0; i < n; i++){
     af5:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     af9:	8b 45 f0             	mov    -0x10(%ebp),%eax
     afc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     aff:	7c bd                	jl     abe <pipe1+0x104>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
          printf(1, "pipe1 oops 2\n");
          return;
        }
      }
      total += n;
     b01:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b04:	01 45 e4             	add    %eax,-0x1c(%ebp)
      cc = cc * 2;
     b07:	d1 65 e8             	shll   -0x18(%ebp)
      if(cc > sizeof(buf))
     b0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b0d:	3d 00 20 00 00       	cmp    $0x2000,%eax
     b12:	76 07                	jbe    b1b <pipe1+0x161>
        cc = sizeof(buf);
     b14:	c7 45 e8 00 20 00 00 	movl   $0x2000,-0x18(%ebp)
    exit();
  } else if(pid > 0){
    close(fds[1]);
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
     b1b:	8b 45 d8             	mov    -0x28(%ebp),%eax
     b1e:	83 ec 04             	sub    $0x4,%esp
     b21:	ff 75 e8             	pushl  -0x18(%ebp)
     b24:	68 00 8b 00 00       	push   $0x8b00
     b29:	50                   	push   %eax
     b2a:	e8 a2 33 00 00       	call   3ed1 <read>
     b2f:	83 c4 10             	add    $0x10,%esp
     b32:	89 45 ec             	mov    %eax,-0x14(%ebp)
     b35:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     b39:	0f 8f 76 ff ff ff    	jg     ab5 <pipe1+0xfb>
      total += n;
      cc = cc * 2;
      if(cc > sizeof(buf))
        cc = sizeof(buf);
    }
    if(total != 5 * 1033){
     b3f:	81 7d e4 2d 14 00 00 	cmpl   $0x142d,-0x1c(%ebp)
     b46:	74 1a                	je     b62 <pipe1+0x1a8>
      printf(1, "pipe1 oops 3 total %d\n", total);
     b48:	83 ec 04             	sub    $0x4,%esp
     b4b:	ff 75 e4             	pushl  -0x1c(%ebp)
     b4e:	68 89 48 00 00       	push   $0x4889
     b53:	6a 01                	push   $0x1
     b55:	e8 dc 34 00 00       	call   4036 <printf>
     b5a:	83 c4 10             	add    $0x10,%esp
      exit();
     b5d:	e8 57 33 00 00       	call   3eb9 <exit>
    }
    close(fds[0]);
     b62:	8b 45 d8             	mov    -0x28(%ebp),%eax
     b65:	83 ec 0c             	sub    $0xc,%esp
     b68:	50                   	push   %eax
     b69:	e8 73 33 00 00       	call   3ee1 <close>
     b6e:	83 c4 10             	add    $0x10,%esp
    wait();
     b71:	e8 4b 33 00 00       	call   3ec1 <wait>
  } else {
    printf(1, "fork() failed\n");
    exit();
  }
  printf(1, "pipe1 ok\n");
     b76:	83 ec 08             	sub    $0x8,%esp
     b79:	68 af 48 00 00       	push   $0x48af
     b7e:	6a 01                	push   $0x1
     b80:	e8 b1 34 00 00       	call   4036 <printf>
     b85:	83 c4 10             	add    $0x10,%esp
     b88:	eb 17                	jmp    ba1 <pipe1+0x1e7>
      exit();
    }
    close(fds[0]);
    wait();
  } else {
    printf(1, "fork() failed\n");
     b8a:	83 ec 08             	sub    $0x8,%esp
     b8d:	68 a0 48 00 00       	push   $0x48a0
     b92:	6a 01                	push   $0x1
     b94:	e8 9d 34 00 00       	call   4036 <printf>
     b99:	83 c4 10             	add    $0x10,%esp
    exit();
     b9c:	e8 18 33 00 00       	call   3eb9 <exit>
  }
  printf(1, "pipe1 ok\n");
}
     ba1:	c9                   	leave  
     ba2:	c3                   	ret    

00000ba3 <preempt>:

// meant to be run w/ at most two CPUs
void
preempt(void)
{
     ba3:	55                   	push   %ebp
     ba4:	89 e5                	mov    %esp,%ebp
     ba6:	83 ec 28             	sub    $0x28,%esp
  int pid1, pid2, pid3;
  int pfds[2];

  printf(1, "preempt: ");
     ba9:	83 ec 08             	sub    $0x8,%esp
     bac:	68 b9 48 00 00       	push   $0x48b9
     bb1:	6a 01                	push   $0x1
     bb3:	e8 7e 34 00 00       	call   4036 <printf>
     bb8:	83 c4 10             	add    $0x10,%esp
  pid1 = fork();
     bbb:	e8 f1 32 00 00       	call   3eb1 <fork>
     bc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid1 == 0)
     bc3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     bc7:	75 02                	jne    bcb <preempt+0x28>
    for(;;)
      ;
     bc9:	eb fe                	jmp    bc9 <preempt+0x26>

  pid2 = fork();
     bcb:	e8 e1 32 00 00       	call   3eb1 <fork>
     bd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid2 == 0)
     bd3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     bd7:	75 02                	jne    bdb <preempt+0x38>
    for(;;)
      ;
     bd9:	eb fe                	jmp    bd9 <preempt+0x36>

  pipe(pfds);
     bdb:	83 ec 0c             	sub    $0xc,%esp
     bde:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     be1:	50                   	push   %eax
     be2:	e8 e2 32 00 00       	call   3ec9 <pipe>
     be7:	83 c4 10             	add    $0x10,%esp
  pid3 = fork();
     bea:	e8 c2 32 00 00       	call   3eb1 <fork>
     bef:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(pid3 == 0){
     bf2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     bf6:	75 4d                	jne    c45 <preempt+0xa2>
    close(pfds[0]);
     bf8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     bfb:	83 ec 0c             	sub    $0xc,%esp
     bfe:	50                   	push   %eax
     bff:	e8 dd 32 00 00       	call   3ee1 <close>
     c04:	83 c4 10             	add    $0x10,%esp
    if(write(pfds[1], "x", 1) != 1)
     c07:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c0a:	83 ec 04             	sub    $0x4,%esp
     c0d:	6a 01                	push   $0x1
     c0f:	68 c3 48 00 00       	push   $0x48c3
     c14:	50                   	push   %eax
     c15:	e8 bf 32 00 00       	call   3ed9 <write>
     c1a:	83 c4 10             	add    $0x10,%esp
     c1d:	83 f8 01             	cmp    $0x1,%eax
     c20:	74 12                	je     c34 <preempt+0x91>
      printf(1, "preempt write error");
     c22:	83 ec 08             	sub    $0x8,%esp
     c25:	68 c5 48 00 00       	push   $0x48c5
     c2a:	6a 01                	push   $0x1
     c2c:	e8 05 34 00 00       	call   4036 <printf>
     c31:	83 c4 10             	add    $0x10,%esp
    close(pfds[1]);
     c34:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c37:	83 ec 0c             	sub    $0xc,%esp
     c3a:	50                   	push   %eax
     c3b:	e8 a1 32 00 00       	call   3ee1 <close>
     c40:	83 c4 10             	add    $0x10,%esp
    for(;;)
      ;
     c43:	eb fe                	jmp    c43 <preempt+0xa0>
  }

  close(pfds[1]);
     c45:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c48:	83 ec 0c             	sub    $0xc,%esp
     c4b:	50                   	push   %eax
     c4c:	e8 90 32 00 00       	call   3ee1 <close>
     c51:	83 c4 10             	add    $0x10,%esp
  if(read(pfds[0], buf, sizeof(buf)) != 1){
     c54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c57:	83 ec 04             	sub    $0x4,%esp
     c5a:	68 00 20 00 00       	push   $0x2000
     c5f:	68 00 8b 00 00       	push   $0x8b00
     c64:	50                   	push   %eax
     c65:	e8 67 32 00 00       	call   3ed1 <read>
     c6a:	83 c4 10             	add    $0x10,%esp
     c6d:	83 f8 01             	cmp    $0x1,%eax
     c70:	74 14                	je     c86 <preempt+0xe3>
    printf(1, "preempt read error");
     c72:	83 ec 08             	sub    $0x8,%esp
     c75:	68 d9 48 00 00       	push   $0x48d9
     c7a:	6a 01                	push   $0x1
     c7c:	e8 b5 33 00 00       	call   4036 <printf>
     c81:	83 c4 10             	add    $0x10,%esp
     c84:	eb 7e                	jmp    d04 <preempt+0x161>
    return;
  }
  close(pfds[0]);
     c86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c89:	83 ec 0c             	sub    $0xc,%esp
     c8c:	50                   	push   %eax
     c8d:	e8 4f 32 00 00       	call   3ee1 <close>
     c92:	83 c4 10             	add    $0x10,%esp
  printf(1, "kill... ");
     c95:	83 ec 08             	sub    $0x8,%esp
     c98:	68 ec 48 00 00       	push   $0x48ec
     c9d:	6a 01                	push   $0x1
     c9f:	e8 92 33 00 00       	call   4036 <printf>
     ca4:	83 c4 10             	add    $0x10,%esp
  kill(pid1);
     ca7:	83 ec 0c             	sub    $0xc,%esp
     caa:	ff 75 f4             	pushl  -0xc(%ebp)
     cad:	e8 37 32 00 00       	call   3ee9 <kill>
     cb2:	83 c4 10             	add    $0x10,%esp
  kill(pid2);
     cb5:	83 ec 0c             	sub    $0xc,%esp
     cb8:	ff 75 f0             	pushl  -0x10(%ebp)
     cbb:	e8 29 32 00 00       	call   3ee9 <kill>
     cc0:	83 c4 10             	add    $0x10,%esp
  kill(pid3);
     cc3:	83 ec 0c             	sub    $0xc,%esp
     cc6:	ff 75 ec             	pushl  -0x14(%ebp)
     cc9:	e8 1b 32 00 00       	call   3ee9 <kill>
     cce:	83 c4 10             	add    $0x10,%esp
  printf(1, "wait... ");
     cd1:	83 ec 08             	sub    $0x8,%esp
     cd4:	68 f5 48 00 00       	push   $0x48f5
     cd9:	6a 01                	push   $0x1
     cdb:	e8 56 33 00 00       	call   4036 <printf>
     ce0:	83 c4 10             	add    $0x10,%esp
  wait();
     ce3:	e8 d9 31 00 00       	call   3ec1 <wait>
  wait();
     ce8:	e8 d4 31 00 00       	call   3ec1 <wait>
  wait();
     ced:	e8 cf 31 00 00       	call   3ec1 <wait>
  printf(1, "preempt ok\n");
     cf2:	83 ec 08             	sub    $0x8,%esp
     cf5:	68 fe 48 00 00       	push   $0x48fe
     cfa:	6a 01                	push   $0x1
     cfc:	e8 35 33 00 00       	call   4036 <printf>
     d01:	83 c4 10             	add    $0x10,%esp
}
     d04:	c9                   	leave  
     d05:	c3                   	ret    

00000d06 <exitwait>:

// try to find any races between exit and wait
void
exitwait(void)
{
     d06:	55                   	push   %ebp
     d07:	89 e5                	mov    %esp,%ebp
     d09:	83 ec 18             	sub    $0x18,%esp
  int i, pid;

  for(i = 0; i < 100; i++){
     d0c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     d13:	eb 4f                	jmp    d64 <exitwait+0x5e>
    pid = fork();
     d15:	e8 97 31 00 00       	call   3eb1 <fork>
     d1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0){
     d1d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     d21:	79 14                	jns    d37 <exitwait+0x31>
      printf(1, "fork failed\n");
     d23:	83 ec 08             	sub    $0x8,%esp
     d26:	68 8d 44 00 00       	push   $0x448d
     d2b:	6a 01                	push   $0x1
     d2d:	e8 04 33 00 00       	call   4036 <printf>
     d32:	83 c4 10             	add    $0x10,%esp
      return;
     d35:	eb 45                	jmp    d7c <exitwait+0x76>
    }
    if(pid){
     d37:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     d3b:	74 1e                	je     d5b <exitwait+0x55>
      if(wait() != pid){
     d3d:	e8 7f 31 00 00       	call   3ec1 <wait>
     d42:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     d45:	74 19                	je     d60 <exitwait+0x5a>
        printf(1, "wait wrong pid\n");
     d47:	83 ec 08             	sub    $0x8,%esp
     d4a:	68 0a 49 00 00       	push   $0x490a
     d4f:	6a 01                	push   $0x1
     d51:	e8 e0 32 00 00       	call   4036 <printf>
     d56:	83 c4 10             	add    $0x10,%esp
        return;
     d59:	eb 21                	jmp    d7c <exitwait+0x76>
      }
    } else {
      exit();
     d5b:	e8 59 31 00 00       	call   3eb9 <exit>
void
exitwait(void)
{
  int i, pid;

  for(i = 0; i < 100; i++){
     d60:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     d64:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
     d68:	7e ab                	jle    d15 <exitwait+0xf>
      }
    } else {
      exit();
    }
  }
  printf(1, "exitwait ok\n");
     d6a:	83 ec 08             	sub    $0x8,%esp
     d6d:	68 1a 49 00 00       	push   $0x491a
     d72:	6a 01                	push   $0x1
     d74:	e8 bd 32 00 00       	call   4036 <printf>
     d79:	83 c4 10             	add    $0x10,%esp
}
     d7c:	c9                   	leave  
     d7d:	c3                   	ret    

00000d7e <mem>:

void
mem(void)
{
     d7e:	55                   	push   %ebp
     d7f:	89 e5                	mov    %esp,%ebp
     d81:	83 ec 18             	sub    $0x18,%esp
  void *m1, *m2;
  int pid, ppid;

  printf(1, "mem test\n");
     d84:	83 ec 08             	sub    $0x8,%esp
     d87:	68 27 49 00 00       	push   $0x4927
     d8c:	6a 01                	push   $0x1
     d8e:	e8 a3 32 00 00       	call   4036 <printf>
     d93:	83 c4 10             	add    $0x10,%esp
  ppid = getpid();
     d96:	e8 9e 31 00 00       	call   3f39 <getpid>
     d9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if((pid = fork()) == 0){
     d9e:	e8 0e 31 00 00       	call   3eb1 <fork>
     da3:	89 45 ec             	mov    %eax,-0x14(%ebp)
     da6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     daa:	0f 85 b7 00 00 00    	jne    e67 <mem+0xe9>
    m1 = 0;
     db0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while((m2 = malloc(10001)) != 0){
     db7:	eb 0e                	jmp    dc7 <mem+0x49>
      *(char**)m2 = m1;
     db9:	8b 45 e8             	mov    -0x18(%ebp),%eax
     dbc:	8b 55 f4             	mov    -0xc(%ebp),%edx
     dbf:	89 10                	mov    %edx,(%eax)
      m1 = m2;
     dc1:	8b 45 e8             	mov    -0x18(%ebp),%eax
     dc4:	89 45 f4             	mov    %eax,-0xc(%ebp)

  printf(1, "mem test\n");
  ppid = getpid();
  if((pid = fork()) == 0){
    m1 = 0;
    while((m2 = malloc(10001)) != 0){
     dc7:	83 ec 0c             	sub    $0xc,%esp
     dca:	68 11 27 00 00       	push   $0x2711
     dcf:	e8 33 35 00 00       	call   4307 <malloc>
     dd4:	83 c4 10             	add    $0x10,%esp
     dd7:	89 45 e8             	mov    %eax,-0x18(%ebp)
     dda:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     dde:	75 d9                	jne    db9 <mem+0x3b>
      *(char**)m2 = m1;
      m1 = m2;
    }
    while(m1){
     de0:	eb 1c                	jmp    dfe <mem+0x80>
      m2 = *(char**)m1;
     de2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     de5:	8b 00                	mov    (%eax),%eax
     de7:	89 45 e8             	mov    %eax,-0x18(%ebp)
      free(m1);
     dea:	83 ec 0c             	sub    $0xc,%esp
     ded:	ff 75 f4             	pushl  -0xc(%ebp)
     df0:	e8 d1 33 00 00       	call   41c6 <free>
     df5:	83 c4 10             	add    $0x10,%esp
      m1 = m2;
     df8:	8b 45 e8             	mov    -0x18(%ebp),%eax
     dfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    m1 = 0;
    while((m2 = malloc(10001)) != 0){
      *(char**)m2 = m1;
      m1 = m2;
    }
    while(m1){
     dfe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     e02:	75 de                	jne    de2 <mem+0x64>
      m2 = *(char**)m1;
      free(m1);
      m1 = m2;
    }
    m1 = malloc(1024*20);
     e04:	83 ec 0c             	sub    $0xc,%esp
     e07:	68 00 50 00 00       	push   $0x5000
     e0c:	e8 f6 34 00 00       	call   4307 <malloc>
     e11:	83 c4 10             	add    $0x10,%esp
     e14:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(m1 == 0){
     e17:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     e1b:	75 25                	jne    e42 <mem+0xc4>
      printf(1, "couldn't allocate mem?!!\n");
     e1d:	83 ec 08             	sub    $0x8,%esp
     e20:	68 31 49 00 00       	push   $0x4931
     e25:	6a 01                	push   $0x1
     e27:	e8 0a 32 00 00       	call   4036 <printf>
     e2c:	83 c4 10             	add    $0x10,%esp
      kill(ppid);
     e2f:	83 ec 0c             	sub    $0xc,%esp
     e32:	ff 75 f0             	pushl  -0x10(%ebp)
     e35:	e8 af 30 00 00       	call   3ee9 <kill>
     e3a:	83 c4 10             	add    $0x10,%esp
      exit();
     e3d:	e8 77 30 00 00       	call   3eb9 <exit>
    }
    free(m1);
     e42:	83 ec 0c             	sub    $0xc,%esp
     e45:	ff 75 f4             	pushl  -0xc(%ebp)
     e48:	e8 79 33 00 00       	call   41c6 <free>
     e4d:	83 c4 10             	add    $0x10,%esp
    printf(1, "mem ok\n");
     e50:	83 ec 08             	sub    $0x8,%esp
     e53:	68 4b 49 00 00       	push   $0x494b
     e58:	6a 01                	push   $0x1
     e5a:	e8 d7 31 00 00       	call   4036 <printf>
     e5f:	83 c4 10             	add    $0x10,%esp
    exit();
     e62:	e8 52 30 00 00       	call   3eb9 <exit>
  } else {
    wait();
     e67:	e8 55 30 00 00       	call   3ec1 <wait>
  }
}
     e6c:	c9                   	leave  
     e6d:	c3                   	ret    

00000e6e <sharedfd>:

// two processes write to the same file descriptor
// is the offset shared? does inode locking work?
void
sharedfd(void)
{
     e6e:	55                   	push   %ebp
     e6f:	89 e5                	mov    %esp,%ebp
     e71:	83 ec 38             	sub    $0x38,%esp
  int fd, pid, i, n, nc, np;
  char buf[10];

  printf(1, "sharedfd test\n");
     e74:	83 ec 08             	sub    $0x8,%esp
     e77:	68 53 49 00 00       	push   $0x4953
     e7c:	6a 01                	push   $0x1
     e7e:	e8 b3 31 00 00       	call   4036 <printf>
     e83:	83 c4 10             	add    $0x10,%esp

  unlink("sharedfd");
     e86:	83 ec 0c             	sub    $0xc,%esp
     e89:	68 62 49 00 00       	push   $0x4962
     e8e:	e8 76 30 00 00       	call   3f09 <unlink>
     e93:	83 c4 10             	add    $0x10,%esp
  fd = open("sharedfd", O_CREATE|O_RDWR);
     e96:	83 ec 08             	sub    $0x8,%esp
     e99:	68 02 02 00 00       	push   $0x202
     e9e:	68 62 49 00 00       	push   $0x4962
     ea3:	e8 51 30 00 00       	call   3ef9 <open>
     ea8:	83 c4 10             	add    $0x10,%esp
     eab:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(fd < 0){
     eae:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     eb2:	79 17                	jns    ecb <sharedfd+0x5d>
    printf(1, "fstests: cannot open sharedfd for writing");
     eb4:	83 ec 08             	sub    $0x8,%esp
     eb7:	68 6c 49 00 00       	push   $0x496c
     ebc:	6a 01                	push   $0x1
     ebe:	e8 73 31 00 00       	call   4036 <printf>
     ec3:	83 c4 10             	add    $0x10,%esp
    return;
     ec6:	e9 84 01 00 00       	jmp    104f <sharedfd+0x1e1>
  }
  pid = fork();
     ecb:	e8 e1 2f 00 00       	call   3eb1 <fork>
     ed0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  memset(buf, pid==0?'c':'p', sizeof(buf));
     ed3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     ed7:	75 07                	jne    ee0 <sharedfd+0x72>
     ed9:	b8 63 00 00 00       	mov    $0x63,%eax
     ede:	eb 05                	jmp    ee5 <sharedfd+0x77>
     ee0:	b8 70 00 00 00       	mov    $0x70,%eax
     ee5:	83 ec 04             	sub    $0x4,%esp
     ee8:	6a 0a                	push   $0xa
     eea:	50                   	push   %eax
     eeb:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     eee:	50                   	push   %eax
     eef:	e8 2b 2e 00 00       	call   3d1f <memset>
     ef4:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 1000; i++){
     ef7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     efe:	eb 31                	jmp    f31 <sharedfd+0xc3>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
     f00:	83 ec 04             	sub    $0x4,%esp
     f03:	6a 0a                	push   $0xa
     f05:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     f08:	50                   	push   %eax
     f09:	ff 75 e8             	pushl  -0x18(%ebp)
     f0c:	e8 c8 2f 00 00       	call   3ed9 <write>
     f11:	83 c4 10             	add    $0x10,%esp
     f14:	83 f8 0a             	cmp    $0xa,%eax
     f17:	74 14                	je     f2d <sharedfd+0xbf>
      printf(1, "fstests: write sharedfd failed\n");
     f19:	83 ec 08             	sub    $0x8,%esp
     f1c:	68 98 49 00 00       	push   $0x4998
     f21:	6a 01                	push   $0x1
     f23:	e8 0e 31 00 00       	call   4036 <printf>
     f28:	83 c4 10             	add    $0x10,%esp
      break;
     f2b:	eb 0d                	jmp    f3a <sharedfd+0xcc>
    printf(1, "fstests: cannot open sharedfd for writing");
    return;
  }
  pid = fork();
  memset(buf, pid==0?'c':'p', sizeof(buf));
  for(i = 0; i < 1000; i++){
     f2d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     f31:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
     f38:	7e c6                	jle    f00 <sharedfd+0x92>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
      printf(1, "fstests: write sharedfd failed\n");
      break;
    }
  }
  if(pid == 0)
     f3a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     f3e:	75 05                	jne    f45 <sharedfd+0xd7>
    exit();
     f40:	e8 74 2f 00 00       	call   3eb9 <exit>
  else
    wait();
     f45:	e8 77 2f 00 00       	call   3ec1 <wait>
  close(fd);
     f4a:	83 ec 0c             	sub    $0xc,%esp
     f4d:	ff 75 e8             	pushl  -0x18(%ebp)
     f50:	e8 8c 2f 00 00       	call   3ee1 <close>
     f55:	83 c4 10             	add    $0x10,%esp
  fd = open("sharedfd", 0);
     f58:	83 ec 08             	sub    $0x8,%esp
     f5b:	6a 00                	push   $0x0
     f5d:	68 62 49 00 00       	push   $0x4962
     f62:	e8 92 2f 00 00       	call   3ef9 <open>
     f67:	83 c4 10             	add    $0x10,%esp
     f6a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(fd < 0){
     f6d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     f71:	79 17                	jns    f8a <sharedfd+0x11c>
    printf(1, "fstests: cannot open sharedfd for reading\n");
     f73:	83 ec 08             	sub    $0x8,%esp
     f76:	68 b8 49 00 00       	push   $0x49b8
     f7b:	6a 01                	push   $0x1
     f7d:	e8 b4 30 00 00       	call   4036 <printf>
     f82:	83 c4 10             	add    $0x10,%esp
    return;
     f85:	e9 c5 00 00 00       	jmp    104f <sharedfd+0x1e1>
  }
  nc = np = 0;
     f8a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     f91:	8b 45 ec             	mov    -0x14(%ebp),%eax
     f94:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
     f97:	eb 3b                	jmp    fd4 <sharedfd+0x166>
    for(i = 0; i < sizeof(buf); i++){
     f99:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     fa0:	eb 2a                	jmp    fcc <sharedfd+0x15e>
      if(buf[i] == 'c')
     fa2:	8d 55 d6             	lea    -0x2a(%ebp),%edx
     fa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fa8:	01 d0                	add    %edx,%eax
     faa:	0f b6 00             	movzbl (%eax),%eax
     fad:	3c 63                	cmp    $0x63,%al
     faf:	75 04                	jne    fb5 <sharedfd+0x147>
        nc++;
     fb1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(buf[i] == 'p')
     fb5:	8d 55 d6             	lea    -0x2a(%ebp),%edx
     fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fbb:	01 d0                	add    %edx,%eax
     fbd:	0f b6 00             	movzbl (%eax),%eax
     fc0:	3c 70                	cmp    $0x70,%al
     fc2:	75 04                	jne    fc8 <sharedfd+0x15a>
        np++;
     fc4:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i = 0; i < sizeof(buf); i++){
     fc8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     fcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fcf:	83 f8 09             	cmp    $0x9,%eax
     fd2:	76 ce                	jbe    fa2 <sharedfd+0x134>
  if(fd < 0){
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
     fd4:	83 ec 04             	sub    $0x4,%esp
     fd7:	6a 0a                	push   $0xa
     fd9:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     fdc:	50                   	push   %eax
     fdd:	ff 75 e8             	pushl  -0x18(%ebp)
     fe0:	e8 ec 2e 00 00       	call   3ed1 <read>
     fe5:	83 c4 10             	add    $0x10,%esp
     fe8:	89 45 e0             	mov    %eax,-0x20(%ebp)
     feb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     fef:	7f a8                	jg     f99 <sharedfd+0x12b>
        nc++;
      if(buf[i] == 'p')
        np++;
    }
  }
  close(fd);
     ff1:	83 ec 0c             	sub    $0xc,%esp
     ff4:	ff 75 e8             	pushl  -0x18(%ebp)
     ff7:	e8 e5 2e 00 00       	call   3ee1 <close>
     ffc:	83 c4 10             	add    $0x10,%esp
  unlink("sharedfd");
     fff:	83 ec 0c             	sub    $0xc,%esp
    1002:	68 62 49 00 00       	push   $0x4962
    1007:	e8 fd 2e 00 00       	call   3f09 <unlink>
    100c:	83 c4 10             	add    $0x10,%esp
  if(nc == 10000 && np == 10000){
    100f:	81 7d f0 10 27 00 00 	cmpl   $0x2710,-0x10(%ebp)
    1016:	75 1d                	jne    1035 <sharedfd+0x1c7>
    1018:	81 7d ec 10 27 00 00 	cmpl   $0x2710,-0x14(%ebp)
    101f:	75 14                	jne    1035 <sharedfd+0x1c7>
    printf(1, "sharedfd ok\n");
    1021:	83 ec 08             	sub    $0x8,%esp
    1024:	68 e3 49 00 00       	push   $0x49e3
    1029:	6a 01                	push   $0x1
    102b:	e8 06 30 00 00       	call   4036 <printf>
    1030:	83 c4 10             	add    $0x10,%esp
    1033:	eb 1a                	jmp    104f <sharedfd+0x1e1>
  } else {
    printf(1, "sharedfd oops %d %d\n", nc, np);
    1035:	ff 75 ec             	pushl  -0x14(%ebp)
    1038:	ff 75 f0             	pushl  -0x10(%ebp)
    103b:	68 f0 49 00 00       	push   $0x49f0
    1040:	6a 01                	push   $0x1
    1042:	e8 ef 2f 00 00       	call   4036 <printf>
    1047:	83 c4 10             	add    $0x10,%esp
    exit();
    104a:	e8 6a 2e 00 00       	call   3eb9 <exit>
  }
}
    104f:	c9                   	leave  
    1050:	c3                   	ret    

00001051 <fourfiles>:

// four processes write different files at the same
// time, to test block allocation.
void
fourfiles(void)
{
    1051:	55                   	push   %ebp
    1052:	89 e5                	mov    %esp,%ebp
    1054:	83 ec 38             	sub    $0x38,%esp
  int fd, pid, i, j, n, total, pi;
  char *names[] = { "f0", "f1", "f2", "f3" };
    1057:	c7 45 c8 05 4a 00 00 	movl   $0x4a05,-0x38(%ebp)
    105e:	c7 45 cc 08 4a 00 00 	movl   $0x4a08,-0x34(%ebp)
    1065:	c7 45 d0 0b 4a 00 00 	movl   $0x4a0b,-0x30(%ebp)
    106c:	c7 45 d4 0e 4a 00 00 	movl   $0x4a0e,-0x2c(%ebp)
  char *fname;

  printf(1, "fourfiles test\n");
    1073:	83 ec 08             	sub    $0x8,%esp
    1076:	68 11 4a 00 00       	push   $0x4a11
    107b:	6a 01                	push   $0x1
    107d:	e8 b4 2f 00 00       	call   4036 <printf>
    1082:	83 c4 10             	add    $0x10,%esp

  for(pi = 0; pi < 4; pi++){
    1085:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    108c:	e9 f0 00 00 00       	jmp    1181 <fourfiles+0x130>
    fname = names[pi];
    1091:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1094:	8b 44 85 c8          	mov    -0x38(%ebp,%eax,4),%eax
    1098:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    unlink(fname);
    109b:	83 ec 0c             	sub    $0xc,%esp
    109e:	ff 75 e4             	pushl  -0x1c(%ebp)
    10a1:	e8 63 2e 00 00       	call   3f09 <unlink>
    10a6:	83 c4 10             	add    $0x10,%esp

    pid = fork();
    10a9:	e8 03 2e 00 00       	call   3eb1 <fork>
    10ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if(pid < 0){
    10b1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
    10b5:	79 17                	jns    10ce <fourfiles+0x7d>
      printf(1, "fork failed\n");
    10b7:	83 ec 08             	sub    $0x8,%esp
    10ba:	68 8d 44 00 00       	push   $0x448d
    10bf:	6a 01                	push   $0x1
    10c1:	e8 70 2f 00 00       	call   4036 <printf>
    10c6:	83 c4 10             	add    $0x10,%esp
      exit();
    10c9:	e8 eb 2d 00 00       	call   3eb9 <exit>
    }

    if(pid == 0){
    10ce:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
    10d2:	0f 85 a5 00 00 00    	jne    117d <fourfiles+0x12c>
      fd = open(fname, O_CREATE | O_RDWR);
    10d8:	83 ec 08             	sub    $0x8,%esp
    10db:	68 02 02 00 00       	push   $0x202
    10e0:	ff 75 e4             	pushl  -0x1c(%ebp)
    10e3:	e8 11 2e 00 00       	call   3ef9 <open>
    10e8:	83 c4 10             	add    $0x10,%esp
    10eb:	89 45 dc             	mov    %eax,-0x24(%ebp)
      if(fd < 0){
    10ee:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
    10f2:	79 17                	jns    110b <fourfiles+0xba>
        printf(1, "create failed\n");
    10f4:	83 ec 08             	sub    $0x8,%esp
    10f7:	68 21 4a 00 00       	push   $0x4a21
    10fc:	6a 01                	push   $0x1
    10fe:	e8 33 2f 00 00       	call   4036 <printf>
    1103:	83 c4 10             	add    $0x10,%esp
        exit();
    1106:	e8 ae 2d 00 00       	call   3eb9 <exit>
      }
      
      memset(buf, '0'+pi, 512);
    110b:	8b 45 e8             	mov    -0x18(%ebp),%eax
    110e:	83 c0 30             	add    $0x30,%eax
    1111:	83 ec 04             	sub    $0x4,%esp
    1114:	68 00 02 00 00       	push   $0x200
    1119:	50                   	push   %eax
    111a:	68 00 8b 00 00       	push   $0x8b00
    111f:	e8 fb 2b 00 00       	call   3d1f <memset>
    1124:	83 c4 10             	add    $0x10,%esp
      for(i = 0; i < 12; i++){
    1127:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    112e:	eb 42                	jmp    1172 <fourfiles+0x121>
        if((n = write(fd, buf, 500)) != 500){
    1130:	83 ec 04             	sub    $0x4,%esp
    1133:	68 f4 01 00 00       	push   $0x1f4
    1138:	68 00 8b 00 00       	push   $0x8b00
    113d:	ff 75 dc             	pushl  -0x24(%ebp)
    1140:	e8 94 2d 00 00       	call   3ed9 <write>
    1145:	83 c4 10             	add    $0x10,%esp
    1148:	89 45 d8             	mov    %eax,-0x28(%ebp)
    114b:	81 7d d8 f4 01 00 00 	cmpl   $0x1f4,-0x28(%ebp)
    1152:	74 1a                	je     116e <fourfiles+0x11d>
          printf(1, "write failed %d\n", n);
    1154:	83 ec 04             	sub    $0x4,%esp
    1157:	ff 75 d8             	pushl  -0x28(%ebp)
    115a:	68 30 4a 00 00       	push   $0x4a30
    115f:	6a 01                	push   $0x1
    1161:	e8 d0 2e 00 00       	call   4036 <printf>
    1166:	83 c4 10             	add    $0x10,%esp
          exit();
    1169:	e8 4b 2d 00 00       	call   3eb9 <exit>
        printf(1, "create failed\n");
        exit();
      }
      
      memset(buf, '0'+pi, 512);
      for(i = 0; i < 12; i++){
    116e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1172:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
    1176:	7e b8                	jle    1130 <fourfiles+0xdf>
        if((n = write(fd, buf, 500)) != 500){
          printf(1, "write failed %d\n", n);
          exit();
        }
      }
      exit();
    1178:	e8 3c 2d 00 00       	call   3eb9 <exit>
  char *names[] = { "f0", "f1", "f2", "f3" };
  char *fname;

  printf(1, "fourfiles test\n");

  for(pi = 0; pi < 4; pi++){
    117d:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
    1181:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
    1185:	0f 8e 06 ff ff ff    	jle    1091 <fourfiles+0x40>
      }
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    118b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    1192:	eb 09                	jmp    119d <fourfiles+0x14c>
    wait();
    1194:	e8 28 2d 00 00       	call   3ec1 <wait>
      }
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    1199:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
    119d:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
    11a1:	7e f1                	jle    1194 <fourfiles+0x143>
    wait();
  }

  for(i = 0; i < 2; i++){
    11a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    11aa:	e9 d4 00 00 00       	jmp    1283 <fourfiles+0x232>
    fname = names[i];
    11af:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11b2:	8b 44 85 c8          	mov    -0x38(%ebp,%eax,4),%eax
    11b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    fd = open(fname, 0);
    11b9:	83 ec 08             	sub    $0x8,%esp
    11bc:	6a 00                	push   $0x0
    11be:	ff 75 e4             	pushl  -0x1c(%ebp)
    11c1:	e8 33 2d 00 00       	call   3ef9 <open>
    11c6:	83 c4 10             	add    $0x10,%esp
    11c9:	89 45 dc             	mov    %eax,-0x24(%ebp)
    total = 0;
    11cc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    11d3:	eb 4a                	jmp    121f <fourfiles+0x1ce>
      for(j = 0; j < n; j++){
    11d5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    11dc:	eb 33                	jmp    1211 <fourfiles+0x1c0>
        if(buf[j] != '0'+i){
    11de:	8b 45 f0             	mov    -0x10(%ebp),%eax
    11e1:	05 00 8b 00 00       	add    $0x8b00,%eax
    11e6:	0f b6 00             	movzbl (%eax),%eax
    11e9:	0f be c0             	movsbl %al,%eax
    11ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
    11ef:	83 c2 30             	add    $0x30,%edx
    11f2:	39 d0                	cmp    %edx,%eax
    11f4:	74 17                	je     120d <fourfiles+0x1bc>
          printf(1, "wrong char\n");
    11f6:	83 ec 08             	sub    $0x8,%esp
    11f9:	68 41 4a 00 00       	push   $0x4a41
    11fe:	6a 01                	push   $0x1
    1200:	e8 31 2e 00 00       	call   4036 <printf>
    1205:	83 c4 10             	add    $0x10,%esp
          exit();
    1208:	e8 ac 2c 00 00       	call   3eb9 <exit>
  for(i = 0; i < 2; i++){
    fname = names[i];
    fd = open(fname, 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
      for(j = 0; j < n; j++){
    120d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1211:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1214:	3b 45 d8             	cmp    -0x28(%ebp),%eax
    1217:	7c c5                	jl     11de <fourfiles+0x18d>
        if(buf[j] != '0'+i){
          printf(1, "wrong char\n");
          exit();
        }
      }
      total += n;
    1219:	8b 45 d8             	mov    -0x28(%ebp),%eax
    121c:	01 45 ec             	add    %eax,-0x14(%ebp)

  for(i = 0; i < 2; i++){
    fname = names[i];
    fd = open(fname, 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
    121f:	83 ec 04             	sub    $0x4,%esp
    1222:	68 00 20 00 00       	push   $0x2000
    1227:	68 00 8b 00 00       	push   $0x8b00
    122c:	ff 75 dc             	pushl  -0x24(%ebp)
    122f:	e8 9d 2c 00 00       	call   3ed1 <read>
    1234:	83 c4 10             	add    $0x10,%esp
    1237:	89 45 d8             	mov    %eax,-0x28(%ebp)
    123a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
    123e:	7f 95                	jg     11d5 <fourfiles+0x184>
          exit();
        }
      }
      total += n;
    }
    close(fd);
    1240:	83 ec 0c             	sub    $0xc,%esp
    1243:	ff 75 dc             	pushl  -0x24(%ebp)
    1246:	e8 96 2c 00 00       	call   3ee1 <close>
    124b:	83 c4 10             	add    $0x10,%esp
    if(total != 12*500){
    124e:	81 7d ec 70 17 00 00 	cmpl   $0x1770,-0x14(%ebp)
    1255:	74 1a                	je     1271 <fourfiles+0x220>
      printf(1, "wrong length %d\n", total);
    1257:	83 ec 04             	sub    $0x4,%esp
    125a:	ff 75 ec             	pushl  -0x14(%ebp)
    125d:	68 4d 4a 00 00       	push   $0x4a4d
    1262:	6a 01                	push   $0x1
    1264:	e8 cd 2d 00 00       	call   4036 <printf>
    1269:	83 c4 10             	add    $0x10,%esp
      exit();
    126c:	e8 48 2c 00 00       	call   3eb9 <exit>
    }
    unlink(fname);
    1271:	83 ec 0c             	sub    $0xc,%esp
    1274:	ff 75 e4             	pushl  -0x1c(%ebp)
    1277:	e8 8d 2c 00 00       	call   3f09 <unlink>
    127c:	83 c4 10             	add    $0x10,%esp

  for(pi = 0; pi < 4; pi++){
    wait();
  }

  for(i = 0; i < 2; i++){
    127f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1283:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
    1287:	0f 8e 22 ff ff ff    	jle    11af <fourfiles+0x15e>
      exit();
    }
    unlink(fname);
  }

  printf(1, "fourfiles ok\n");
    128d:	83 ec 08             	sub    $0x8,%esp
    1290:	68 5e 4a 00 00       	push   $0x4a5e
    1295:	6a 01                	push   $0x1
    1297:	e8 9a 2d 00 00       	call   4036 <printf>
    129c:	83 c4 10             	add    $0x10,%esp
}
    129f:	c9                   	leave  
    12a0:	c3                   	ret    

000012a1 <createdelete>:

// four processes create and delete different files in same directory
void
createdelete(void)
{
    12a1:	55                   	push   %ebp
    12a2:	89 e5                	mov    %esp,%ebp
    12a4:	83 ec 38             	sub    $0x38,%esp
  enum { N = 20 };
  int pid, i, fd, pi;
  char name[32];

  printf(1, "createdelete test\n");
    12a7:	83 ec 08             	sub    $0x8,%esp
    12aa:	68 6c 4a 00 00       	push   $0x4a6c
    12af:	6a 01                	push   $0x1
    12b1:	e8 80 2d 00 00       	call   4036 <printf>
    12b6:	83 c4 10             	add    $0x10,%esp

  for(pi = 0; pi < 4; pi++){
    12b9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    12c0:	e9 f6 00 00 00       	jmp    13bb <createdelete+0x11a>
    pid = fork();
    12c5:	e8 e7 2b 00 00       	call   3eb1 <fork>
    12ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pid < 0){
    12cd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    12d1:	79 17                	jns    12ea <createdelete+0x49>
      printf(1, "fork failed\n");
    12d3:	83 ec 08             	sub    $0x8,%esp
    12d6:	68 8d 44 00 00       	push   $0x448d
    12db:	6a 01                	push   $0x1
    12dd:	e8 54 2d 00 00       	call   4036 <printf>
    12e2:	83 c4 10             	add    $0x10,%esp
      exit();
    12e5:	e8 cf 2b 00 00       	call   3eb9 <exit>
    }

    if(pid == 0){
    12ea:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    12ee:	0f 85 c3 00 00 00    	jne    13b7 <createdelete+0x116>
      name[0] = 'p' + pi;
    12f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    12f7:	83 c0 70             	add    $0x70,%eax
    12fa:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[2] = '\0';
    12fd:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
      for(i = 0; i < N; i++){
    1301:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1308:	e9 9b 00 00 00       	jmp    13a8 <createdelete+0x107>
        name[1] = '0' + i;
    130d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1310:	83 c0 30             	add    $0x30,%eax
    1313:	88 45 c9             	mov    %al,-0x37(%ebp)
        fd = open(name, O_CREATE | O_RDWR);
    1316:	83 ec 08             	sub    $0x8,%esp
    1319:	68 02 02 00 00       	push   $0x202
    131e:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1321:	50                   	push   %eax
    1322:	e8 d2 2b 00 00       	call   3ef9 <open>
    1327:	83 c4 10             	add    $0x10,%esp
    132a:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if(fd < 0){
    132d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1331:	79 17                	jns    134a <createdelete+0xa9>
          printf(1, "create failed\n");
    1333:	83 ec 08             	sub    $0x8,%esp
    1336:	68 21 4a 00 00       	push   $0x4a21
    133b:	6a 01                	push   $0x1
    133d:	e8 f4 2c 00 00       	call   4036 <printf>
    1342:	83 c4 10             	add    $0x10,%esp
          exit();
    1345:	e8 6f 2b 00 00       	call   3eb9 <exit>
        }
        close(fd);
    134a:	83 ec 0c             	sub    $0xc,%esp
    134d:	ff 75 e8             	pushl  -0x18(%ebp)
    1350:	e8 8c 2b 00 00       	call   3ee1 <close>
    1355:	83 c4 10             	add    $0x10,%esp
        if(i > 0 && (i % 2 ) == 0){
    1358:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    135c:	7e 46                	jle    13a4 <createdelete+0x103>
    135e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1361:	83 e0 01             	and    $0x1,%eax
    1364:	85 c0                	test   %eax,%eax
    1366:	75 3c                	jne    13a4 <createdelete+0x103>
          name[1] = '0' + (i / 2);
    1368:	8b 45 f4             	mov    -0xc(%ebp),%eax
    136b:	89 c2                	mov    %eax,%edx
    136d:	c1 ea 1f             	shr    $0x1f,%edx
    1370:	01 d0                	add    %edx,%eax
    1372:	d1 f8                	sar    %eax
    1374:	83 c0 30             	add    $0x30,%eax
    1377:	88 45 c9             	mov    %al,-0x37(%ebp)
          if(unlink(name) < 0){
    137a:	83 ec 0c             	sub    $0xc,%esp
    137d:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1380:	50                   	push   %eax
    1381:	e8 83 2b 00 00       	call   3f09 <unlink>
    1386:	83 c4 10             	add    $0x10,%esp
    1389:	85 c0                	test   %eax,%eax
    138b:	79 17                	jns    13a4 <createdelete+0x103>
            printf(1, "unlink failed\n");
    138d:	83 ec 08             	sub    $0x8,%esp
    1390:	68 10 45 00 00       	push   $0x4510
    1395:	6a 01                	push   $0x1
    1397:	e8 9a 2c 00 00       	call   4036 <printf>
    139c:	83 c4 10             	add    $0x10,%esp
            exit();
    139f:	e8 15 2b 00 00       	call   3eb9 <exit>
    }

    if(pid == 0){
      name[0] = 'p' + pi;
      name[2] = '\0';
      for(i = 0; i < N; i++){
    13a4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    13a8:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    13ac:	0f 8e 5b ff ff ff    	jle    130d <createdelete+0x6c>
            printf(1, "unlink failed\n");
            exit();
          }
        }
      }
      exit();
    13b2:	e8 02 2b 00 00       	call   3eb9 <exit>
  int pid, i, fd, pi;
  char name[32];

  printf(1, "createdelete test\n");

  for(pi = 0; pi < 4; pi++){
    13b7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    13bb:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    13bf:	0f 8e 00 ff ff ff    	jle    12c5 <createdelete+0x24>
      }
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    13c5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    13cc:	eb 09                	jmp    13d7 <createdelete+0x136>
    wait();
    13ce:	e8 ee 2a 00 00       	call   3ec1 <wait>
      }
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    13d3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    13d7:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    13db:	7e f1                	jle    13ce <createdelete+0x12d>
    wait();
  }

  name[0] = name[1] = name[2] = 0;
    13dd:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
    13e1:	0f b6 45 ca          	movzbl -0x36(%ebp),%eax
    13e5:	88 45 c9             	mov    %al,-0x37(%ebp)
    13e8:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
    13ec:	88 45 c8             	mov    %al,-0x38(%ebp)
  for(i = 0; i < N; i++){
    13ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    13f6:	e9 b2 00 00 00       	jmp    14ad <createdelete+0x20c>
    for(pi = 0; pi < 4; pi++){
    13fb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1402:	e9 98 00 00 00       	jmp    149f <createdelete+0x1fe>
      name[0] = 'p' + pi;
    1407:	8b 45 f0             	mov    -0x10(%ebp),%eax
    140a:	83 c0 70             	add    $0x70,%eax
    140d:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[1] = '0' + i;
    1410:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1413:	83 c0 30             	add    $0x30,%eax
    1416:	88 45 c9             	mov    %al,-0x37(%ebp)
      fd = open(name, 0);
    1419:	83 ec 08             	sub    $0x8,%esp
    141c:	6a 00                	push   $0x0
    141e:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1421:	50                   	push   %eax
    1422:	e8 d2 2a 00 00       	call   3ef9 <open>
    1427:	83 c4 10             	add    $0x10,%esp
    142a:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((i == 0 || i >= N/2) && fd < 0){
    142d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1431:	74 06                	je     1439 <createdelete+0x198>
    1433:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    1437:	7e 21                	jle    145a <createdelete+0x1b9>
    1439:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    143d:	79 1b                	jns    145a <createdelete+0x1b9>
        printf(1, "oops createdelete %s didn't exist\n", name);
    143f:	83 ec 04             	sub    $0x4,%esp
    1442:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1445:	50                   	push   %eax
    1446:	68 80 4a 00 00       	push   $0x4a80
    144b:	6a 01                	push   $0x1
    144d:	e8 e4 2b 00 00       	call   4036 <printf>
    1452:	83 c4 10             	add    $0x10,%esp
        exit();
    1455:	e8 5f 2a 00 00       	call   3eb9 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    145a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    145e:	7e 27                	jle    1487 <createdelete+0x1e6>
    1460:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    1464:	7f 21                	jg     1487 <createdelete+0x1e6>
    1466:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    146a:	78 1b                	js     1487 <createdelete+0x1e6>
        printf(1, "oops createdelete %s did exist\n", name);
    146c:	83 ec 04             	sub    $0x4,%esp
    146f:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1472:	50                   	push   %eax
    1473:	68 a4 4a 00 00       	push   $0x4aa4
    1478:	6a 01                	push   $0x1
    147a:	e8 b7 2b 00 00       	call   4036 <printf>
    147f:	83 c4 10             	add    $0x10,%esp
        exit();
    1482:	e8 32 2a 00 00       	call   3eb9 <exit>
      }
      if(fd >= 0)
    1487:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    148b:	78 0e                	js     149b <createdelete+0x1fa>
        close(fd);
    148d:	83 ec 0c             	sub    $0xc,%esp
    1490:	ff 75 e8             	pushl  -0x18(%ebp)
    1493:	e8 49 2a 00 00       	call   3ee1 <close>
    1498:	83 c4 10             	add    $0x10,%esp
    wait();
  }

  name[0] = name[1] = name[2] = 0;
  for(i = 0; i < N; i++){
    for(pi = 0; pi < 4; pi++){
    149b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    149f:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    14a3:	0f 8e 5e ff ff ff    	jle    1407 <createdelete+0x166>
  for(pi = 0; pi < 4; pi++){
    wait();
  }

  name[0] = name[1] = name[2] = 0;
  for(i = 0; i < N; i++){
    14a9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    14ad:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    14b1:	0f 8e 44 ff ff ff    	jle    13fb <createdelete+0x15a>
      if(fd >= 0)
        close(fd);
    }
  }

  for(i = 0; i < N; i++){
    14b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    14be:	eb 38                	jmp    14f8 <createdelete+0x257>
    for(pi = 0; pi < 4; pi++){
    14c0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    14c7:	eb 25                	jmp    14ee <createdelete+0x24d>
      name[0] = 'p' + i;
    14c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14cc:	83 c0 70             	add    $0x70,%eax
    14cf:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[1] = '0' + i;
    14d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14d5:	83 c0 30             	add    $0x30,%eax
    14d8:	88 45 c9             	mov    %al,-0x37(%ebp)
      unlink(name);
    14db:	83 ec 0c             	sub    $0xc,%esp
    14de:	8d 45 c8             	lea    -0x38(%ebp),%eax
    14e1:	50                   	push   %eax
    14e2:	e8 22 2a 00 00       	call   3f09 <unlink>
    14e7:	83 c4 10             	add    $0x10,%esp
        close(fd);
    }
  }

  for(i = 0; i < N; i++){
    for(pi = 0; pi < 4; pi++){
    14ea:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    14ee:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    14f2:	7e d5                	jle    14c9 <createdelete+0x228>
      if(fd >= 0)
        close(fd);
    }
  }

  for(i = 0; i < N; i++){
    14f4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    14f8:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    14fc:	7e c2                	jle    14c0 <createdelete+0x21f>
      name[1] = '0' + i;
      unlink(name);
    }
  }

  printf(1, "createdelete ok\n");
    14fe:	83 ec 08             	sub    $0x8,%esp
    1501:	68 c4 4a 00 00       	push   $0x4ac4
    1506:	6a 01                	push   $0x1
    1508:	e8 29 2b 00 00       	call   4036 <printf>
    150d:	83 c4 10             	add    $0x10,%esp
}
    1510:	c9                   	leave  
    1511:	c3                   	ret    

00001512 <unlinkread>:

// can I unlink a file and still read it?
void
unlinkread(void)
{
    1512:	55                   	push   %ebp
    1513:	89 e5                	mov    %esp,%ebp
    1515:	83 ec 18             	sub    $0x18,%esp
  int fd, fd1;

  printf(1, "unlinkread test\n");
    1518:	83 ec 08             	sub    $0x8,%esp
    151b:	68 d5 4a 00 00       	push   $0x4ad5
    1520:	6a 01                	push   $0x1
    1522:	e8 0f 2b 00 00       	call   4036 <printf>
    1527:	83 c4 10             	add    $0x10,%esp
  fd = open("unlinkread", O_CREATE | O_RDWR);
    152a:	83 ec 08             	sub    $0x8,%esp
    152d:	68 02 02 00 00       	push   $0x202
    1532:	68 e6 4a 00 00       	push   $0x4ae6
    1537:	e8 bd 29 00 00       	call   3ef9 <open>
    153c:	83 c4 10             	add    $0x10,%esp
    153f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1542:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1546:	79 17                	jns    155f <unlinkread+0x4d>
    printf(1, "create unlinkread failed\n");
    1548:	83 ec 08             	sub    $0x8,%esp
    154b:	68 f1 4a 00 00       	push   $0x4af1
    1550:	6a 01                	push   $0x1
    1552:	e8 df 2a 00 00       	call   4036 <printf>
    1557:	83 c4 10             	add    $0x10,%esp
    exit();
    155a:	e8 5a 29 00 00       	call   3eb9 <exit>
  }
  write(fd, "hello", 5);
    155f:	83 ec 04             	sub    $0x4,%esp
    1562:	6a 05                	push   $0x5
    1564:	68 0b 4b 00 00       	push   $0x4b0b
    1569:	ff 75 f4             	pushl  -0xc(%ebp)
    156c:	e8 68 29 00 00       	call   3ed9 <write>
    1571:	83 c4 10             	add    $0x10,%esp
  close(fd);
    1574:	83 ec 0c             	sub    $0xc,%esp
    1577:	ff 75 f4             	pushl  -0xc(%ebp)
    157a:	e8 62 29 00 00       	call   3ee1 <close>
    157f:	83 c4 10             	add    $0x10,%esp

  fd = open("unlinkread", O_RDWR);
    1582:	83 ec 08             	sub    $0x8,%esp
    1585:	6a 02                	push   $0x2
    1587:	68 e6 4a 00 00       	push   $0x4ae6
    158c:	e8 68 29 00 00       	call   3ef9 <open>
    1591:	83 c4 10             	add    $0x10,%esp
    1594:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1597:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    159b:	79 17                	jns    15b4 <unlinkread+0xa2>
    printf(1, "open unlinkread failed\n");
    159d:	83 ec 08             	sub    $0x8,%esp
    15a0:	68 11 4b 00 00       	push   $0x4b11
    15a5:	6a 01                	push   $0x1
    15a7:	e8 8a 2a 00 00       	call   4036 <printf>
    15ac:	83 c4 10             	add    $0x10,%esp
    exit();
    15af:	e8 05 29 00 00       	call   3eb9 <exit>
  }
  if(unlink("unlinkread") != 0){
    15b4:	83 ec 0c             	sub    $0xc,%esp
    15b7:	68 e6 4a 00 00       	push   $0x4ae6
    15bc:	e8 48 29 00 00       	call   3f09 <unlink>
    15c1:	83 c4 10             	add    $0x10,%esp
    15c4:	85 c0                	test   %eax,%eax
    15c6:	74 17                	je     15df <unlinkread+0xcd>
    printf(1, "unlink unlinkread failed\n");
    15c8:	83 ec 08             	sub    $0x8,%esp
    15cb:	68 29 4b 00 00       	push   $0x4b29
    15d0:	6a 01                	push   $0x1
    15d2:	e8 5f 2a 00 00       	call   4036 <printf>
    15d7:	83 c4 10             	add    $0x10,%esp
    exit();
    15da:	e8 da 28 00 00       	call   3eb9 <exit>
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    15df:	83 ec 08             	sub    $0x8,%esp
    15e2:	68 02 02 00 00       	push   $0x202
    15e7:	68 e6 4a 00 00       	push   $0x4ae6
    15ec:	e8 08 29 00 00       	call   3ef9 <open>
    15f1:	83 c4 10             	add    $0x10,%esp
    15f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  write(fd1, "yyy", 3);
    15f7:	83 ec 04             	sub    $0x4,%esp
    15fa:	6a 03                	push   $0x3
    15fc:	68 43 4b 00 00       	push   $0x4b43
    1601:	ff 75 f0             	pushl  -0x10(%ebp)
    1604:	e8 d0 28 00 00       	call   3ed9 <write>
    1609:	83 c4 10             	add    $0x10,%esp
  close(fd1);
    160c:	83 ec 0c             	sub    $0xc,%esp
    160f:	ff 75 f0             	pushl  -0x10(%ebp)
    1612:	e8 ca 28 00 00       	call   3ee1 <close>
    1617:	83 c4 10             	add    $0x10,%esp

  if(read(fd, buf, sizeof(buf)) != 5){
    161a:	83 ec 04             	sub    $0x4,%esp
    161d:	68 00 20 00 00       	push   $0x2000
    1622:	68 00 8b 00 00       	push   $0x8b00
    1627:	ff 75 f4             	pushl  -0xc(%ebp)
    162a:	e8 a2 28 00 00       	call   3ed1 <read>
    162f:	83 c4 10             	add    $0x10,%esp
    1632:	83 f8 05             	cmp    $0x5,%eax
    1635:	74 17                	je     164e <unlinkread+0x13c>
    printf(1, "unlinkread read failed");
    1637:	83 ec 08             	sub    $0x8,%esp
    163a:	68 47 4b 00 00       	push   $0x4b47
    163f:	6a 01                	push   $0x1
    1641:	e8 f0 29 00 00       	call   4036 <printf>
    1646:	83 c4 10             	add    $0x10,%esp
    exit();
    1649:	e8 6b 28 00 00       	call   3eb9 <exit>
  }
  if(buf[0] != 'h'){
    164e:	0f b6 05 00 8b 00 00 	movzbl 0x8b00,%eax
    1655:	3c 68                	cmp    $0x68,%al
    1657:	74 17                	je     1670 <unlinkread+0x15e>
    printf(1, "unlinkread wrong data\n");
    1659:	83 ec 08             	sub    $0x8,%esp
    165c:	68 5e 4b 00 00       	push   $0x4b5e
    1661:	6a 01                	push   $0x1
    1663:	e8 ce 29 00 00       	call   4036 <printf>
    1668:	83 c4 10             	add    $0x10,%esp
    exit();
    166b:	e8 49 28 00 00       	call   3eb9 <exit>
  }
  if(write(fd, buf, 10) != 10){
    1670:	83 ec 04             	sub    $0x4,%esp
    1673:	6a 0a                	push   $0xa
    1675:	68 00 8b 00 00       	push   $0x8b00
    167a:	ff 75 f4             	pushl  -0xc(%ebp)
    167d:	e8 57 28 00 00       	call   3ed9 <write>
    1682:	83 c4 10             	add    $0x10,%esp
    1685:	83 f8 0a             	cmp    $0xa,%eax
    1688:	74 17                	je     16a1 <unlinkread+0x18f>
    printf(1, "unlinkread write failed\n");
    168a:	83 ec 08             	sub    $0x8,%esp
    168d:	68 75 4b 00 00       	push   $0x4b75
    1692:	6a 01                	push   $0x1
    1694:	e8 9d 29 00 00       	call   4036 <printf>
    1699:	83 c4 10             	add    $0x10,%esp
    exit();
    169c:	e8 18 28 00 00       	call   3eb9 <exit>
  }
  close(fd);
    16a1:	83 ec 0c             	sub    $0xc,%esp
    16a4:	ff 75 f4             	pushl  -0xc(%ebp)
    16a7:	e8 35 28 00 00       	call   3ee1 <close>
    16ac:	83 c4 10             	add    $0x10,%esp
  unlink("unlinkread");
    16af:	83 ec 0c             	sub    $0xc,%esp
    16b2:	68 e6 4a 00 00       	push   $0x4ae6
    16b7:	e8 4d 28 00 00       	call   3f09 <unlink>
    16bc:	83 c4 10             	add    $0x10,%esp
  printf(1, "unlinkread ok\n");
    16bf:	83 ec 08             	sub    $0x8,%esp
    16c2:	68 8e 4b 00 00       	push   $0x4b8e
    16c7:	6a 01                	push   $0x1
    16c9:	e8 68 29 00 00       	call   4036 <printf>
    16ce:	83 c4 10             	add    $0x10,%esp
}
    16d1:	c9                   	leave  
    16d2:	c3                   	ret    

000016d3 <linktest>:

void
linktest(void)
{
    16d3:	55                   	push   %ebp
    16d4:	89 e5                	mov    %esp,%ebp
    16d6:	83 ec 18             	sub    $0x18,%esp
  int fd;

  printf(1, "linktest\n");
    16d9:	83 ec 08             	sub    $0x8,%esp
    16dc:	68 9d 4b 00 00       	push   $0x4b9d
    16e1:	6a 01                	push   $0x1
    16e3:	e8 4e 29 00 00       	call   4036 <printf>
    16e8:	83 c4 10             	add    $0x10,%esp

  unlink("lf1");
    16eb:	83 ec 0c             	sub    $0xc,%esp
    16ee:	68 a7 4b 00 00       	push   $0x4ba7
    16f3:	e8 11 28 00 00       	call   3f09 <unlink>
    16f8:	83 c4 10             	add    $0x10,%esp
  unlink("lf2");
    16fb:	83 ec 0c             	sub    $0xc,%esp
    16fe:	68 ab 4b 00 00       	push   $0x4bab
    1703:	e8 01 28 00 00       	call   3f09 <unlink>
    1708:	83 c4 10             	add    $0x10,%esp

  fd = open("lf1", O_CREATE|O_RDWR);
    170b:	83 ec 08             	sub    $0x8,%esp
    170e:	68 02 02 00 00       	push   $0x202
    1713:	68 a7 4b 00 00       	push   $0x4ba7
    1718:	e8 dc 27 00 00       	call   3ef9 <open>
    171d:	83 c4 10             	add    $0x10,%esp
    1720:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1723:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1727:	79 17                	jns    1740 <linktest+0x6d>
    printf(1, "create lf1 failed\n");
    1729:	83 ec 08             	sub    $0x8,%esp
    172c:	68 af 4b 00 00       	push   $0x4baf
    1731:	6a 01                	push   $0x1
    1733:	e8 fe 28 00 00       	call   4036 <printf>
    1738:	83 c4 10             	add    $0x10,%esp
    exit();
    173b:	e8 79 27 00 00       	call   3eb9 <exit>
  }
  if(write(fd, "hello", 5) != 5){
    1740:	83 ec 04             	sub    $0x4,%esp
    1743:	6a 05                	push   $0x5
    1745:	68 0b 4b 00 00       	push   $0x4b0b
    174a:	ff 75 f4             	pushl  -0xc(%ebp)
    174d:	e8 87 27 00 00       	call   3ed9 <write>
    1752:	83 c4 10             	add    $0x10,%esp
    1755:	83 f8 05             	cmp    $0x5,%eax
    1758:	74 17                	je     1771 <linktest+0x9e>
    printf(1, "write lf1 failed\n");
    175a:	83 ec 08             	sub    $0x8,%esp
    175d:	68 c2 4b 00 00       	push   $0x4bc2
    1762:	6a 01                	push   $0x1
    1764:	e8 cd 28 00 00       	call   4036 <printf>
    1769:	83 c4 10             	add    $0x10,%esp
    exit();
    176c:	e8 48 27 00 00       	call   3eb9 <exit>
  }
  close(fd);
    1771:	83 ec 0c             	sub    $0xc,%esp
    1774:	ff 75 f4             	pushl  -0xc(%ebp)
    1777:	e8 65 27 00 00       	call   3ee1 <close>
    177c:	83 c4 10             	add    $0x10,%esp

  if(link("lf1", "lf2") < 0){
    177f:	83 ec 08             	sub    $0x8,%esp
    1782:	68 ab 4b 00 00       	push   $0x4bab
    1787:	68 a7 4b 00 00       	push   $0x4ba7
    178c:	e8 88 27 00 00       	call   3f19 <link>
    1791:	83 c4 10             	add    $0x10,%esp
    1794:	85 c0                	test   %eax,%eax
    1796:	79 17                	jns    17af <linktest+0xdc>
    printf(1, "link lf1 lf2 failed\n");
    1798:	83 ec 08             	sub    $0x8,%esp
    179b:	68 d4 4b 00 00       	push   $0x4bd4
    17a0:	6a 01                	push   $0x1
    17a2:	e8 8f 28 00 00       	call   4036 <printf>
    17a7:	83 c4 10             	add    $0x10,%esp
    exit();
    17aa:	e8 0a 27 00 00       	call   3eb9 <exit>
  }
  unlink("lf1");
    17af:	83 ec 0c             	sub    $0xc,%esp
    17b2:	68 a7 4b 00 00       	push   $0x4ba7
    17b7:	e8 4d 27 00 00       	call   3f09 <unlink>
    17bc:	83 c4 10             	add    $0x10,%esp

  if(open("lf1", 0) >= 0){
    17bf:	83 ec 08             	sub    $0x8,%esp
    17c2:	6a 00                	push   $0x0
    17c4:	68 a7 4b 00 00       	push   $0x4ba7
    17c9:	e8 2b 27 00 00       	call   3ef9 <open>
    17ce:	83 c4 10             	add    $0x10,%esp
    17d1:	85 c0                	test   %eax,%eax
    17d3:	78 17                	js     17ec <linktest+0x119>
    printf(1, "unlinked lf1 but it is still there!\n");
    17d5:	83 ec 08             	sub    $0x8,%esp
    17d8:	68 ec 4b 00 00       	push   $0x4bec
    17dd:	6a 01                	push   $0x1
    17df:	e8 52 28 00 00       	call   4036 <printf>
    17e4:	83 c4 10             	add    $0x10,%esp
    exit();
    17e7:	e8 cd 26 00 00       	call   3eb9 <exit>
  }

  fd = open("lf2", 0);
    17ec:	83 ec 08             	sub    $0x8,%esp
    17ef:	6a 00                	push   $0x0
    17f1:	68 ab 4b 00 00       	push   $0x4bab
    17f6:	e8 fe 26 00 00       	call   3ef9 <open>
    17fb:	83 c4 10             	add    $0x10,%esp
    17fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1801:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1805:	79 17                	jns    181e <linktest+0x14b>
    printf(1, "open lf2 failed\n");
    1807:	83 ec 08             	sub    $0x8,%esp
    180a:	68 11 4c 00 00       	push   $0x4c11
    180f:	6a 01                	push   $0x1
    1811:	e8 20 28 00 00       	call   4036 <printf>
    1816:	83 c4 10             	add    $0x10,%esp
    exit();
    1819:	e8 9b 26 00 00       	call   3eb9 <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 5){
    181e:	83 ec 04             	sub    $0x4,%esp
    1821:	68 00 20 00 00       	push   $0x2000
    1826:	68 00 8b 00 00       	push   $0x8b00
    182b:	ff 75 f4             	pushl  -0xc(%ebp)
    182e:	e8 9e 26 00 00       	call   3ed1 <read>
    1833:	83 c4 10             	add    $0x10,%esp
    1836:	83 f8 05             	cmp    $0x5,%eax
    1839:	74 17                	je     1852 <linktest+0x17f>
    printf(1, "read lf2 failed\n");
    183b:	83 ec 08             	sub    $0x8,%esp
    183e:	68 22 4c 00 00       	push   $0x4c22
    1843:	6a 01                	push   $0x1
    1845:	e8 ec 27 00 00       	call   4036 <printf>
    184a:	83 c4 10             	add    $0x10,%esp
    exit();
    184d:	e8 67 26 00 00       	call   3eb9 <exit>
  }
  close(fd);
    1852:	83 ec 0c             	sub    $0xc,%esp
    1855:	ff 75 f4             	pushl  -0xc(%ebp)
    1858:	e8 84 26 00 00       	call   3ee1 <close>
    185d:	83 c4 10             	add    $0x10,%esp

  if(link("lf2", "lf2") >= 0){
    1860:	83 ec 08             	sub    $0x8,%esp
    1863:	68 ab 4b 00 00       	push   $0x4bab
    1868:	68 ab 4b 00 00       	push   $0x4bab
    186d:	e8 a7 26 00 00       	call   3f19 <link>
    1872:	83 c4 10             	add    $0x10,%esp
    1875:	85 c0                	test   %eax,%eax
    1877:	78 17                	js     1890 <linktest+0x1bd>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    1879:	83 ec 08             	sub    $0x8,%esp
    187c:	68 33 4c 00 00       	push   $0x4c33
    1881:	6a 01                	push   $0x1
    1883:	e8 ae 27 00 00       	call   4036 <printf>
    1888:	83 c4 10             	add    $0x10,%esp
    exit();
    188b:	e8 29 26 00 00       	call   3eb9 <exit>
  }

  unlink("lf2");
    1890:	83 ec 0c             	sub    $0xc,%esp
    1893:	68 ab 4b 00 00       	push   $0x4bab
    1898:	e8 6c 26 00 00       	call   3f09 <unlink>
    189d:	83 c4 10             	add    $0x10,%esp
  if(link("lf2", "lf1") >= 0){
    18a0:	83 ec 08             	sub    $0x8,%esp
    18a3:	68 a7 4b 00 00       	push   $0x4ba7
    18a8:	68 ab 4b 00 00       	push   $0x4bab
    18ad:	e8 67 26 00 00       	call   3f19 <link>
    18b2:	83 c4 10             	add    $0x10,%esp
    18b5:	85 c0                	test   %eax,%eax
    18b7:	78 17                	js     18d0 <linktest+0x1fd>
    printf(1, "link non-existant succeeded! oops\n");
    18b9:	83 ec 08             	sub    $0x8,%esp
    18bc:	68 54 4c 00 00       	push   $0x4c54
    18c1:	6a 01                	push   $0x1
    18c3:	e8 6e 27 00 00       	call   4036 <printf>
    18c8:	83 c4 10             	add    $0x10,%esp
    exit();
    18cb:	e8 e9 25 00 00       	call   3eb9 <exit>
  }

  if(link(".", "lf1") >= 0){
    18d0:	83 ec 08             	sub    $0x8,%esp
    18d3:	68 a7 4b 00 00       	push   $0x4ba7
    18d8:	68 77 4c 00 00       	push   $0x4c77
    18dd:	e8 37 26 00 00       	call   3f19 <link>
    18e2:	83 c4 10             	add    $0x10,%esp
    18e5:	85 c0                	test   %eax,%eax
    18e7:	78 17                	js     1900 <linktest+0x22d>
    printf(1, "link . lf1 succeeded! oops\n");
    18e9:	83 ec 08             	sub    $0x8,%esp
    18ec:	68 79 4c 00 00       	push   $0x4c79
    18f1:	6a 01                	push   $0x1
    18f3:	e8 3e 27 00 00       	call   4036 <printf>
    18f8:	83 c4 10             	add    $0x10,%esp
    exit();
    18fb:	e8 b9 25 00 00       	call   3eb9 <exit>
  }

  printf(1, "linktest ok\n");
    1900:	83 ec 08             	sub    $0x8,%esp
    1903:	68 95 4c 00 00       	push   $0x4c95
    1908:	6a 01                	push   $0x1
    190a:	e8 27 27 00 00       	call   4036 <printf>
    190f:	83 c4 10             	add    $0x10,%esp
}
    1912:	c9                   	leave  
    1913:	c3                   	ret    

00001914 <concreate>:

// test concurrent create/link/unlink of the same file
void
concreate(void)
{
    1914:	55                   	push   %ebp
    1915:	89 e5                	mov    %esp,%ebp
    1917:	83 ec 58             	sub    $0x58,%esp
  struct {
    ushort inum;
    char name[14];
  } de;

  printf(1, "concreate test\n");
    191a:	83 ec 08             	sub    $0x8,%esp
    191d:	68 a2 4c 00 00       	push   $0x4ca2
    1922:	6a 01                	push   $0x1
    1924:	e8 0d 27 00 00       	call   4036 <printf>
    1929:	83 c4 10             	add    $0x10,%esp
  file[0] = 'C';
    192c:	c6 45 e5 43          	movb   $0x43,-0x1b(%ebp)
  file[2] = '\0';
    1930:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
  for(i = 0; i < 40; i++){
    1934:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    193b:	e9 fc 00 00 00       	jmp    1a3c <concreate+0x128>
    file[1] = '0' + i;
    1940:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1943:	83 c0 30             	add    $0x30,%eax
    1946:	88 45 e6             	mov    %al,-0x1a(%ebp)
    unlink(file);
    1949:	83 ec 0c             	sub    $0xc,%esp
    194c:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    194f:	50                   	push   %eax
    1950:	e8 b4 25 00 00       	call   3f09 <unlink>
    1955:	83 c4 10             	add    $0x10,%esp
    pid = fork();
    1958:	e8 54 25 00 00       	call   3eb1 <fork>
    195d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pid && (i % 3) == 1){
    1960:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1964:	74 3b                	je     19a1 <concreate+0x8d>
    1966:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1969:	ba 56 55 55 55       	mov    $0x55555556,%edx
    196e:	89 c8                	mov    %ecx,%eax
    1970:	f7 ea                	imul   %edx
    1972:	89 c8                	mov    %ecx,%eax
    1974:	c1 f8 1f             	sar    $0x1f,%eax
    1977:	29 c2                	sub    %eax,%edx
    1979:	89 d0                	mov    %edx,%eax
    197b:	01 c0                	add    %eax,%eax
    197d:	01 d0                	add    %edx,%eax
    197f:	29 c1                	sub    %eax,%ecx
    1981:	89 ca                	mov    %ecx,%edx
    1983:	83 fa 01             	cmp    $0x1,%edx
    1986:	75 19                	jne    19a1 <concreate+0x8d>
      link("C0", file);
    1988:	83 ec 08             	sub    $0x8,%esp
    198b:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    198e:	50                   	push   %eax
    198f:	68 b2 4c 00 00       	push   $0x4cb2
    1994:	e8 80 25 00 00       	call   3f19 <link>
    1999:	83 c4 10             	add    $0x10,%esp
    199c:	e9 87 00 00 00       	jmp    1a28 <concreate+0x114>
    } else if(pid == 0 && (i % 5) == 1){
    19a1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    19a5:	75 3b                	jne    19e2 <concreate+0xce>
    19a7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    19aa:	ba 67 66 66 66       	mov    $0x66666667,%edx
    19af:	89 c8                	mov    %ecx,%eax
    19b1:	f7 ea                	imul   %edx
    19b3:	d1 fa                	sar    %edx
    19b5:	89 c8                	mov    %ecx,%eax
    19b7:	c1 f8 1f             	sar    $0x1f,%eax
    19ba:	29 c2                	sub    %eax,%edx
    19bc:	89 d0                	mov    %edx,%eax
    19be:	c1 e0 02             	shl    $0x2,%eax
    19c1:	01 d0                	add    %edx,%eax
    19c3:	29 c1                	sub    %eax,%ecx
    19c5:	89 ca                	mov    %ecx,%edx
    19c7:	83 fa 01             	cmp    $0x1,%edx
    19ca:	75 16                	jne    19e2 <concreate+0xce>
      link("C0", file);
    19cc:	83 ec 08             	sub    $0x8,%esp
    19cf:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    19d2:	50                   	push   %eax
    19d3:	68 b2 4c 00 00       	push   $0x4cb2
    19d8:	e8 3c 25 00 00       	call   3f19 <link>
    19dd:	83 c4 10             	add    $0x10,%esp
    19e0:	eb 46                	jmp    1a28 <concreate+0x114>
    } else {
      fd = open(file, O_CREATE | O_RDWR);
    19e2:	83 ec 08             	sub    $0x8,%esp
    19e5:	68 02 02 00 00       	push   $0x202
    19ea:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    19ed:	50                   	push   %eax
    19ee:	e8 06 25 00 00       	call   3ef9 <open>
    19f3:	83 c4 10             	add    $0x10,%esp
    19f6:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(fd < 0){
    19f9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    19fd:	79 1b                	jns    1a1a <concreate+0x106>
        printf(1, "concreate create %s failed\n", file);
    19ff:	83 ec 04             	sub    $0x4,%esp
    1a02:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1a05:	50                   	push   %eax
    1a06:	68 b5 4c 00 00       	push   $0x4cb5
    1a0b:	6a 01                	push   $0x1
    1a0d:	e8 24 26 00 00       	call   4036 <printf>
    1a12:	83 c4 10             	add    $0x10,%esp
        exit();
    1a15:	e8 9f 24 00 00       	call   3eb9 <exit>
      }
      close(fd);
    1a1a:	83 ec 0c             	sub    $0xc,%esp
    1a1d:	ff 75 e8             	pushl  -0x18(%ebp)
    1a20:	e8 bc 24 00 00       	call   3ee1 <close>
    1a25:	83 c4 10             	add    $0x10,%esp
    }
    if(pid == 0)
    1a28:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1a2c:	75 05                	jne    1a33 <concreate+0x11f>
      exit();
    1a2e:	e8 86 24 00 00       	call   3eb9 <exit>
    else
      wait();
    1a33:	e8 89 24 00 00       	call   3ec1 <wait>
  } de;

  printf(1, "concreate test\n");
  file[0] = 'C';
  file[2] = '\0';
  for(i = 0; i < 40; i++){
    1a38:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1a3c:	83 7d f4 27          	cmpl   $0x27,-0xc(%ebp)
    1a40:	0f 8e fa fe ff ff    	jle    1940 <concreate+0x2c>
      exit();
    else
      wait();
  }

  memset(fa, 0, sizeof(fa));
    1a46:	83 ec 04             	sub    $0x4,%esp
    1a49:	6a 28                	push   $0x28
    1a4b:	6a 00                	push   $0x0
    1a4d:	8d 45 bd             	lea    -0x43(%ebp),%eax
    1a50:	50                   	push   %eax
    1a51:	e8 c9 22 00 00       	call   3d1f <memset>
    1a56:	83 c4 10             	add    $0x10,%esp
  fd = open(".", 0);
    1a59:	83 ec 08             	sub    $0x8,%esp
    1a5c:	6a 00                	push   $0x0
    1a5e:	68 77 4c 00 00       	push   $0x4c77
    1a63:	e8 91 24 00 00       	call   3ef9 <open>
    1a68:	83 c4 10             	add    $0x10,%esp
    1a6b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  n = 0;
    1a6e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  while(read(fd, &de, sizeof(de)) > 0){
    1a75:	e9 93 00 00 00       	jmp    1b0d <concreate+0x1f9>
    if(de.inum == 0)
    1a7a:	0f b7 45 ac          	movzwl -0x54(%ebp),%eax
    1a7e:	66 85 c0             	test   %ax,%ax
    1a81:	75 05                	jne    1a88 <concreate+0x174>
      continue;
    1a83:	e9 85 00 00 00       	jmp    1b0d <concreate+0x1f9>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    1a88:	0f b6 45 ae          	movzbl -0x52(%ebp),%eax
    1a8c:	3c 43                	cmp    $0x43,%al
    1a8e:	75 7d                	jne    1b0d <concreate+0x1f9>
    1a90:	0f b6 45 b0          	movzbl -0x50(%ebp),%eax
    1a94:	84 c0                	test   %al,%al
    1a96:	75 75                	jne    1b0d <concreate+0x1f9>
      i = de.name[1] - '0';
    1a98:	0f b6 45 af          	movzbl -0x51(%ebp),%eax
    1a9c:	0f be c0             	movsbl %al,%eax
    1a9f:	83 e8 30             	sub    $0x30,%eax
    1aa2:	89 45 f4             	mov    %eax,-0xc(%ebp)
      if(i < 0 || i >= sizeof(fa)){
    1aa5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1aa9:	78 08                	js     1ab3 <concreate+0x19f>
    1aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1aae:	83 f8 27             	cmp    $0x27,%eax
    1ab1:	76 1e                	jbe    1ad1 <concreate+0x1bd>
        printf(1, "concreate weird file %s\n", de.name);
    1ab3:	83 ec 04             	sub    $0x4,%esp
    1ab6:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1ab9:	83 c0 02             	add    $0x2,%eax
    1abc:	50                   	push   %eax
    1abd:	68 d1 4c 00 00       	push   $0x4cd1
    1ac2:	6a 01                	push   $0x1
    1ac4:	e8 6d 25 00 00       	call   4036 <printf>
    1ac9:	83 c4 10             	add    $0x10,%esp
        exit();
    1acc:	e8 e8 23 00 00       	call   3eb9 <exit>
      }
      if(fa[i]){
    1ad1:	8d 55 bd             	lea    -0x43(%ebp),%edx
    1ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ad7:	01 d0                	add    %edx,%eax
    1ad9:	0f b6 00             	movzbl (%eax),%eax
    1adc:	84 c0                	test   %al,%al
    1ade:	74 1e                	je     1afe <concreate+0x1ea>
        printf(1, "concreate duplicate file %s\n", de.name);
    1ae0:	83 ec 04             	sub    $0x4,%esp
    1ae3:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1ae6:	83 c0 02             	add    $0x2,%eax
    1ae9:	50                   	push   %eax
    1aea:	68 ea 4c 00 00       	push   $0x4cea
    1aef:	6a 01                	push   $0x1
    1af1:	e8 40 25 00 00       	call   4036 <printf>
    1af6:	83 c4 10             	add    $0x10,%esp
        exit();
    1af9:	e8 bb 23 00 00       	call   3eb9 <exit>
      }
      fa[i] = 1;
    1afe:	8d 55 bd             	lea    -0x43(%ebp),%edx
    1b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b04:	01 d0                	add    %edx,%eax
    1b06:	c6 00 01             	movb   $0x1,(%eax)
      n++;
    1b09:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  }

  memset(fa, 0, sizeof(fa));
  fd = open(".", 0);
  n = 0;
  while(read(fd, &de, sizeof(de)) > 0){
    1b0d:	83 ec 04             	sub    $0x4,%esp
    1b10:	6a 10                	push   $0x10
    1b12:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1b15:	50                   	push   %eax
    1b16:	ff 75 e8             	pushl  -0x18(%ebp)
    1b19:	e8 b3 23 00 00       	call   3ed1 <read>
    1b1e:	83 c4 10             	add    $0x10,%esp
    1b21:	85 c0                	test   %eax,%eax
    1b23:	0f 8f 51 ff ff ff    	jg     1a7a <concreate+0x166>
      }
      fa[i] = 1;
      n++;
    }
  }
  close(fd);
    1b29:	83 ec 0c             	sub    $0xc,%esp
    1b2c:	ff 75 e8             	pushl  -0x18(%ebp)
    1b2f:	e8 ad 23 00 00       	call   3ee1 <close>
    1b34:	83 c4 10             	add    $0x10,%esp

  if(n != 40){
    1b37:	83 7d f0 28          	cmpl   $0x28,-0x10(%ebp)
    1b3b:	74 17                	je     1b54 <concreate+0x240>
    printf(1, "concreate not enough files in directory listing\n");
    1b3d:	83 ec 08             	sub    $0x8,%esp
    1b40:	68 08 4d 00 00       	push   $0x4d08
    1b45:	6a 01                	push   $0x1
    1b47:	e8 ea 24 00 00       	call   4036 <printf>
    1b4c:	83 c4 10             	add    $0x10,%esp
    exit();
    1b4f:	e8 65 23 00 00       	call   3eb9 <exit>
  }

  for(i = 0; i < 40; i++){
    1b54:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1b5b:	e9 45 01 00 00       	jmp    1ca5 <concreate+0x391>
    file[1] = '0' + i;
    1b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b63:	83 c0 30             	add    $0x30,%eax
    1b66:	88 45 e6             	mov    %al,-0x1a(%ebp)
    pid = fork();
    1b69:	e8 43 23 00 00       	call   3eb1 <fork>
    1b6e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pid < 0){
    1b71:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1b75:	79 17                	jns    1b8e <concreate+0x27a>
      printf(1, "fork failed\n");
    1b77:	83 ec 08             	sub    $0x8,%esp
    1b7a:	68 8d 44 00 00       	push   $0x448d
    1b7f:	6a 01                	push   $0x1
    1b81:	e8 b0 24 00 00       	call   4036 <printf>
    1b86:	83 c4 10             	add    $0x10,%esp
      exit();
    1b89:	e8 2b 23 00 00       	call   3eb9 <exit>
    }
    if(((i % 3) == 0 && pid == 0) ||
    1b8e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1b91:	ba 56 55 55 55       	mov    $0x55555556,%edx
    1b96:	89 c8                	mov    %ecx,%eax
    1b98:	f7 ea                	imul   %edx
    1b9a:	89 c8                	mov    %ecx,%eax
    1b9c:	c1 f8 1f             	sar    $0x1f,%eax
    1b9f:	29 c2                	sub    %eax,%edx
    1ba1:	89 d0                	mov    %edx,%eax
    1ba3:	89 c2                	mov    %eax,%edx
    1ba5:	01 d2                	add    %edx,%edx
    1ba7:	01 c2                	add    %eax,%edx
    1ba9:	89 c8                	mov    %ecx,%eax
    1bab:	29 d0                	sub    %edx,%eax
    1bad:	85 c0                	test   %eax,%eax
    1baf:	75 06                	jne    1bb7 <concreate+0x2a3>
    1bb1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1bb5:	74 28                	je     1bdf <concreate+0x2cb>
       ((i % 3) == 1 && pid != 0)){
    1bb7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1bba:	ba 56 55 55 55       	mov    $0x55555556,%edx
    1bbf:	89 c8                	mov    %ecx,%eax
    1bc1:	f7 ea                	imul   %edx
    1bc3:	89 c8                	mov    %ecx,%eax
    1bc5:	c1 f8 1f             	sar    $0x1f,%eax
    1bc8:	29 c2                	sub    %eax,%edx
    1bca:	89 d0                	mov    %edx,%eax
    1bcc:	01 c0                	add    %eax,%eax
    1bce:	01 d0                	add    %edx,%eax
    1bd0:	29 c1                	sub    %eax,%ecx
    1bd2:	89 ca                	mov    %ecx,%edx
    pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
      exit();
    }
    if(((i % 3) == 0 && pid == 0) ||
    1bd4:	83 fa 01             	cmp    $0x1,%edx
    1bd7:	75 7c                	jne    1c55 <concreate+0x341>
       ((i % 3) == 1 && pid != 0)){
    1bd9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1bdd:	74 76                	je     1c55 <concreate+0x341>
      close(open(file, 0));
    1bdf:	83 ec 08             	sub    $0x8,%esp
    1be2:	6a 00                	push   $0x0
    1be4:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1be7:	50                   	push   %eax
    1be8:	e8 0c 23 00 00       	call   3ef9 <open>
    1bed:	83 c4 10             	add    $0x10,%esp
    1bf0:	83 ec 0c             	sub    $0xc,%esp
    1bf3:	50                   	push   %eax
    1bf4:	e8 e8 22 00 00       	call   3ee1 <close>
    1bf9:	83 c4 10             	add    $0x10,%esp
      close(open(file, 0));
    1bfc:	83 ec 08             	sub    $0x8,%esp
    1bff:	6a 00                	push   $0x0
    1c01:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c04:	50                   	push   %eax
    1c05:	e8 ef 22 00 00       	call   3ef9 <open>
    1c0a:	83 c4 10             	add    $0x10,%esp
    1c0d:	83 ec 0c             	sub    $0xc,%esp
    1c10:	50                   	push   %eax
    1c11:	e8 cb 22 00 00       	call   3ee1 <close>
    1c16:	83 c4 10             	add    $0x10,%esp
      close(open(file, 0));
    1c19:	83 ec 08             	sub    $0x8,%esp
    1c1c:	6a 00                	push   $0x0
    1c1e:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c21:	50                   	push   %eax
    1c22:	e8 d2 22 00 00       	call   3ef9 <open>
    1c27:	83 c4 10             	add    $0x10,%esp
    1c2a:	83 ec 0c             	sub    $0xc,%esp
    1c2d:	50                   	push   %eax
    1c2e:	e8 ae 22 00 00       	call   3ee1 <close>
    1c33:	83 c4 10             	add    $0x10,%esp
      close(open(file, 0));
    1c36:	83 ec 08             	sub    $0x8,%esp
    1c39:	6a 00                	push   $0x0
    1c3b:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c3e:	50                   	push   %eax
    1c3f:	e8 b5 22 00 00       	call   3ef9 <open>
    1c44:	83 c4 10             	add    $0x10,%esp
    1c47:	83 ec 0c             	sub    $0xc,%esp
    1c4a:	50                   	push   %eax
    1c4b:	e8 91 22 00 00       	call   3ee1 <close>
    1c50:	83 c4 10             	add    $0x10,%esp
    1c53:	eb 3c                	jmp    1c91 <concreate+0x37d>
    } else {
      unlink(file);
    1c55:	83 ec 0c             	sub    $0xc,%esp
    1c58:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c5b:	50                   	push   %eax
    1c5c:	e8 a8 22 00 00       	call   3f09 <unlink>
    1c61:	83 c4 10             	add    $0x10,%esp
      unlink(file);
    1c64:	83 ec 0c             	sub    $0xc,%esp
    1c67:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c6a:	50                   	push   %eax
    1c6b:	e8 99 22 00 00       	call   3f09 <unlink>
    1c70:	83 c4 10             	add    $0x10,%esp
      unlink(file);
    1c73:	83 ec 0c             	sub    $0xc,%esp
    1c76:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c79:	50                   	push   %eax
    1c7a:	e8 8a 22 00 00       	call   3f09 <unlink>
    1c7f:	83 c4 10             	add    $0x10,%esp
      unlink(file);
    1c82:	83 ec 0c             	sub    $0xc,%esp
    1c85:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c88:	50                   	push   %eax
    1c89:	e8 7b 22 00 00       	call   3f09 <unlink>
    1c8e:	83 c4 10             	add    $0x10,%esp
    }
    if(pid == 0)
    1c91:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1c95:	75 05                	jne    1c9c <concreate+0x388>
      exit();
    1c97:	e8 1d 22 00 00       	call   3eb9 <exit>
    else
      wait();
    1c9c:	e8 20 22 00 00       	call   3ec1 <wait>
  if(n != 40){
    printf(1, "concreate not enough files in directory listing\n");
    exit();
  }

  for(i = 0; i < 40; i++){
    1ca1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1ca5:	83 7d f4 27          	cmpl   $0x27,-0xc(%ebp)
    1ca9:	0f 8e b1 fe ff ff    	jle    1b60 <concreate+0x24c>
      exit();
    else
      wait();
  }

  printf(1, "concreate ok\n");
    1caf:	83 ec 08             	sub    $0x8,%esp
    1cb2:	68 39 4d 00 00       	push   $0x4d39
    1cb7:	6a 01                	push   $0x1
    1cb9:	e8 78 23 00 00       	call   4036 <printf>
    1cbe:	83 c4 10             	add    $0x10,%esp
}
    1cc1:	c9                   	leave  
    1cc2:	c3                   	ret    

00001cc3 <linkunlink>:

// another concurrent link/unlink/create test,
// to look for deadlocks.
void
linkunlink()
{
    1cc3:	55                   	push   %ebp
    1cc4:	89 e5                	mov    %esp,%ebp
    1cc6:	83 ec 18             	sub    $0x18,%esp
  int pid, i;

  printf(1, "linkunlink test\n");
    1cc9:	83 ec 08             	sub    $0x8,%esp
    1ccc:	68 47 4d 00 00       	push   $0x4d47
    1cd1:	6a 01                	push   $0x1
    1cd3:	e8 5e 23 00 00       	call   4036 <printf>
    1cd8:	83 c4 10             	add    $0x10,%esp

  unlink("x");
    1cdb:	83 ec 0c             	sub    $0xc,%esp
    1cde:	68 c3 48 00 00       	push   $0x48c3
    1ce3:	e8 21 22 00 00       	call   3f09 <unlink>
    1ce8:	83 c4 10             	add    $0x10,%esp
  pid = fork();
    1ceb:	e8 c1 21 00 00       	call   3eb1 <fork>
    1cf0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(pid < 0){
    1cf3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1cf7:	79 17                	jns    1d10 <linkunlink+0x4d>
    printf(1, "fork failed\n");
    1cf9:	83 ec 08             	sub    $0x8,%esp
    1cfc:	68 8d 44 00 00       	push   $0x448d
    1d01:	6a 01                	push   $0x1
    1d03:	e8 2e 23 00 00       	call   4036 <printf>
    1d08:	83 c4 10             	add    $0x10,%esp
    exit();
    1d0b:	e8 a9 21 00 00       	call   3eb9 <exit>
  }

  unsigned int x = (pid ? 1 : 97);
    1d10:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1d14:	74 07                	je     1d1d <linkunlink+0x5a>
    1d16:	b8 01 00 00 00       	mov    $0x1,%eax
    1d1b:	eb 05                	jmp    1d22 <linkunlink+0x5f>
    1d1d:	b8 61 00 00 00       	mov    $0x61,%eax
    1d22:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; i < 100; i++){
    1d25:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1d2c:	e9 9a 00 00 00       	jmp    1dcb <linkunlink+0x108>
    x = x * 1103515245 + 12345;
    1d31:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1d34:	69 c0 6d 4e c6 41    	imul   $0x41c64e6d,%eax,%eax
    1d3a:	05 39 30 00 00       	add    $0x3039,%eax
    1d3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((x % 3) == 0){
    1d42:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    1d45:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
    1d4a:	89 c8                	mov    %ecx,%eax
    1d4c:	f7 e2                	mul    %edx
    1d4e:	89 d0                	mov    %edx,%eax
    1d50:	d1 e8                	shr    %eax
    1d52:	89 c2                	mov    %eax,%edx
    1d54:	01 d2                	add    %edx,%edx
    1d56:	01 c2                	add    %eax,%edx
    1d58:	89 c8                	mov    %ecx,%eax
    1d5a:	29 d0                	sub    %edx,%eax
    1d5c:	85 c0                	test   %eax,%eax
    1d5e:	75 23                	jne    1d83 <linkunlink+0xc0>
      close(open("x", O_RDWR | O_CREATE));
    1d60:	83 ec 08             	sub    $0x8,%esp
    1d63:	68 02 02 00 00       	push   $0x202
    1d68:	68 c3 48 00 00       	push   $0x48c3
    1d6d:	e8 87 21 00 00       	call   3ef9 <open>
    1d72:	83 c4 10             	add    $0x10,%esp
    1d75:	83 ec 0c             	sub    $0xc,%esp
    1d78:	50                   	push   %eax
    1d79:	e8 63 21 00 00       	call   3ee1 <close>
    1d7e:	83 c4 10             	add    $0x10,%esp
    1d81:	eb 44                	jmp    1dc7 <linkunlink+0x104>
    } else if((x % 3) == 1){
    1d83:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    1d86:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
    1d8b:	89 c8                	mov    %ecx,%eax
    1d8d:	f7 e2                	mul    %edx
    1d8f:	d1 ea                	shr    %edx
    1d91:	89 d0                	mov    %edx,%eax
    1d93:	01 c0                	add    %eax,%eax
    1d95:	01 d0                	add    %edx,%eax
    1d97:	29 c1                	sub    %eax,%ecx
    1d99:	89 ca                	mov    %ecx,%edx
    1d9b:	83 fa 01             	cmp    $0x1,%edx
    1d9e:	75 17                	jne    1db7 <linkunlink+0xf4>
      link("cat", "x");
    1da0:	83 ec 08             	sub    $0x8,%esp
    1da3:	68 c3 48 00 00       	push   $0x48c3
    1da8:	68 58 4d 00 00       	push   $0x4d58
    1dad:	e8 67 21 00 00       	call   3f19 <link>
    1db2:	83 c4 10             	add    $0x10,%esp
    1db5:	eb 10                	jmp    1dc7 <linkunlink+0x104>
    } else {
      unlink("x");
    1db7:	83 ec 0c             	sub    $0xc,%esp
    1dba:	68 c3 48 00 00       	push   $0x48c3
    1dbf:	e8 45 21 00 00       	call   3f09 <unlink>
    1dc4:	83 c4 10             	add    $0x10,%esp
    printf(1, "fork failed\n");
    exit();
  }

  unsigned int x = (pid ? 1 : 97);
  for(i = 0; i < 100; i++){
    1dc7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1dcb:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
    1dcf:	0f 8e 5c ff ff ff    	jle    1d31 <linkunlink+0x6e>
    } else {
      unlink("x");
    }
  }

  if(pid)
    1dd5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1dd9:	74 07                	je     1de2 <linkunlink+0x11f>
    wait();
    1ddb:	e8 e1 20 00 00       	call   3ec1 <wait>
    1de0:	eb 05                	jmp    1de7 <linkunlink+0x124>
  else 
    exit();
    1de2:	e8 d2 20 00 00       	call   3eb9 <exit>

  printf(1, "linkunlink ok\n");
    1de7:	83 ec 08             	sub    $0x8,%esp
    1dea:	68 5c 4d 00 00       	push   $0x4d5c
    1def:	6a 01                	push   $0x1
    1df1:	e8 40 22 00 00       	call   4036 <printf>
    1df6:	83 c4 10             	add    $0x10,%esp
}
    1df9:	c9                   	leave  
    1dfa:	c3                   	ret    

00001dfb <bigdir>:

// directory that uses indirect blocks
void
bigdir(void)
{
    1dfb:	55                   	push   %ebp
    1dfc:	89 e5                	mov    %esp,%ebp
    1dfe:	83 ec 28             	sub    $0x28,%esp
  int i, fd;
  char name[10];

  printf(1, "bigdir test\n");
    1e01:	83 ec 08             	sub    $0x8,%esp
    1e04:	68 6b 4d 00 00       	push   $0x4d6b
    1e09:	6a 01                	push   $0x1
    1e0b:	e8 26 22 00 00       	call   4036 <printf>
    1e10:	83 c4 10             	add    $0x10,%esp
  unlink("bd");
    1e13:	83 ec 0c             	sub    $0xc,%esp
    1e16:	68 78 4d 00 00       	push   $0x4d78
    1e1b:	e8 e9 20 00 00       	call   3f09 <unlink>
    1e20:	83 c4 10             	add    $0x10,%esp

  fd = open("bd", O_CREATE);
    1e23:	83 ec 08             	sub    $0x8,%esp
    1e26:	68 00 02 00 00       	push   $0x200
    1e2b:	68 78 4d 00 00       	push   $0x4d78
    1e30:	e8 c4 20 00 00       	call   3ef9 <open>
    1e35:	83 c4 10             	add    $0x10,%esp
    1e38:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0){
    1e3b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1e3f:	79 17                	jns    1e58 <bigdir+0x5d>
    printf(1, "bigdir create failed\n");
    1e41:	83 ec 08             	sub    $0x8,%esp
    1e44:	68 7b 4d 00 00       	push   $0x4d7b
    1e49:	6a 01                	push   $0x1
    1e4b:	e8 e6 21 00 00       	call   4036 <printf>
    1e50:	83 c4 10             	add    $0x10,%esp
    exit();
    1e53:	e8 61 20 00 00       	call   3eb9 <exit>
  }
  close(fd);
    1e58:	83 ec 0c             	sub    $0xc,%esp
    1e5b:	ff 75 f0             	pushl  -0x10(%ebp)
    1e5e:	e8 7e 20 00 00       	call   3ee1 <close>
    1e63:	83 c4 10             	add    $0x10,%esp

  for(i = 0; i < 500; i++){
    1e66:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1e6d:	eb 63                	jmp    1ed2 <bigdir+0xd7>
    name[0] = 'x';
    1e6f:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
    name[1] = '0' + (i / 64);
    1e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1e76:	8d 50 3f             	lea    0x3f(%eax),%edx
    1e79:	85 c0                	test   %eax,%eax
    1e7b:	0f 48 c2             	cmovs  %edx,%eax
    1e7e:	c1 f8 06             	sar    $0x6,%eax
    1e81:	83 c0 30             	add    $0x30,%eax
    1e84:	88 45 e7             	mov    %al,-0x19(%ebp)
    name[2] = '0' + (i % 64);
    1e87:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1e8a:	99                   	cltd   
    1e8b:	c1 ea 1a             	shr    $0x1a,%edx
    1e8e:	01 d0                	add    %edx,%eax
    1e90:	83 e0 3f             	and    $0x3f,%eax
    1e93:	29 d0                	sub    %edx,%eax
    1e95:	83 c0 30             	add    $0x30,%eax
    1e98:	88 45 e8             	mov    %al,-0x18(%ebp)
    name[3] = '\0';
    1e9b:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
    if(link("bd", name) != 0){
    1e9f:	83 ec 08             	sub    $0x8,%esp
    1ea2:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1ea5:	50                   	push   %eax
    1ea6:	68 78 4d 00 00       	push   $0x4d78
    1eab:	e8 69 20 00 00       	call   3f19 <link>
    1eb0:	83 c4 10             	add    $0x10,%esp
    1eb3:	85 c0                	test   %eax,%eax
    1eb5:	74 17                	je     1ece <bigdir+0xd3>
      printf(1, "bigdir link failed\n");
    1eb7:	83 ec 08             	sub    $0x8,%esp
    1eba:	68 91 4d 00 00       	push   $0x4d91
    1ebf:	6a 01                	push   $0x1
    1ec1:	e8 70 21 00 00       	call   4036 <printf>
    1ec6:	83 c4 10             	add    $0x10,%esp
      exit();
    1ec9:	e8 eb 1f 00 00       	call   3eb9 <exit>
    printf(1, "bigdir create failed\n");
    exit();
  }
  close(fd);

  for(i = 0; i < 500; i++){
    1ece:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1ed2:	81 7d f4 f3 01 00 00 	cmpl   $0x1f3,-0xc(%ebp)
    1ed9:	7e 94                	jle    1e6f <bigdir+0x74>
      printf(1, "bigdir link failed\n");
      exit();
    }
  }

  unlink("bd");
    1edb:	83 ec 0c             	sub    $0xc,%esp
    1ede:	68 78 4d 00 00       	push   $0x4d78
    1ee3:	e8 21 20 00 00       	call   3f09 <unlink>
    1ee8:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 500; i++){
    1eeb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1ef2:	eb 5e                	jmp    1f52 <bigdir+0x157>
    name[0] = 'x';
    1ef4:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
    name[1] = '0' + (i / 64);
    1ef8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1efb:	8d 50 3f             	lea    0x3f(%eax),%edx
    1efe:	85 c0                	test   %eax,%eax
    1f00:	0f 48 c2             	cmovs  %edx,%eax
    1f03:	c1 f8 06             	sar    $0x6,%eax
    1f06:	83 c0 30             	add    $0x30,%eax
    1f09:	88 45 e7             	mov    %al,-0x19(%ebp)
    name[2] = '0' + (i % 64);
    1f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1f0f:	99                   	cltd   
    1f10:	c1 ea 1a             	shr    $0x1a,%edx
    1f13:	01 d0                	add    %edx,%eax
    1f15:	83 e0 3f             	and    $0x3f,%eax
    1f18:	29 d0                	sub    %edx,%eax
    1f1a:	83 c0 30             	add    $0x30,%eax
    1f1d:	88 45 e8             	mov    %al,-0x18(%ebp)
    name[3] = '\0';
    1f20:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
    if(unlink(name) != 0){
    1f24:	83 ec 0c             	sub    $0xc,%esp
    1f27:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1f2a:	50                   	push   %eax
    1f2b:	e8 d9 1f 00 00       	call   3f09 <unlink>
    1f30:	83 c4 10             	add    $0x10,%esp
    1f33:	85 c0                	test   %eax,%eax
    1f35:	74 17                	je     1f4e <bigdir+0x153>
      printf(1, "bigdir unlink failed");
    1f37:	83 ec 08             	sub    $0x8,%esp
    1f3a:	68 a5 4d 00 00       	push   $0x4da5
    1f3f:	6a 01                	push   $0x1
    1f41:	e8 f0 20 00 00       	call   4036 <printf>
    1f46:	83 c4 10             	add    $0x10,%esp
      exit();
    1f49:	e8 6b 1f 00 00       	call   3eb9 <exit>
      exit();
    }
  }

  unlink("bd");
  for(i = 0; i < 500; i++){
    1f4e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1f52:	81 7d f4 f3 01 00 00 	cmpl   $0x1f3,-0xc(%ebp)
    1f59:	7e 99                	jle    1ef4 <bigdir+0xf9>
      printf(1, "bigdir unlink failed");
      exit();
    }
  }

  printf(1, "bigdir ok\n");
    1f5b:	83 ec 08             	sub    $0x8,%esp
    1f5e:	68 ba 4d 00 00       	push   $0x4dba
    1f63:	6a 01                	push   $0x1
    1f65:	e8 cc 20 00 00       	call   4036 <printf>
    1f6a:	83 c4 10             	add    $0x10,%esp
}
    1f6d:	c9                   	leave  
    1f6e:	c3                   	ret    

00001f6f <subdir>:

void
subdir(void)
{
    1f6f:	55                   	push   %ebp
    1f70:	89 e5                	mov    %esp,%ebp
    1f72:	83 ec 18             	sub    $0x18,%esp
  int fd, cc;

  printf(1, "subdir test\n");
    1f75:	83 ec 08             	sub    $0x8,%esp
    1f78:	68 c5 4d 00 00       	push   $0x4dc5
    1f7d:	6a 01                	push   $0x1
    1f7f:	e8 b2 20 00 00       	call   4036 <printf>
    1f84:	83 c4 10             	add    $0x10,%esp

  unlink("ff");
    1f87:	83 ec 0c             	sub    $0xc,%esp
    1f8a:	68 d2 4d 00 00       	push   $0x4dd2
    1f8f:	e8 75 1f 00 00       	call   3f09 <unlink>
    1f94:	83 c4 10             	add    $0x10,%esp
  if(mkdir("dd") != 0){
    1f97:	83 ec 0c             	sub    $0xc,%esp
    1f9a:	68 d5 4d 00 00       	push   $0x4dd5
    1f9f:	e8 7d 1f 00 00       	call   3f21 <mkdir>
    1fa4:	83 c4 10             	add    $0x10,%esp
    1fa7:	85 c0                	test   %eax,%eax
    1fa9:	74 17                	je     1fc2 <subdir+0x53>
    printf(1, "subdir mkdir dd failed\n");
    1fab:	83 ec 08             	sub    $0x8,%esp
    1fae:	68 d8 4d 00 00       	push   $0x4dd8
    1fb3:	6a 01                	push   $0x1
    1fb5:	e8 7c 20 00 00       	call   4036 <printf>
    1fba:	83 c4 10             	add    $0x10,%esp
    exit();
    1fbd:	e8 f7 1e 00 00       	call   3eb9 <exit>
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    1fc2:	83 ec 08             	sub    $0x8,%esp
    1fc5:	68 02 02 00 00       	push   $0x202
    1fca:	68 f0 4d 00 00       	push   $0x4df0
    1fcf:	e8 25 1f 00 00       	call   3ef9 <open>
    1fd4:	83 c4 10             	add    $0x10,%esp
    1fd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1fda:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1fde:	79 17                	jns    1ff7 <subdir+0x88>
    printf(1, "create dd/ff failed\n");
    1fe0:	83 ec 08             	sub    $0x8,%esp
    1fe3:	68 f6 4d 00 00       	push   $0x4df6
    1fe8:	6a 01                	push   $0x1
    1fea:	e8 47 20 00 00       	call   4036 <printf>
    1fef:	83 c4 10             	add    $0x10,%esp
    exit();
    1ff2:	e8 c2 1e 00 00       	call   3eb9 <exit>
  }
  write(fd, "ff", 2);
    1ff7:	83 ec 04             	sub    $0x4,%esp
    1ffa:	6a 02                	push   $0x2
    1ffc:	68 d2 4d 00 00       	push   $0x4dd2
    2001:	ff 75 f4             	pushl  -0xc(%ebp)
    2004:	e8 d0 1e 00 00       	call   3ed9 <write>
    2009:	83 c4 10             	add    $0x10,%esp
  close(fd);
    200c:	83 ec 0c             	sub    $0xc,%esp
    200f:	ff 75 f4             	pushl  -0xc(%ebp)
    2012:	e8 ca 1e 00 00       	call   3ee1 <close>
    2017:	83 c4 10             	add    $0x10,%esp
  
  if(unlink("dd") >= 0){
    201a:	83 ec 0c             	sub    $0xc,%esp
    201d:	68 d5 4d 00 00       	push   $0x4dd5
    2022:	e8 e2 1e 00 00       	call   3f09 <unlink>
    2027:	83 c4 10             	add    $0x10,%esp
    202a:	85 c0                	test   %eax,%eax
    202c:	78 17                	js     2045 <subdir+0xd6>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    202e:	83 ec 08             	sub    $0x8,%esp
    2031:	68 0c 4e 00 00       	push   $0x4e0c
    2036:	6a 01                	push   $0x1
    2038:	e8 f9 1f 00 00       	call   4036 <printf>
    203d:	83 c4 10             	add    $0x10,%esp
    exit();
    2040:	e8 74 1e 00 00       	call   3eb9 <exit>
  }

  if(mkdir("/dd/dd") != 0){
    2045:	83 ec 0c             	sub    $0xc,%esp
    2048:	68 32 4e 00 00       	push   $0x4e32
    204d:	e8 cf 1e 00 00       	call   3f21 <mkdir>
    2052:	83 c4 10             	add    $0x10,%esp
    2055:	85 c0                	test   %eax,%eax
    2057:	74 17                	je     2070 <subdir+0x101>
    printf(1, "subdir mkdir dd/dd failed\n");
    2059:	83 ec 08             	sub    $0x8,%esp
    205c:	68 39 4e 00 00       	push   $0x4e39
    2061:	6a 01                	push   $0x1
    2063:	e8 ce 1f 00 00       	call   4036 <printf>
    2068:	83 c4 10             	add    $0x10,%esp
    exit();
    206b:	e8 49 1e 00 00       	call   3eb9 <exit>
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2070:	83 ec 08             	sub    $0x8,%esp
    2073:	68 02 02 00 00       	push   $0x202
    2078:	68 54 4e 00 00       	push   $0x4e54
    207d:	e8 77 1e 00 00       	call   3ef9 <open>
    2082:	83 c4 10             	add    $0x10,%esp
    2085:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2088:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    208c:	79 17                	jns    20a5 <subdir+0x136>
    printf(1, "create dd/dd/ff failed\n");
    208e:	83 ec 08             	sub    $0x8,%esp
    2091:	68 5d 4e 00 00       	push   $0x4e5d
    2096:	6a 01                	push   $0x1
    2098:	e8 99 1f 00 00       	call   4036 <printf>
    209d:	83 c4 10             	add    $0x10,%esp
    exit();
    20a0:	e8 14 1e 00 00       	call   3eb9 <exit>
  }
  write(fd, "FF", 2);
    20a5:	83 ec 04             	sub    $0x4,%esp
    20a8:	6a 02                	push   $0x2
    20aa:	68 75 4e 00 00       	push   $0x4e75
    20af:	ff 75 f4             	pushl  -0xc(%ebp)
    20b2:	e8 22 1e 00 00       	call   3ed9 <write>
    20b7:	83 c4 10             	add    $0x10,%esp
  close(fd);
    20ba:	83 ec 0c             	sub    $0xc,%esp
    20bd:	ff 75 f4             	pushl  -0xc(%ebp)
    20c0:	e8 1c 1e 00 00       	call   3ee1 <close>
    20c5:	83 c4 10             	add    $0x10,%esp

  fd = open("dd/dd/../ff", 0);
    20c8:	83 ec 08             	sub    $0x8,%esp
    20cb:	6a 00                	push   $0x0
    20cd:	68 78 4e 00 00       	push   $0x4e78
    20d2:	e8 22 1e 00 00       	call   3ef9 <open>
    20d7:	83 c4 10             	add    $0x10,%esp
    20da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    20dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    20e1:	79 17                	jns    20fa <subdir+0x18b>
    printf(1, "open dd/dd/../ff failed\n");
    20e3:	83 ec 08             	sub    $0x8,%esp
    20e6:	68 84 4e 00 00       	push   $0x4e84
    20eb:	6a 01                	push   $0x1
    20ed:	e8 44 1f 00 00       	call   4036 <printf>
    20f2:	83 c4 10             	add    $0x10,%esp
    exit();
    20f5:	e8 bf 1d 00 00       	call   3eb9 <exit>
  }
  cc = read(fd, buf, sizeof(buf));
    20fa:	83 ec 04             	sub    $0x4,%esp
    20fd:	68 00 20 00 00       	push   $0x2000
    2102:	68 00 8b 00 00       	push   $0x8b00
    2107:	ff 75 f4             	pushl  -0xc(%ebp)
    210a:	e8 c2 1d 00 00       	call   3ed1 <read>
    210f:	83 c4 10             	add    $0x10,%esp
    2112:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(cc != 2 || buf[0] != 'f'){
    2115:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
    2119:	75 0b                	jne    2126 <subdir+0x1b7>
    211b:	0f b6 05 00 8b 00 00 	movzbl 0x8b00,%eax
    2122:	3c 66                	cmp    $0x66,%al
    2124:	74 17                	je     213d <subdir+0x1ce>
    printf(1, "dd/dd/../ff wrong content\n");
    2126:	83 ec 08             	sub    $0x8,%esp
    2129:	68 9d 4e 00 00       	push   $0x4e9d
    212e:	6a 01                	push   $0x1
    2130:	e8 01 1f 00 00       	call   4036 <printf>
    2135:	83 c4 10             	add    $0x10,%esp
    exit();
    2138:	e8 7c 1d 00 00       	call   3eb9 <exit>
  }
  close(fd);
    213d:	83 ec 0c             	sub    $0xc,%esp
    2140:	ff 75 f4             	pushl  -0xc(%ebp)
    2143:	e8 99 1d 00 00       	call   3ee1 <close>
    2148:	83 c4 10             	add    $0x10,%esp

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    214b:	83 ec 08             	sub    $0x8,%esp
    214e:	68 b8 4e 00 00       	push   $0x4eb8
    2153:	68 54 4e 00 00       	push   $0x4e54
    2158:	e8 bc 1d 00 00       	call   3f19 <link>
    215d:	83 c4 10             	add    $0x10,%esp
    2160:	85 c0                	test   %eax,%eax
    2162:	74 17                	je     217b <subdir+0x20c>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    2164:	83 ec 08             	sub    $0x8,%esp
    2167:	68 c4 4e 00 00       	push   $0x4ec4
    216c:	6a 01                	push   $0x1
    216e:	e8 c3 1e 00 00       	call   4036 <printf>
    2173:	83 c4 10             	add    $0x10,%esp
    exit();
    2176:	e8 3e 1d 00 00       	call   3eb9 <exit>
  }

  if(unlink("dd/dd/ff") != 0){
    217b:	83 ec 0c             	sub    $0xc,%esp
    217e:	68 54 4e 00 00       	push   $0x4e54
    2183:	e8 81 1d 00 00       	call   3f09 <unlink>
    2188:	83 c4 10             	add    $0x10,%esp
    218b:	85 c0                	test   %eax,%eax
    218d:	74 17                	je     21a6 <subdir+0x237>
    printf(1, "unlink dd/dd/ff failed\n");
    218f:	83 ec 08             	sub    $0x8,%esp
    2192:	68 e5 4e 00 00       	push   $0x4ee5
    2197:	6a 01                	push   $0x1
    2199:	e8 98 1e 00 00       	call   4036 <printf>
    219e:	83 c4 10             	add    $0x10,%esp
    exit();
    21a1:	e8 13 1d 00 00       	call   3eb9 <exit>
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    21a6:	83 ec 08             	sub    $0x8,%esp
    21a9:	6a 00                	push   $0x0
    21ab:	68 54 4e 00 00       	push   $0x4e54
    21b0:	e8 44 1d 00 00       	call   3ef9 <open>
    21b5:	83 c4 10             	add    $0x10,%esp
    21b8:	85 c0                	test   %eax,%eax
    21ba:	78 17                	js     21d3 <subdir+0x264>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    21bc:	83 ec 08             	sub    $0x8,%esp
    21bf:	68 00 4f 00 00       	push   $0x4f00
    21c4:	6a 01                	push   $0x1
    21c6:	e8 6b 1e 00 00       	call   4036 <printf>
    21cb:	83 c4 10             	add    $0x10,%esp
    exit();
    21ce:	e8 e6 1c 00 00       	call   3eb9 <exit>
  }

  if(chdir("dd") != 0){
    21d3:	83 ec 0c             	sub    $0xc,%esp
    21d6:	68 d5 4d 00 00       	push   $0x4dd5
    21db:	e8 49 1d 00 00       	call   3f29 <chdir>
    21e0:	83 c4 10             	add    $0x10,%esp
    21e3:	85 c0                	test   %eax,%eax
    21e5:	74 17                	je     21fe <subdir+0x28f>
    printf(1, "chdir dd failed\n");
    21e7:	83 ec 08             	sub    $0x8,%esp
    21ea:	68 24 4f 00 00       	push   $0x4f24
    21ef:	6a 01                	push   $0x1
    21f1:	e8 40 1e 00 00       	call   4036 <printf>
    21f6:	83 c4 10             	add    $0x10,%esp
    exit();
    21f9:	e8 bb 1c 00 00       	call   3eb9 <exit>
  }
  if(chdir("dd/../../dd") != 0){
    21fe:	83 ec 0c             	sub    $0xc,%esp
    2201:	68 35 4f 00 00       	push   $0x4f35
    2206:	e8 1e 1d 00 00       	call   3f29 <chdir>
    220b:	83 c4 10             	add    $0x10,%esp
    220e:	85 c0                	test   %eax,%eax
    2210:	74 17                	je     2229 <subdir+0x2ba>
    printf(1, "chdir dd/../../dd failed\n");
    2212:	83 ec 08             	sub    $0x8,%esp
    2215:	68 41 4f 00 00       	push   $0x4f41
    221a:	6a 01                	push   $0x1
    221c:	e8 15 1e 00 00       	call   4036 <printf>
    2221:	83 c4 10             	add    $0x10,%esp
    exit();
    2224:	e8 90 1c 00 00       	call   3eb9 <exit>
  }
  if(chdir("dd/../../../dd") != 0){
    2229:	83 ec 0c             	sub    $0xc,%esp
    222c:	68 5b 4f 00 00       	push   $0x4f5b
    2231:	e8 f3 1c 00 00       	call   3f29 <chdir>
    2236:	83 c4 10             	add    $0x10,%esp
    2239:	85 c0                	test   %eax,%eax
    223b:	74 17                	je     2254 <subdir+0x2e5>
    printf(1, "chdir dd/../../dd failed\n");
    223d:	83 ec 08             	sub    $0x8,%esp
    2240:	68 41 4f 00 00       	push   $0x4f41
    2245:	6a 01                	push   $0x1
    2247:	e8 ea 1d 00 00       	call   4036 <printf>
    224c:	83 c4 10             	add    $0x10,%esp
    exit();
    224f:	e8 65 1c 00 00       	call   3eb9 <exit>
  }
  if(chdir("./..") != 0){
    2254:	83 ec 0c             	sub    $0xc,%esp
    2257:	68 6a 4f 00 00       	push   $0x4f6a
    225c:	e8 c8 1c 00 00       	call   3f29 <chdir>
    2261:	83 c4 10             	add    $0x10,%esp
    2264:	85 c0                	test   %eax,%eax
    2266:	74 17                	je     227f <subdir+0x310>
    printf(1, "chdir ./.. failed\n");
    2268:	83 ec 08             	sub    $0x8,%esp
    226b:	68 6f 4f 00 00       	push   $0x4f6f
    2270:	6a 01                	push   $0x1
    2272:	e8 bf 1d 00 00       	call   4036 <printf>
    2277:	83 c4 10             	add    $0x10,%esp
    exit();
    227a:	e8 3a 1c 00 00       	call   3eb9 <exit>
  }

  fd = open("dd/dd/ffff", 0);
    227f:	83 ec 08             	sub    $0x8,%esp
    2282:	6a 00                	push   $0x0
    2284:	68 b8 4e 00 00       	push   $0x4eb8
    2289:	e8 6b 1c 00 00       	call   3ef9 <open>
    228e:	83 c4 10             	add    $0x10,%esp
    2291:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2294:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2298:	79 17                	jns    22b1 <subdir+0x342>
    printf(1, "open dd/dd/ffff failed\n");
    229a:	83 ec 08             	sub    $0x8,%esp
    229d:	68 82 4f 00 00       	push   $0x4f82
    22a2:	6a 01                	push   $0x1
    22a4:	e8 8d 1d 00 00       	call   4036 <printf>
    22a9:	83 c4 10             	add    $0x10,%esp
    exit();
    22ac:	e8 08 1c 00 00       	call   3eb9 <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    22b1:	83 ec 04             	sub    $0x4,%esp
    22b4:	68 00 20 00 00       	push   $0x2000
    22b9:	68 00 8b 00 00       	push   $0x8b00
    22be:	ff 75 f4             	pushl  -0xc(%ebp)
    22c1:	e8 0b 1c 00 00       	call   3ed1 <read>
    22c6:	83 c4 10             	add    $0x10,%esp
    22c9:	83 f8 02             	cmp    $0x2,%eax
    22cc:	74 17                	je     22e5 <subdir+0x376>
    printf(1, "read dd/dd/ffff wrong len\n");
    22ce:	83 ec 08             	sub    $0x8,%esp
    22d1:	68 9a 4f 00 00       	push   $0x4f9a
    22d6:	6a 01                	push   $0x1
    22d8:	e8 59 1d 00 00       	call   4036 <printf>
    22dd:	83 c4 10             	add    $0x10,%esp
    exit();
    22e0:	e8 d4 1b 00 00       	call   3eb9 <exit>
  }
  close(fd);
    22e5:	83 ec 0c             	sub    $0xc,%esp
    22e8:	ff 75 f4             	pushl  -0xc(%ebp)
    22eb:	e8 f1 1b 00 00       	call   3ee1 <close>
    22f0:	83 c4 10             	add    $0x10,%esp

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    22f3:	83 ec 08             	sub    $0x8,%esp
    22f6:	6a 00                	push   $0x0
    22f8:	68 54 4e 00 00       	push   $0x4e54
    22fd:	e8 f7 1b 00 00       	call   3ef9 <open>
    2302:	83 c4 10             	add    $0x10,%esp
    2305:	85 c0                	test   %eax,%eax
    2307:	78 17                	js     2320 <subdir+0x3b1>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    2309:	83 ec 08             	sub    $0x8,%esp
    230c:	68 b8 4f 00 00       	push   $0x4fb8
    2311:	6a 01                	push   $0x1
    2313:	e8 1e 1d 00 00       	call   4036 <printf>
    2318:	83 c4 10             	add    $0x10,%esp
    exit();
    231b:	e8 99 1b 00 00       	call   3eb9 <exit>
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    2320:	83 ec 08             	sub    $0x8,%esp
    2323:	68 02 02 00 00       	push   $0x202
    2328:	68 dd 4f 00 00       	push   $0x4fdd
    232d:	e8 c7 1b 00 00       	call   3ef9 <open>
    2332:	83 c4 10             	add    $0x10,%esp
    2335:	85 c0                	test   %eax,%eax
    2337:	78 17                	js     2350 <subdir+0x3e1>
    printf(1, "create dd/ff/ff succeeded!\n");
    2339:	83 ec 08             	sub    $0x8,%esp
    233c:	68 e6 4f 00 00       	push   $0x4fe6
    2341:	6a 01                	push   $0x1
    2343:	e8 ee 1c 00 00       	call   4036 <printf>
    2348:	83 c4 10             	add    $0x10,%esp
    exit();
    234b:	e8 69 1b 00 00       	call   3eb9 <exit>
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    2350:	83 ec 08             	sub    $0x8,%esp
    2353:	68 02 02 00 00       	push   $0x202
    2358:	68 02 50 00 00       	push   $0x5002
    235d:	e8 97 1b 00 00       	call   3ef9 <open>
    2362:	83 c4 10             	add    $0x10,%esp
    2365:	85 c0                	test   %eax,%eax
    2367:	78 17                	js     2380 <subdir+0x411>
    printf(1, "create dd/xx/ff succeeded!\n");
    2369:	83 ec 08             	sub    $0x8,%esp
    236c:	68 0b 50 00 00       	push   $0x500b
    2371:	6a 01                	push   $0x1
    2373:	e8 be 1c 00 00       	call   4036 <printf>
    2378:	83 c4 10             	add    $0x10,%esp
    exit();
    237b:	e8 39 1b 00 00       	call   3eb9 <exit>
  }
  if(open("dd", O_CREATE) >= 0){
    2380:	83 ec 08             	sub    $0x8,%esp
    2383:	68 00 02 00 00       	push   $0x200
    2388:	68 d5 4d 00 00       	push   $0x4dd5
    238d:	e8 67 1b 00 00       	call   3ef9 <open>
    2392:	83 c4 10             	add    $0x10,%esp
    2395:	85 c0                	test   %eax,%eax
    2397:	78 17                	js     23b0 <subdir+0x441>
    printf(1, "create dd succeeded!\n");
    2399:	83 ec 08             	sub    $0x8,%esp
    239c:	68 27 50 00 00       	push   $0x5027
    23a1:	6a 01                	push   $0x1
    23a3:	e8 8e 1c 00 00       	call   4036 <printf>
    23a8:	83 c4 10             	add    $0x10,%esp
    exit();
    23ab:	e8 09 1b 00 00       	call   3eb9 <exit>
  }
  if(open("dd", O_RDWR) >= 0){
    23b0:	83 ec 08             	sub    $0x8,%esp
    23b3:	6a 02                	push   $0x2
    23b5:	68 d5 4d 00 00       	push   $0x4dd5
    23ba:	e8 3a 1b 00 00       	call   3ef9 <open>
    23bf:	83 c4 10             	add    $0x10,%esp
    23c2:	85 c0                	test   %eax,%eax
    23c4:	78 17                	js     23dd <subdir+0x46e>
    printf(1, "open dd rdwr succeeded!\n");
    23c6:	83 ec 08             	sub    $0x8,%esp
    23c9:	68 3d 50 00 00       	push   $0x503d
    23ce:	6a 01                	push   $0x1
    23d0:	e8 61 1c 00 00       	call   4036 <printf>
    23d5:	83 c4 10             	add    $0x10,%esp
    exit();
    23d8:	e8 dc 1a 00 00       	call   3eb9 <exit>
  }
  if(open("dd", O_WRONLY) >= 0){
    23dd:	83 ec 08             	sub    $0x8,%esp
    23e0:	6a 01                	push   $0x1
    23e2:	68 d5 4d 00 00       	push   $0x4dd5
    23e7:	e8 0d 1b 00 00       	call   3ef9 <open>
    23ec:	83 c4 10             	add    $0x10,%esp
    23ef:	85 c0                	test   %eax,%eax
    23f1:	78 17                	js     240a <subdir+0x49b>
    printf(1, "open dd wronly succeeded!\n");
    23f3:	83 ec 08             	sub    $0x8,%esp
    23f6:	68 56 50 00 00       	push   $0x5056
    23fb:	6a 01                	push   $0x1
    23fd:	e8 34 1c 00 00       	call   4036 <printf>
    2402:	83 c4 10             	add    $0x10,%esp
    exit();
    2405:	e8 af 1a 00 00       	call   3eb9 <exit>
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    240a:	83 ec 08             	sub    $0x8,%esp
    240d:	68 71 50 00 00       	push   $0x5071
    2412:	68 dd 4f 00 00       	push   $0x4fdd
    2417:	e8 fd 1a 00 00       	call   3f19 <link>
    241c:	83 c4 10             	add    $0x10,%esp
    241f:	85 c0                	test   %eax,%eax
    2421:	75 17                	jne    243a <subdir+0x4cb>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    2423:	83 ec 08             	sub    $0x8,%esp
    2426:	68 7c 50 00 00       	push   $0x507c
    242b:	6a 01                	push   $0x1
    242d:	e8 04 1c 00 00       	call   4036 <printf>
    2432:	83 c4 10             	add    $0x10,%esp
    exit();
    2435:	e8 7f 1a 00 00       	call   3eb9 <exit>
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    243a:	83 ec 08             	sub    $0x8,%esp
    243d:	68 71 50 00 00       	push   $0x5071
    2442:	68 02 50 00 00       	push   $0x5002
    2447:	e8 cd 1a 00 00       	call   3f19 <link>
    244c:	83 c4 10             	add    $0x10,%esp
    244f:	85 c0                	test   %eax,%eax
    2451:	75 17                	jne    246a <subdir+0x4fb>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    2453:	83 ec 08             	sub    $0x8,%esp
    2456:	68 a0 50 00 00       	push   $0x50a0
    245b:	6a 01                	push   $0x1
    245d:	e8 d4 1b 00 00       	call   4036 <printf>
    2462:	83 c4 10             	add    $0x10,%esp
    exit();
    2465:	e8 4f 1a 00 00       	call   3eb9 <exit>
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    246a:	83 ec 08             	sub    $0x8,%esp
    246d:	68 b8 4e 00 00       	push   $0x4eb8
    2472:	68 f0 4d 00 00       	push   $0x4df0
    2477:	e8 9d 1a 00 00       	call   3f19 <link>
    247c:	83 c4 10             	add    $0x10,%esp
    247f:	85 c0                	test   %eax,%eax
    2481:	75 17                	jne    249a <subdir+0x52b>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    2483:	83 ec 08             	sub    $0x8,%esp
    2486:	68 c4 50 00 00       	push   $0x50c4
    248b:	6a 01                	push   $0x1
    248d:	e8 a4 1b 00 00       	call   4036 <printf>
    2492:	83 c4 10             	add    $0x10,%esp
    exit();
    2495:	e8 1f 1a 00 00       	call   3eb9 <exit>
  }
  if(mkdir("dd/ff/ff") == 0){
    249a:	83 ec 0c             	sub    $0xc,%esp
    249d:	68 dd 4f 00 00       	push   $0x4fdd
    24a2:	e8 7a 1a 00 00       	call   3f21 <mkdir>
    24a7:	83 c4 10             	add    $0x10,%esp
    24aa:	85 c0                	test   %eax,%eax
    24ac:	75 17                	jne    24c5 <subdir+0x556>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    24ae:	83 ec 08             	sub    $0x8,%esp
    24b1:	68 e6 50 00 00       	push   $0x50e6
    24b6:	6a 01                	push   $0x1
    24b8:	e8 79 1b 00 00       	call   4036 <printf>
    24bd:	83 c4 10             	add    $0x10,%esp
    exit();
    24c0:	e8 f4 19 00 00       	call   3eb9 <exit>
  }
  if(mkdir("dd/xx/ff") == 0){
    24c5:	83 ec 0c             	sub    $0xc,%esp
    24c8:	68 02 50 00 00       	push   $0x5002
    24cd:	e8 4f 1a 00 00       	call   3f21 <mkdir>
    24d2:	83 c4 10             	add    $0x10,%esp
    24d5:	85 c0                	test   %eax,%eax
    24d7:	75 17                	jne    24f0 <subdir+0x581>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    24d9:	83 ec 08             	sub    $0x8,%esp
    24dc:	68 01 51 00 00       	push   $0x5101
    24e1:	6a 01                	push   $0x1
    24e3:	e8 4e 1b 00 00       	call   4036 <printf>
    24e8:	83 c4 10             	add    $0x10,%esp
    exit();
    24eb:	e8 c9 19 00 00       	call   3eb9 <exit>
  }
  if(mkdir("dd/dd/ffff") == 0){
    24f0:	83 ec 0c             	sub    $0xc,%esp
    24f3:	68 b8 4e 00 00       	push   $0x4eb8
    24f8:	e8 24 1a 00 00       	call   3f21 <mkdir>
    24fd:	83 c4 10             	add    $0x10,%esp
    2500:	85 c0                	test   %eax,%eax
    2502:	75 17                	jne    251b <subdir+0x5ac>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    2504:	83 ec 08             	sub    $0x8,%esp
    2507:	68 1c 51 00 00       	push   $0x511c
    250c:	6a 01                	push   $0x1
    250e:	e8 23 1b 00 00       	call   4036 <printf>
    2513:	83 c4 10             	add    $0x10,%esp
    exit();
    2516:	e8 9e 19 00 00       	call   3eb9 <exit>
  }
  if(unlink("dd/xx/ff") == 0){
    251b:	83 ec 0c             	sub    $0xc,%esp
    251e:	68 02 50 00 00       	push   $0x5002
    2523:	e8 e1 19 00 00       	call   3f09 <unlink>
    2528:	83 c4 10             	add    $0x10,%esp
    252b:	85 c0                	test   %eax,%eax
    252d:	75 17                	jne    2546 <subdir+0x5d7>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    252f:	83 ec 08             	sub    $0x8,%esp
    2532:	68 39 51 00 00       	push   $0x5139
    2537:	6a 01                	push   $0x1
    2539:	e8 f8 1a 00 00       	call   4036 <printf>
    253e:	83 c4 10             	add    $0x10,%esp
    exit();
    2541:	e8 73 19 00 00       	call   3eb9 <exit>
  }
  if(unlink("dd/ff/ff") == 0){
    2546:	83 ec 0c             	sub    $0xc,%esp
    2549:	68 dd 4f 00 00       	push   $0x4fdd
    254e:	e8 b6 19 00 00       	call   3f09 <unlink>
    2553:	83 c4 10             	add    $0x10,%esp
    2556:	85 c0                	test   %eax,%eax
    2558:	75 17                	jne    2571 <subdir+0x602>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    255a:	83 ec 08             	sub    $0x8,%esp
    255d:	68 55 51 00 00       	push   $0x5155
    2562:	6a 01                	push   $0x1
    2564:	e8 cd 1a 00 00       	call   4036 <printf>
    2569:	83 c4 10             	add    $0x10,%esp
    exit();
    256c:	e8 48 19 00 00       	call   3eb9 <exit>
  }
  if(chdir("dd/ff") == 0){
    2571:	83 ec 0c             	sub    $0xc,%esp
    2574:	68 f0 4d 00 00       	push   $0x4df0
    2579:	e8 ab 19 00 00       	call   3f29 <chdir>
    257e:	83 c4 10             	add    $0x10,%esp
    2581:	85 c0                	test   %eax,%eax
    2583:	75 17                	jne    259c <subdir+0x62d>
    printf(1, "chdir dd/ff succeeded!\n");
    2585:	83 ec 08             	sub    $0x8,%esp
    2588:	68 71 51 00 00       	push   $0x5171
    258d:	6a 01                	push   $0x1
    258f:	e8 a2 1a 00 00       	call   4036 <printf>
    2594:	83 c4 10             	add    $0x10,%esp
    exit();
    2597:	e8 1d 19 00 00       	call   3eb9 <exit>
  }
  if(chdir("dd/xx") == 0){
    259c:	83 ec 0c             	sub    $0xc,%esp
    259f:	68 89 51 00 00       	push   $0x5189
    25a4:	e8 80 19 00 00       	call   3f29 <chdir>
    25a9:	83 c4 10             	add    $0x10,%esp
    25ac:	85 c0                	test   %eax,%eax
    25ae:	75 17                	jne    25c7 <subdir+0x658>
    printf(1, "chdir dd/xx succeeded!\n");
    25b0:	83 ec 08             	sub    $0x8,%esp
    25b3:	68 8f 51 00 00       	push   $0x518f
    25b8:	6a 01                	push   $0x1
    25ba:	e8 77 1a 00 00       	call   4036 <printf>
    25bf:	83 c4 10             	add    $0x10,%esp
    exit();
    25c2:	e8 f2 18 00 00       	call   3eb9 <exit>
  }

  if(unlink("dd/dd/ffff") != 0){
    25c7:	83 ec 0c             	sub    $0xc,%esp
    25ca:	68 b8 4e 00 00       	push   $0x4eb8
    25cf:	e8 35 19 00 00       	call   3f09 <unlink>
    25d4:	83 c4 10             	add    $0x10,%esp
    25d7:	85 c0                	test   %eax,%eax
    25d9:	74 17                	je     25f2 <subdir+0x683>
    printf(1, "unlink dd/dd/ff failed\n");
    25db:	83 ec 08             	sub    $0x8,%esp
    25de:	68 e5 4e 00 00       	push   $0x4ee5
    25e3:	6a 01                	push   $0x1
    25e5:	e8 4c 1a 00 00       	call   4036 <printf>
    25ea:	83 c4 10             	add    $0x10,%esp
    exit();
    25ed:	e8 c7 18 00 00       	call   3eb9 <exit>
  }
  if(unlink("dd/ff") != 0){
    25f2:	83 ec 0c             	sub    $0xc,%esp
    25f5:	68 f0 4d 00 00       	push   $0x4df0
    25fa:	e8 0a 19 00 00       	call   3f09 <unlink>
    25ff:	83 c4 10             	add    $0x10,%esp
    2602:	85 c0                	test   %eax,%eax
    2604:	74 17                	je     261d <subdir+0x6ae>
    printf(1, "unlink dd/ff failed\n");
    2606:	83 ec 08             	sub    $0x8,%esp
    2609:	68 a7 51 00 00       	push   $0x51a7
    260e:	6a 01                	push   $0x1
    2610:	e8 21 1a 00 00       	call   4036 <printf>
    2615:	83 c4 10             	add    $0x10,%esp
    exit();
    2618:	e8 9c 18 00 00       	call   3eb9 <exit>
  }
  if(unlink("dd") == 0){
    261d:	83 ec 0c             	sub    $0xc,%esp
    2620:	68 d5 4d 00 00       	push   $0x4dd5
    2625:	e8 df 18 00 00       	call   3f09 <unlink>
    262a:	83 c4 10             	add    $0x10,%esp
    262d:	85 c0                	test   %eax,%eax
    262f:	75 17                	jne    2648 <subdir+0x6d9>
    printf(1, "unlink non-empty dd succeeded!\n");
    2631:	83 ec 08             	sub    $0x8,%esp
    2634:	68 bc 51 00 00       	push   $0x51bc
    2639:	6a 01                	push   $0x1
    263b:	e8 f6 19 00 00       	call   4036 <printf>
    2640:	83 c4 10             	add    $0x10,%esp
    exit();
    2643:	e8 71 18 00 00       	call   3eb9 <exit>
  }
  if(unlink("dd/dd") < 0){
    2648:	83 ec 0c             	sub    $0xc,%esp
    264b:	68 dc 51 00 00       	push   $0x51dc
    2650:	e8 b4 18 00 00       	call   3f09 <unlink>
    2655:	83 c4 10             	add    $0x10,%esp
    2658:	85 c0                	test   %eax,%eax
    265a:	79 17                	jns    2673 <subdir+0x704>
    printf(1, "unlink dd/dd failed\n");
    265c:	83 ec 08             	sub    $0x8,%esp
    265f:	68 e2 51 00 00       	push   $0x51e2
    2664:	6a 01                	push   $0x1
    2666:	e8 cb 19 00 00       	call   4036 <printf>
    266b:	83 c4 10             	add    $0x10,%esp
    exit();
    266e:	e8 46 18 00 00       	call   3eb9 <exit>
  }
  if(unlink("dd") < 0){
    2673:	83 ec 0c             	sub    $0xc,%esp
    2676:	68 d5 4d 00 00       	push   $0x4dd5
    267b:	e8 89 18 00 00       	call   3f09 <unlink>
    2680:	83 c4 10             	add    $0x10,%esp
    2683:	85 c0                	test   %eax,%eax
    2685:	79 17                	jns    269e <subdir+0x72f>
    printf(1, "unlink dd failed\n");
    2687:	83 ec 08             	sub    $0x8,%esp
    268a:	68 f7 51 00 00       	push   $0x51f7
    268f:	6a 01                	push   $0x1
    2691:	e8 a0 19 00 00       	call   4036 <printf>
    2696:	83 c4 10             	add    $0x10,%esp
    exit();
    2699:	e8 1b 18 00 00       	call   3eb9 <exit>
  }

  printf(1, "subdir ok\n");
    269e:	83 ec 08             	sub    $0x8,%esp
    26a1:	68 09 52 00 00       	push   $0x5209
    26a6:	6a 01                	push   $0x1
    26a8:	e8 89 19 00 00       	call   4036 <printf>
    26ad:	83 c4 10             	add    $0x10,%esp
}
    26b0:	c9                   	leave  
    26b1:	c3                   	ret    

000026b2 <bigwrite>:

// test writes that are larger than the log.
void
bigwrite(void)
{
    26b2:	55                   	push   %ebp
    26b3:	89 e5                	mov    %esp,%ebp
    26b5:	83 ec 18             	sub    $0x18,%esp
  int fd, sz;

  printf(1, "bigwrite test\n");
    26b8:	83 ec 08             	sub    $0x8,%esp
    26bb:	68 14 52 00 00       	push   $0x5214
    26c0:	6a 01                	push   $0x1
    26c2:	e8 6f 19 00 00       	call   4036 <printf>
    26c7:	83 c4 10             	add    $0x10,%esp

  unlink("bigwrite");
    26ca:	83 ec 0c             	sub    $0xc,%esp
    26cd:	68 23 52 00 00       	push   $0x5223
    26d2:	e8 32 18 00 00       	call   3f09 <unlink>
    26d7:	83 c4 10             	add    $0x10,%esp
  for(sz = 499; sz < 12*512; sz += 471){
    26da:	c7 45 f4 f3 01 00 00 	movl   $0x1f3,-0xc(%ebp)
    26e1:	e9 a8 00 00 00       	jmp    278e <bigwrite+0xdc>
    fd = open("bigwrite", O_CREATE | O_RDWR);
    26e6:	83 ec 08             	sub    $0x8,%esp
    26e9:	68 02 02 00 00       	push   $0x202
    26ee:	68 23 52 00 00       	push   $0x5223
    26f3:	e8 01 18 00 00       	call   3ef9 <open>
    26f8:	83 c4 10             	add    $0x10,%esp
    26fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fd < 0){
    26fe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2702:	79 17                	jns    271b <bigwrite+0x69>
      printf(1, "cannot create bigwrite\n");
    2704:	83 ec 08             	sub    $0x8,%esp
    2707:	68 2c 52 00 00       	push   $0x522c
    270c:	6a 01                	push   $0x1
    270e:	e8 23 19 00 00       	call   4036 <printf>
    2713:	83 c4 10             	add    $0x10,%esp
      exit();
    2716:	e8 9e 17 00 00       	call   3eb9 <exit>
    }
    int i;
    for(i = 0; i < 2; i++){
    271b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    2722:	eb 3f                	jmp    2763 <bigwrite+0xb1>
      int cc = write(fd, buf, sz);
    2724:	83 ec 04             	sub    $0x4,%esp
    2727:	ff 75 f4             	pushl  -0xc(%ebp)
    272a:	68 00 8b 00 00       	push   $0x8b00
    272f:	ff 75 ec             	pushl  -0x14(%ebp)
    2732:	e8 a2 17 00 00       	call   3ed9 <write>
    2737:	83 c4 10             	add    $0x10,%esp
    273a:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(cc != sz){
    273d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2740:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    2743:	74 1a                	je     275f <bigwrite+0xad>
        printf(1, "write(%d) ret %d\n", sz, cc);
    2745:	ff 75 e8             	pushl  -0x18(%ebp)
    2748:	ff 75 f4             	pushl  -0xc(%ebp)
    274b:	68 44 52 00 00       	push   $0x5244
    2750:	6a 01                	push   $0x1
    2752:	e8 df 18 00 00       	call   4036 <printf>
    2757:	83 c4 10             	add    $0x10,%esp
        exit();
    275a:	e8 5a 17 00 00       	call   3eb9 <exit>
    if(fd < 0){
      printf(1, "cannot create bigwrite\n");
      exit();
    }
    int i;
    for(i = 0; i < 2; i++){
    275f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    2763:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
    2767:	7e bb                	jle    2724 <bigwrite+0x72>
      if(cc != sz){
        printf(1, "write(%d) ret %d\n", sz, cc);
        exit();
      }
    }
    close(fd);
    2769:	83 ec 0c             	sub    $0xc,%esp
    276c:	ff 75 ec             	pushl  -0x14(%ebp)
    276f:	e8 6d 17 00 00       	call   3ee1 <close>
    2774:	83 c4 10             	add    $0x10,%esp
    unlink("bigwrite");
    2777:	83 ec 0c             	sub    $0xc,%esp
    277a:	68 23 52 00 00       	push   $0x5223
    277f:	e8 85 17 00 00       	call   3f09 <unlink>
    2784:	83 c4 10             	add    $0x10,%esp
  int fd, sz;

  printf(1, "bigwrite test\n");

  unlink("bigwrite");
  for(sz = 499; sz < 12*512; sz += 471){
    2787:	81 45 f4 d7 01 00 00 	addl   $0x1d7,-0xc(%ebp)
    278e:	81 7d f4 ff 17 00 00 	cmpl   $0x17ff,-0xc(%ebp)
    2795:	0f 8e 4b ff ff ff    	jle    26e6 <bigwrite+0x34>
    }
    close(fd);
    unlink("bigwrite");
  }

  printf(1, "bigwrite ok\n");
    279b:	83 ec 08             	sub    $0x8,%esp
    279e:	68 56 52 00 00       	push   $0x5256
    27a3:	6a 01                	push   $0x1
    27a5:	e8 8c 18 00 00       	call   4036 <printf>
    27aa:	83 c4 10             	add    $0x10,%esp
}
    27ad:	c9                   	leave  
    27ae:	c3                   	ret    

000027af <bigfile>:

void
bigfile(void)
{
    27af:	55                   	push   %ebp
    27b0:	89 e5                	mov    %esp,%ebp
    27b2:	83 ec 18             	sub    $0x18,%esp
  int fd, i, total, cc;

  printf(1, "bigfile test\n");
    27b5:	83 ec 08             	sub    $0x8,%esp
    27b8:	68 63 52 00 00       	push   $0x5263
    27bd:	6a 01                	push   $0x1
    27bf:	e8 72 18 00 00       	call   4036 <printf>
    27c4:	83 c4 10             	add    $0x10,%esp

  unlink("bigfile");
    27c7:	83 ec 0c             	sub    $0xc,%esp
    27ca:	68 71 52 00 00       	push   $0x5271
    27cf:	e8 35 17 00 00       	call   3f09 <unlink>
    27d4:	83 c4 10             	add    $0x10,%esp
  fd = open("bigfile", O_CREATE | O_RDWR);
    27d7:	83 ec 08             	sub    $0x8,%esp
    27da:	68 02 02 00 00       	push   $0x202
    27df:	68 71 52 00 00       	push   $0x5271
    27e4:	e8 10 17 00 00       	call   3ef9 <open>
    27e9:	83 c4 10             	add    $0x10,%esp
    27ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    27ef:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    27f3:	79 17                	jns    280c <bigfile+0x5d>
    printf(1, "cannot create bigfile");
    27f5:	83 ec 08             	sub    $0x8,%esp
    27f8:	68 79 52 00 00       	push   $0x5279
    27fd:	6a 01                	push   $0x1
    27ff:	e8 32 18 00 00       	call   4036 <printf>
    2804:	83 c4 10             	add    $0x10,%esp
    exit();
    2807:	e8 ad 16 00 00       	call   3eb9 <exit>
  }
  for(i = 0; i < 20; i++){
    280c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2813:	eb 52                	jmp    2867 <bigfile+0xb8>
    memset(buf, i, 600);
    2815:	83 ec 04             	sub    $0x4,%esp
    2818:	68 58 02 00 00       	push   $0x258
    281d:	ff 75 f4             	pushl  -0xc(%ebp)
    2820:	68 00 8b 00 00       	push   $0x8b00
    2825:	e8 f5 14 00 00       	call   3d1f <memset>
    282a:	83 c4 10             	add    $0x10,%esp
    if(write(fd, buf, 600) != 600){
    282d:	83 ec 04             	sub    $0x4,%esp
    2830:	68 58 02 00 00       	push   $0x258
    2835:	68 00 8b 00 00       	push   $0x8b00
    283a:	ff 75 ec             	pushl  -0x14(%ebp)
    283d:	e8 97 16 00 00       	call   3ed9 <write>
    2842:	83 c4 10             	add    $0x10,%esp
    2845:	3d 58 02 00 00       	cmp    $0x258,%eax
    284a:	74 17                	je     2863 <bigfile+0xb4>
      printf(1, "write bigfile failed\n");
    284c:	83 ec 08             	sub    $0x8,%esp
    284f:	68 8f 52 00 00       	push   $0x528f
    2854:	6a 01                	push   $0x1
    2856:	e8 db 17 00 00       	call   4036 <printf>
    285b:	83 c4 10             	add    $0x10,%esp
      exit();
    285e:	e8 56 16 00 00       	call   3eb9 <exit>
  fd = open("bigfile", O_CREATE | O_RDWR);
  if(fd < 0){
    printf(1, "cannot create bigfile");
    exit();
  }
  for(i = 0; i < 20; i++){
    2863:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    2867:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    286b:	7e a8                	jle    2815 <bigfile+0x66>
    if(write(fd, buf, 600) != 600){
      printf(1, "write bigfile failed\n");
      exit();
    }
  }
  close(fd);
    286d:	83 ec 0c             	sub    $0xc,%esp
    2870:	ff 75 ec             	pushl  -0x14(%ebp)
    2873:	e8 69 16 00 00       	call   3ee1 <close>
    2878:	83 c4 10             	add    $0x10,%esp

  fd = open("bigfile", 0);
    287b:	83 ec 08             	sub    $0x8,%esp
    287e:	6a 00                	push   $0x0
    2880:	68 71 52 00 00       	push   $0x5271
    2885:	e8 6f 16 00 00       	call   3ef9 <open>
    288a:	83 c4 10             	add    $0x10,%esp
    288d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    2890:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2894:	79 17                	jns    28ad <bigfile+0xfe>
    printf(1, "cannot open bigfile\n");
    2896:	83 ec 08             	sub    $0x8,%esp
    2899:	68 a5 52 00 00       	push   $0x52a5
    289e:	6a 01                	push   $0x1
    28a0:	e8 91 17 00 00       	call   4036 <printf>
    28a5:	83 c4 10             	add    $0x10,%esp
    exit();
    28a8:	e8 0c 16 00 00       	call   3eb9 <exit>
  }
  total = 0;
    28ad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(i = 0; ; i++){
    28b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    cc = read(fd, buf, 300);
    28bb:	83 ec 04             	sub    $0x4,%esp
    28be:	68 2c 01 00 00       	push   $0x12c
    28c3:	68 00 8b 00 00       	push   $0x8b00
    28c8:	ff 75 ec             	pushl  -0x14(%ebp)
    28cb:	e8 01 16 00 00       	call   3ed1 <read>
    28d0:	83 c4 10             	add    $0x10,%esp
    28d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(cc < 0){
    28d6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    28da:	79 17                	jns    28f3 <bigfile+0x144>
      printf(1, "read bigfile failed\n");
    28dc:	83 ec 08             	sub    $0x8,%esp
    28df:	68 ba 52 00 00       	push   $0x52ba
    28e4:	6a 01                	push   $0x1
    28e6:	e8 4b 17 00 00       	call   4036 <printf>
    28eb:	83 c4 10             	add    $0x10,%esp
      exit();
    28ee:	e8 c6 15 00 00       	call   3eb9 <exit>
    }
    if(cc == 0)
    28f3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    28f7:	75 1e                	jne    2917 <bigfile+0x168>
      break;
    28f9:	90                   	nop
      printf(1, "read bigfile wrong data\n");
      exit();
    }
    total += cc;
  }
  close(fd);
    28fa:	83 ec 0c             	sub    $0xc,%esp
    28fd:	ff 75 ec             	pushl  -0x14(%ebp)
    2900:	e8 dc 15 00 00       	call   3ee1 <close>
    2905:	83 c4 10             	add    $0x10,%esp
  if(total != 20*600){
    2908:	81 7d f0 e0 2e 00 00 	cmpl   $0x2ee0,-0x10(%ebp)
    290f:	0f 84 93 00 00 00    	je     29a8 <bigfile+0x1f9>
    2915:	eb 7a                	jmp    2991 <bigfile+0x1e2>
      printf(1, "read bigfile failed\n");
      exit();
    }
    if(cc == 0)
      break;
    if(cc != 300){
    2917:	81 7d e8 2c 01 00 00 	cmpl   $0x12c,-0x18(%ebp)
    291e:	74 17                	je     2937 <bigfile+0x188>
      printf(1, "short read bigfile\n");
    2920:	83 ec 08             	sub    $0x8,%esp
    2923:	68 cf 52 00 00       	push   $0x52cf
    2928:	6a 01                	push   $0x1
    292a:	e8 07 17 00 00       	call   4036 <printf>
    292f:	83 c4 10             	add    $0x10,%esp
      exit();
    2932:	e8 82 15 00 00       	call   3eb9 <exit>
    }
    if(buf[0] != i/2 || buf[299] != i/2){
    2937:	0f b6 05 00 8b 00 00 	movzbl 0x8b00,%eax
    293e:	0f be d0             	movsbl %al,%edx
    2941:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2944:	89 c1                	mov    %eax,%ecx
    2946:	c1 e9 1f             	shr    $0x1f,%ecx
    2949:	01 c8                	add    %ecx,%eax
    294b:	d1 f8                	sar    %eax
    294d:	39 c2                	cmp    %eax,%edx
    294f:	75 1a                	jne    296b <bigfile+0x1bc>
    2951:	0f b6 05 2b 8c 00 00 	movzbl 0x8c2b,%eax
    2958:	0f be d0             	movsbl %al,%edx
    295b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    295e:	89 c1                	mov    %eax,%ecx
    2960:	c1 e9 1f             	shr    $0x1f,%ecx
    2963:	01 c8                	add    %ecx,%eax
    2965:	d1 f8                	sar    %eax
    2967:	39 c2                	cmp    %eax,%edx
    2969:	74 17                	je     2982 <bigfile+0x1d3>
      printf(1, "read bigfile wrong data\n");
    296b:	83 ec 08             	sub    $0x8,%esp
    296e:	68 e3 52 00 00       	push   $0x52e3
    2973:	6a 01                	push   $0x1
    2975:	e8 bc 16 00 00       	call   4036 <printf>
    297a:	83 c4 10             	add    $0x10,%esp
      exit();
    297d:	e8 37 15 00 00       	call   3eb9 <exit>
    }
    total += cc;
    2982:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2985:	01 45 f0             	add    %eax,-0x10(%ebp)
  if(fd < 0){
    printf(1, "cannot open bigfile\n");
    exit();
  }
  total = 0;
  for(i = 0; ; i++){
    2988:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(buf[0] != i/2 || buf[299] != i/2){
      printf(1, "read bigfile wrong data\n");
      exit();
    }
    total += cc;
  }
    298c:	e9 2a ff ff ff       	jmp    28bb <bigfile+0x10c>
  close(fd);
  if(total != 20*600){
    printf(1, "read bigfile wrong total\n");
    2991:	83 ec 08             	sub    $0x8,%esp
    2994:	68 fc 52 00 00       	push   $0x52fc
    2999:	6a 01                	push   $0x1
    299b:	e8 96 16 00 00       	call   4036 <printf>
    29a0:	83 c4 10             	add    $0x10,%esp
    exit();
    29a3:	e8 11 15 00 00       	call   3eb9 <exit>
  }
  unlink("bigfile");
    29a8:	83 ec 0c             	sub    $0xc,%esp
    29ab:	68 71 52 00 00       	push   $0x5271
    29b0:	e8 54 15 00 00       	call   3f09 <unlink>
    29b5:	83 c4 10             	add    $0x10,%esp

  printf(1, "bigfile test ok\n");
    29b8:	83 ec 08             	sub    $0x8,%esp
    29bb:	68 16 53 00 00       	push   $0x5316
    29c0:	6a 01                	push   $0x1
    29c2:	e8 6f 16 00 00       	call   4036 <printf>
    29c7:	83 c4 10             	add    $0x10,%esp
}
    29ca:	c9                   	leave  
    29cb:	c3                   	ret    

000029cc <fourteen>:

void
fourteen(void)
{
    29cc:	55                   	push   %ebp
    29cd:	89 e5                	mov    %esp,%ebp
    29cf:	83 ec 18             	sub    $0x18,%esp
  int fd;

  // DIRSIZ is 14.
  printf(1, "fourteen test\n");
    29d2:	83 ec 08             	sub    $0x8,%esp
    29d5:	68 27 53 00 00       	push   $0x5327
    29da:	6a 01                	push   $0x1
    29dc:	e8 55 16 00 00       	call   4036 <printf>
    29e1:	83 c4 10             	add    $0x10,%esp

  if(mkdir("12345678901234") != 0){
    29e4:	83 ec 0c             	sub    $0xc,%esp
    29e7:	68 36 53 00 00       	push   $0x5336
    29ec:	e8 30 15 00 00       	call   3f21 <mkdir>
    29f1:	83 c4 10             	add    $0x10,%esp
    29f4:	85 c0                	test   %eax,%eax
    29f6:	74 17                	je     2a0f <fourteen+0x43>
    printf(1, "mkdir 12345678901234 failed\n");
    29f8:	83 ec 08             	sub    $0x8,%esp
    29fb:	68 45 53 00 00       	push   $0x5345
    2a00:	6a 01                	push   $0x1
    2a02:	e8 2f 16 00 00       	call   4036 <printf>
    2a07:	83 c4 10             	add    $0x10,%esp
    exit();
    2a0a:	e8 aa 14 00 00       	call   3eb9 <exit>
  }
  if(mkdir("12345678901234/123456789012345") != 0){
    2a0f:	83 ec 0c             	sub    $0xc,%esp
    2a12:	68 64 53 00 00       	push   $0x5364
    2a17:	e8 05 15 00 00       	call   3f21 <mkdir>
    2a1c:	83 c4 10             	add    $0x10,%esp
    2a1f:	85 c0                	test   %eax,%eax
    2a21:	74 17                	je     2a3a <fourteen+0x6e>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    2a23:	83 ec 08             	sub    $0x8,%esp
    2a26:	68 84 53 00 00       	push   $0x5384
    2a2b:	6a 01                	push   $0x1
    2a2d:	e8 04 16 00 00       	call   4036 <printf>
    2a32:	83 c4 10             	add    $0x10,%esp
    exit();
    2a35:	e8 7f 14 00 00       	call   3eb9 <exit>
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2a3a:	83 ec 08             	sub    $0x8,%esp
    2a3d:	68 00 02 00 00       	push   $0x200
    2a42:	68 b4 53 00 00       	push   $0x53b4
    2a47:	e8 ad 14 00 00       	call   3ef9 <open>
    2a4c:	83 c4 10             	add    $0x10,%esp
    2a4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2a52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2a56:	79 17                	jns    2a6f <fourteen+0xa3>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    2a58:	83 ec 08             	sub    $0x8,%esp
    2a5b:	68 e4 53 00 00       	push   $0x53e4
    2a60:	6a 01                	push   $0x1
    2a62:	e8 cf 15 00 00       	call   4036 <printf>
    2a67:	83 c4 10             	add    $0x10,%esp
    exit();
    2a6a:	e8 4a 14 00 00       	call   3eb9 <exit>
  }
  close(fd);
    2a6f:	83 ec 0c             	sub    $0xc,%esp
    2a72:	ff 75 f4             	pushl  -0xc(%ebp)
    2a75:	e8 67 14 00 00       	call   3ee1 <close>
    2a7a:	83 c4 10             	add    $0x10,%esp
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2a7d:	83 ec 08             	sub    $0x8,%esp
    2a80:	6a 00                	push   $0x0
    2a82:	68 24 54 00 00       	push   $0x5424
    2a87:	e8 6d 14 00 00       	call   3ef9 <open>
    2a8c:	83 c4 10             	add    $0x10,%esp
    2a8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2a92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2a96:	79 17                	jns    2aaf <fourteen+0xe3>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    2a98:	83 ec 08             	sub    $0x8,%esp
    2a9b:	68 54 54 00 00       	push   $0x5454
    2aa0:	6a 01                	push   $0x1
    2aa2:	e8 8f 15 00 00       	call   4036 <printf>
    2aa7:	83 c4 10             	add    $0x10,%esp
    exit();
    2aaa:	e8 0a 14 00 00       	call   3eb9 <exit>
  }
  close(fd);
    2aaf:	83 ec 0c             	sub    $0xc,%esp
    2ab2:	ff 75 f4             	pushl  -0xc(%ebp)
    2ab5:	e8 27 14 00 00       	call   3ee1 <close>
    2aba:	83 c4 10             	add    $0x10,%esp

  if(mkdir("12345678901234/12345678901234") == 0){
    2abd:	83 ec 0c             	sub    $0xc,%esp
    2ac0:	68 8e 54 00 00       	push   $0x548e
    2ac5:	e8 57 14 00 00       	call   3f21 <mkdir>
    2aca:	83 c4 10             	add    $0x10,%esp
    2acd:	85 c0                	test   %eax,%eax
    2acf:	75 17                	jne    2ae8 <fourteen+0x11c>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    2ad1:	83 ec 08             	sub    $0x8,%esp
    2ad4:	68 ac 54 00 00       	push   $0x54ac
    2ad9:	6a 01                	push   $0x1
    2adb:	e8 56 15 00 00       	call   4036 <printf>
    2ae0:	83 c4 10             	add    $0x10,%esp
    exit();
    2ae3:	e8 d1 13 00 00       	call   3eb9 <exit>
  }
  if(mkdir("123456789012345/12345678901234") == 0){
    2ae8:	83 ec 0c             	sub    $0xc,%esp
    2aeb:	68 dc 54 00 00       	push   $0x54dc
    2af0:	e8 2c 14 00 00       	call   3f21 <mkdir>
    2af5:	83 c4 10             	add    $0x10,%esp
    2af8:	85 c0                	test   %eax,%eax
    2afa:	75 17                	jne    2b13 <fourteen+0x147>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    2afc:	83 ec 08             	sub    $0x8,%esp
    2aff:	68 fc 54 00 00       	push   $0x54fc
    2b04:	6a 01                	push   $0x1
    2b06:	e8 2b 15 00 00       	call   4036 <printf>
    2b0b:	83 c4 10             	add    $0x10,%esp
    exit();
    2b0e:	e8 a6 13 00 00       	call   3eb9 <exit>
  }

  printf(1, "fourteen ok\n");
    2b13:	83 ec 08             	sub    $0x8,%esp
    2b16:	68 2d 55 00 00       	push   $0x552d
    2b1b:	6a 01                	push   $0x1
    2b1d:	e8 14 15 00 00       	call   4036 <printf>
    2b22:	83 c4 10             	add    $0x10,%esp
}
    2b25:	c9                   	leave  
    2b26:	c3                   	ret    

00002b27 <rmdot>:

void
rmdot(void)
{
    2b27:	55                   	push   %ebp
    2b28:	89 e5                	mov    %esp,%ebp
    2b2a:	83 ec 08             	sub    $0x8,%esp
  printf(1, "rmdot test\n");
    2b2d:	83 ec 08             	sub    $0x8,%esp
    2b30:	68 3a 55 00 00       	push   $0x553a
    2b35:	6a 01                	push   $0x1
    2b37:	e8 fa 14 00 00       	call   4036 <printf>
    2b3c:	83 c4 10             	add    $0x10,%esp
  if(mkdir("dots") != 0){
    2b3f:	83 ec 0c             	sub    $0xc,%esp
    2b42:	68 46 55 00 00       	push   $0x5546
    2b47:	e8 d5 13 00 00       	call   3f21 <mkdir>
    2b4c:	83 c4 10             	add    $0x10,%esp
    2b4f:	85 c0                	test   %eax,%eax
    2b51:	74 17                	je     2b6a <rmdot+0x43>
    printf(1, "mkdir dots failed\n");
    2b53:	83 ec 08             	sub    $0x8,%esp
    2b56:	68 4b 55 00 00       	push   $0x554b
    2b5b:	6a 01                	push   $0x1
    2b5d:	e8 d4 14 00 00       	call   4036 <printf>
    2b62:	83 c4 10             	add    $0x10,%esp
    exit();
    2b65:	e8 4f 13 00 00       	call   3eb9 <exit>
  }
  if(chdir("dots") != 0){
    2b6a:	83 ec 0c             	sub    $0xc,%esp
    2b6d:	68 46 55 00 00       	push   $0x5546
    2b72:	e8 b2 13 00 00       	call   3f29 <chdir>
    2b77:	83 c4 10             	add    $0x10,%esp
    2b7a:	85 c0                	test   %eax,%eax
    2b7c:	74 17                	je     2b95 <rmdot+0x6e>
    printf(1, "chdir dots failed\n");
    2b7e:	83 ec 08             	sub    $0x8,%esp
    2b81:	68 5e 55 00 00       	push   $0x555e
    2b86:	6a 01                	push   $0x1
    2b88:	e8 a9 14 00 00       	call   4036 <printf>
    2b8d:	83 c4 10             	add    $0x10,%esp
    exit();
    2b90:	e8 24 13 00 00       	call   3eb9 <exit>
  }
  if(unlink(".") == 0){
    2b95:	83 ec 0c             	sub    $0xc,%esp
    2b98:	68 77 4c 00 00       	push   $0x4c77
    2b9d:	e8 67 13 00 00       	call   3f09 <unlink>
    2ba2:	83 c4 10             	add    $0x10,%esp
    2ba5:	85 c0                	test   %eax,%eax
    2ba7:	75 17                	jne    2bc0 <rmdot+0x99>
    printf(1, "rm . worked!\n");
    2ba9:	83 ec 08             	sub    $0x8,%esp
    2bac:	68 71 55 00 00       	push   $0x5571
    2bb1:	6a 01                	push   $0x1
    2bb3:	e8 7e 14 00 00       	call   4036 <printf>
    2bb8:	83 c4 10             	add    $0x10,%esp
    exit();
    2bbb:	e8 f9 12 00 00       	call   3eb9 <exit>
  }
  if(unlink("..") == 0){
    2bc0:	83 ec 0c             	sub    $0xc,%esp
    2bc3:	68 0a 48 00 00       	push   $0x480a
    2bc8:	e8 3c 13 00 00       	call   3f09 <unlink>
    2bcd:	83 c4 10             	add    $0x10,%esp
    2bd0:	85 c0                	test   %eax,%eax
    2bd2:	75 17                	jne    2beb <rmdot+0xc4>
    printf(1, "rm .. worked!\n");
    2bd4:	83 ec 08             	sub    $0x8,%esp
    2bd7:	68 7f 55 00 00       	push   $0x557f
    2bdc:	6a 01                	push   $0x1
    2bde:	e8 53 14 00 00       	call   4036 <printf>
    2be3:	83 c4 10             	add    $0x10,%esp
    exit();
    2be6:	e8 ce 12 00 00       	call   3eb9 <exit>
  }
  if(chdir("/") != 0){
    2beb:	83 ec 0c             	sub    $0xc,%esp
    2bee:	68 5e 44 00 00       	push   $0x445e
    2bf3:	e8 31 13 00 00       	call   3f29 <chdir>
    2bf8:	83 c4 10             	add    $0x10,%esp
    2bfb:	85 c0                	test   %eax,%eax
    2bfd:	74 17                	je     2c16 <rmdot+0xef>
    printf(1, "chdir / failed\n");
    2bff:	83 ec 08             	sub    $0x8,%esp
    2c02:	68 60 44 00 00       	push   $0x4460
    2c07:	6a 01                	push   $0x1
    2c09:	e8 28 14 00 00       	call   4036 <printf>
    2c0e:	83 c4 10             	add    $0x10,%esp
    exit();
    2c11:	e8 a3 12 00 00       	call   3eb9 <exit>
  }
  if(unlink("dots/.") == 0){
    2c16:	83 ec 0c             	sub    $0xc,%esp
    2c19:	68 8e 55 00 00       	push   $0x558e
    2c1e:	e8 e6 12 00 00       	call   3f09 <unlink>
    2c23:	83 c4 10             	add    $0x10,%esp
    2c26:	85 c0                	test   %eax,%eax
    2c28:	75 17                	jne    2c41 <rmdot+0x11a>
    printf(1, "unlink dots/. worked!\n");
    2c2a:	83 ec 08             	sub    $0x8,%esp
    2c2d:	68 95 55 00 00       	push   $0x5595
    2c32:	6a 01                	push   $0x1
    2c34:	e8 fd 13 00 00       	call   4036 <printf>
    2c39:	83 c4 10             	add    $0x10,%esp
    exit();
    2c3c:	e8 78 12 00 00       	call   3eb9 <exit>
  }
  if(unlink("dots/..") == 0){
    2c41:	83 ec 0c             	sub    $0xc,%esp
    2c44:	68 ac 55 00 00       	push   $0x55ac
    2c49:	e8 bb 12 00 00       	call   3f09 <unlink>
    2c4e:	83 c4 10             	add    $0x10,%esp
    2c51:	85 c0                	test   %eax,%eax
    2c53:	75 17                	jne    2c6c <rmdot+0x145>
    printf(1, "unlink dots/.. worked!\n");
    2c55:	83 ec 08             	sub    $0x8,%esp
    2c58:	68 b4 55 00 00       	push   $0x55b4
    2c5d:	6a 01                	push   $0x1
    2c5f:	e8 d2 13 00 00       	call   4036 <printf>
    2c64:	83 c4 10             	add    $0x10,%esp
    exit();
    2c67:	e8 4d 12 00 00       	call   3eb9 <exit>
  }
  if(unlink("dots") != 0){
    2c6c:	83 ec 0c             	sub    $0xc,%esp
    2c6f:	68 46 55 00 00       	push   $0x5546
    2c74:	e8 90 12 00 00       	call   3f09 <unlink>
    2c79:	83 c4 10             	add    $0x10,%esp
    2c7c:	85 c0                	test   %eax,%eax
    2c7e:	74 17                	je     2c97 <rmdot+0x170>
    printf(1, "unlink dots failed!\n");
    2c80:	83 ec 08             	sub    $0x8,%esp
    2c83:	68 cc 55 00 00       	push   $0x55cc
    2c88:	6a 01                	push   $0x1
    2c8a:	e8 a7 13 00 00       	call   4036 <printf>
    2c8f:	83 c4 10             	add    $0x10,%esp
    exit();
    2c92:	e8 22 12 00 00       	call   3eb9 <exit>
  }
  printf(1, "rmdot ok\n");
    2c97:	83 ec 08             	sub    $0x8,%esp
    2c9a:	68 e1 55 00 00       	push   $0x55e1
    2c9f:	6a 01                	push   $0x1
    2ca1:	e8 90 13 00 00       	call   4036 <printf>
    2ca6:	83 c4 10             	add    $0x10,%esp
}
    2ca9:	c9                   	leave  
    2caa:	c3                   	ret    

00002cab <dirfile>:

void
dirfile(void)
{
    2cab:	55                   	push   %ebp
    2cac:	89 e5                	mov    %esp,%ebp
    2cae:	83 ec 18             	sub    $0x18,%esp
  int fd;

  printf(1, "dir vs file\n");
    2cb1:	83 ec 08             	sub    $0x8,%esp
    2cb4:	68 eb 55 00 00       	push   $0x55eb
    2cb9:	6a 01                	push   $0x1
    2cbb:	e8 76 13 00 00       	call   4036 <printf>
    2cc0:	83 c4 10             	add    $0x10,%esp

  fd = open("dirfile", O_CREATE);
    2cc3:	83 ec 08             	sub    $0x8,%esp
    2cc6:	68 00 02 00 00       	push   $0x200
    2ccb:	68 f8 55 00 00       	push   $0x55f8
    2cd0:	e8 24 12 00 00       	call   3ef9 <open>
    2cd5:	83 c4 10             	add    $0x10,%esp
    2cd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2cdb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2cdf:	79 17                	jns    2cf8 <dirfile+0x4d>
    printf(1, "create dirfile failed\n");
    2ce1:	83 ec 08             	sub    $0x8,%esp
    2ce4:	68 00 56 00 00       	push   $0x5600
    2ce9:	6a 01                	push   $0x1
    2ceb:	e8 46 13 00 00       	call   4036 <printf>
    2cf0:	83 c4 10             	add    $0x10,%esp
    exit();
    2cf3:	e8 c1 11 00 00       	call   3eb9 <exit>
  }
  close(fd);
    2cf8:	83 ec 0c             	sub    $0xc,%esp
    2cfb:	ff 75 f4             	pushl  -0xc(%ebp)
    2cfe:	e8 de 11 00 00       	call   3ee1 <close>
    2d03:	83 c4 10             	add    $0x10,%esp
  if(chdir("dirfile") == 0){
    2d06:	83 ec 0c             	sub    $0xc,%esp
    2d09:	68 f8 55 00 00       	push   $0x55f8
    2d0e:	e8 16 12 00 00       	call   3f29 <chdir>
    2d13:	83 c4 10             	add    $0x10,%esp
    2d16:	85 c0                	test   %eax,%eax
    2d18:	75 17                	jne    2d31 <dirfile+0x86>
    printf(1, "chdir dirfile succeeded!\n");
    2d1a:	83 ec 08             	sub    $0x8,%esp
    2d1d:	68 17 56 00 00       	push   $0x5617
    2d22:	6a 01                	push   $0x1
    2d24:	e8 0d 13 00 00       	call   4036 <printf>
    2d29:	83 c4 10             	add    $0x10,%esp
    exit();
    2d2c:	e8 88 11 00 00       	call   3eb9 <exit>
  }
  fd = open("dirfile/xx", 0);
    2d31:	83 ec 08             	sub    $0x8,%esp
    2d34:	6a 00                	push   $0x0
    2d36:	68 31 56 00 00       	push   $0x5631
    2d3b:	e8 b9 11 00 00       	call   3ef9 <open>
    2d40:	83 c4 10             	add    $0x10,%esp
    2d43:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2d46:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2d4a:	78 17                	js     2d63 <dirfile+0xb8>
    printf(1, "create dirfile/xx succeeded!\n");
    2d4c:	83 ec 08             	sub    $0x8,%esp
    2d4f:	68 3c 56 00 00       	push   $0x563c
    2d54:	6a 01                	push   $0x1
    2d56:	e8 db 12 00 00       	call   4036 <printf>
    2d5b:	83 c4 10             	add    $0x10,%esp
    exit();
    2d5e:	e8 56 11 00 00       	call   3eb9 <exit>
  }
  fd = open("dirfile/xx", O_CREATE);
    2d63:	83 ec 08             	sub    $0x8,%esp
    2d66:	68 00 02 00 00       	push   $0x200
    2d6b:	68 31 56 00 00       	push   $0x5631
    2d70:	e8 84 11 00 00       	call   3ef9 <open>
    2d75:	83 c4 10             	add    $0x10,%esp
    2d78:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2d7b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2d7f:	78 17                	js     2d98 <dirfile+0xed>
    printf(1, "create dirfile/xx succeeded!\n");
    2d81:	83 ec 08             	sub    $0x8,%esp
    2d84:	68 3c 56 00 00       	push   $0x563c
    2d89:	6a 01                	push   $0x1
    2d8b:	e8 a6 12 00 00       	call   4036 <printf>
    2d90:	83 c4 10             	add    $0x10,%esp
    exit();
    2d93:	e8 21 11 00 00       	call   3eb9 <exit>
  }
  if(mkdir("dirfile/xx") == 0){
    2d98:	83 ec 0c             	sub    $0xc,%esp
    2d9b:	68 31 56 00 00       	push   $0x5631
    2da0:	e8 7c 11 00 00       	call   3f21 <mkdir>
    2da5:	83 c4 10             	add    $0x10,%esp
    2da8:	85 c0                	test   %eax,%eax
    2daa:	75 17                	jne    2dc3 <dirfile+0x118>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    2dac:	83 ec 08             	sub    $0x8,%esp
    2daf:	68 5a 56 00 00       	push   $0x565a
    2db4:	6a 01                	push   $0x1
    2db6:	e8 7b 12 00 00       	call   4036 <printf>
    2dbb:	83 c4 10             	add    $0x10,%esp
    exit();
    2dbe:	e8 f6 10 00 00       	call   3eb9 <exit>
  }
  if(unlink("dirfile/xx") == 0){
    2dc3:	83 ec 0c             	sub    $0xc,%esp
    2dc6:	68 31 56 00 00       	push   $0x5631
    2dcb:	e8 39 11 00 00       	call   3f09 <unlink>
    2dd0:	83 c4 10             	add    $0x10,%esp
    2dd3:	85 c0                	test   %eax,%eax
    2dd5:	75 17                	jne    2dee <dirfile+0x143>
    printf(1, "unlink dirfile/xx succeeded!\n");
    2dd7:	83 ec 08             	sub    $0x8,%esp
    2dda:	68 77 56 00 00       	push   $0x5677
    2ddf:	6a 01                	push   $0x1
    2de1:	e8 50 12 00 00       	call   4036 <printf>
    2de6:	83 c4 10             	add    $0x10,%esp
    exit();
    2de9:	e8 cb 10 00 00       	call   3eb9 <exit>
  }
  if(link("README", "dirfile/xx") == 0){
    2dee:	83 ec 08             	sub    $0x8,%esp
    2df1:	68 31 56 00 00       	push   $0x5631
    2df6:	68 95 56 00 00       	push   $0x5695
    2dfb:	e8 19 11 00 00       	call   3f19 <link>
    2e00:	83 c4 10             	add    $0x10,%esp
    2e03:	85 c0                	test   %eax,%eax
    2e05:	75 17                	jne    2e1e <dirfile+0x173>
    printf(1, "link to dirfile/xx succeeded!\n");
    2e07:	83 ec 08             	sub    $0x8,%esp
    2e0a:	68 9c 56 00 00       	push   $0x569c
    2e0f:	6a 01                	push   $0x1
    2e11:	e8 20 12 00 00       	call   4036 <printf>
    2e16:	83 c4 10             	add    $0x10,%esp
    exit();
    2e19:	e8 9b 10 00 00       	call   3eb9 <exit>
  }
  if(unlink("dirfile") != 0){
    2e1e:	83 ec 0c             	sub    $0xc,%esp
    2e21:	68 f8 55 00 00       	push   $0x55f8
    2e26:	e8 de 10 00 00       	call   3f09 <unlink>
    2e2b:	83 c4 10             	add    $0x10,%esp
    2e2e:	85 c0                	test   %eax,%eax
    2e30:	74 17                	je     2e49 <dirfile+0x19e>
    printf(1, "unlink dirfile failed!\n");
    2e32:	83 ec 08             	sub    $0x8,%esp
    2e35:	68 bb 56 00 00       	push   $0x56bb
    2e3a:	6a 01                	push   $0x1
    2e3c:	e8 f5 11 00 00       	call   4036 <printf>
    2e41:	83 c4 10             	add    $0x10,%esp
    exit();
    2e44:	e8 70 10 00 00       	call   3eb9 <exit>
  }

  fd = open(".", O_RDWR);
    2e49:	83 ec 08             	sub    $0x8,%esp
    2e4c:	6a 02                	push   $0x2
    2e4e:	68 77 4c 00 00       	push   $0x4c77
    2e53:	e8 a1 10 00 00       	call   3ef9 <open>
    2e58:	83 c4 10             	add    $0x10,%esp
    2e5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2e5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2e62:	78 17                	js     2e7b <dirfile+0x1d0>
    printf(1, "open . for writing succeeded!\n");
    2e64:	83 ec 08             	sub    $0x8,%esp
    2e67:	68 d4 56 00 00       	push   $0x56d4
    2e6c:	6a 01                	push   $0x1
    2e6e:	e8 c3 11 00 00       	call   4036 <printf>
    2e73:	83 c4 10             	add    $0x10,%esp
    exit();
    2e76:	e8 3e 10 00 00       	call   3eb9 <exit>
  }
  fd = open(".", 0);
    2e7b:	83 ec 08             	sub    $0x8,%esp
    2e7e:	6a 00                	push   $0x0
    2e80:	68 77 4c 00 00       	push   $0x4c77
    2e85:	e8 6f 10 00 00       	call   3ef9 <open>
    2e8a:	83 c4 10             	add    $0x10,%esp
    2e8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(write(fd, "x", 1) > 0){
    2e90:	83 ec 04             	sub    $0x4,%esp
    2e93:	6a 01                	push   $0x1
    2e95:	68 c3 48 00 00       	push   $0x48c3
    2e9a:	ff 75 f4             	pushl  -0xc(%ebp)
    2e9d:	e8 37 10 00 00       	call   3ed9 <write>
    2ea2:	83 c4 10             	add    $0x10,%esp
    2ea5:	85 c0                	test   %eax,%eax
    2ea7:	7e 17                	jle    2ec0 <dirfile+0x215>
    printf(1, "write . succeeded!\n");
    2ea9:	83 ec 08             	sub    $0x8,%esp
    2eac:	68 f3 56 00 00       	push   $0x56f3
    2eb1:	6a 01                	push   $0x1
    2eb3:	e8 7e 11 00 00       	call   4036 <printf>
    2eb8:	83 c4 10             	add    $0x10,%esp
    exit();
    2ebb:	e8 f9 0f 00 00       	call   3eb9 <exit>
  }
  close(fd);
    2ec0:	83 ec 0c             	sub    $0xc,%esp
    2ec3:	ff 75 f4             	pushl  -0xc(%ebp)
    2ec6:	e8 16 10 00 00       	call   3ee1 <close>
    2ecb:	83 c4 10             	add    $0x10,%esp

  printf(1, "dir vs file OK\n");
    2ece:	83 ec 08             	sub    $0x8,%esp
    2ed1:	68 07 57 00 00       	push   $0x5707
    2ed6:	6a 01                	push   $0x1
    2ed8:	e8 59 11 00 00       	call   4036 <printf>
    2edd:	83 c4 10             	add    $0x10,%esp
}
    2ee0:	c9                   	leave  
    2ee1:	c3                   	ret    

00002ee2 <iref>:

// test that iput() is called at the end of _namei()
void
iref(void)
{
    2ee2:	55                   	push   %ebp
    2ee3:	89 e5                	mov    %esp,%ebp
    2ee5:	83 ec 18             	sub    $0x18,%esp
  int i, fd;

  printf(1, "empty file name\n");
    2ee8:	83 ec 08             	sub    $0x8,%esp
    2eeb:	68 17 57 00 00       	push   $0x5717
    2ef0:	6a 01                	push   $0x1
    2ef2:	e8 3f 11 00 00       	call   4036 <printf>
    2ef7:	83 c4 10             	add    $0x10,%esp

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    2efa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2f01:	e9 e7 00 00 00       	jmp    2fed <iref+0x10b>
    if(mkdir("irefd") != 0){
    2f06:	83 ec 0c             	sub    $0xc,%esp
    2f09:	68 28 57 00 00       	push   $0x5728
    2f0e:	e8 0e 10 00 00       	call   3f21 <mkdir>
    2f13:	83 c4 10             	add    $0x10,%esp
    2f16:	85 c0                	test   %eax,%eax
    2f18:	74 17                	je     2f31 <iref+0x4f>
      printf(1, "mkdir irefd failed\n");
    2f1a:	83 ec 08             	sub    $0x8,%esp
    2f1d:	68 2e 57 00 00       	push   $0x572e
    2f22:	6a 01                	push   $0x1
    2f24:	e8 0d 11 00 00       	call   4036 <printf>
    2f29:	83 c4 10             	add    $0x10,%esp
      exit();
    2f2c:	e8 88 0f 00 00       	call   3eb9 <exit>
    }
    if(chdir("irefd") != 0){
    2f31:	83 ec 0c             	sub    $0xc,%esp
    2f34:	68 28 57 00 00       	push   $0x5728
    2f39:	e8 eb 0f 00 00       	call   3f29 <chdir>
    2f3e:	83 c4 10             	add    $0x10,%esp
    2f41:	85 c0                	test   %eax,%eax
    2f43:	74 17                	je     2f5c <iref+0x7a>
      printf(1, "chdir irefd failed\n");
    2f45:	83 ec 08             	sub    $0x8,%esp
    2f48:	68 42 57 00 00       	push   $0x5742
    2f4d:	6a 01                	push   $0x1
    2f4f:	e8 e2 10 00 00       	call   4036 <printf>
    2f54:	83 c4 10             	add    $0x10,%esp
      exit();
    2f57:	e8 5d 0f 00 00       	call   3eb9 <exit>
    }

    mkdir("");
    2f5c:	83 ec 0c             	sub    $0xc,%esp
    2f5f:	68 56 57 00 00       	push   $0x5756
    2f64:	e8 b8 0f 00 00       	call   3f21 <mkdir>
    2f69:	83 c4 10             	add    $0x10,%esp
    link("README", "");
    2f6c:	83 ec 08             	sub    $0x8,%esp
    2f6f:	68 56 57 00 00       	push   $0x5756
    2f74:	68 95 56 00 00       	push   $0x5695
    2f79:	e8 9b 0f 00 00       	call   3f19 <link>
    2f7e:	83 c4 10             	add    $0x10,%esp
    fd = open("", O_CREATE);
    2f81:	83 ec 08             	sub    $0x8,%esp
    2f84:	68 00 02 00 00       	push   $0x200
    2f89:	68 56 57 00 00       	push   $0x5756
    2f8e:	e8 66 0f 00 00       	call   3ef9 <open>
    2f93:	83 c4 10             	add    $0x10,%esp
    2f96:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0)
    2f99:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2f9d:	78 0e                	js     2fad <iref+0xcb>
      close(fd);
    2f9f:	83 ec 0c             	sub    $0xc,%esp
    2fa2:	ff 75 f0             	pushl  -0x10(%ebp)
    2fa5:	e8 37 0f 00 00       	call   3ee1 <close>
    2faa:	83 c4 10             	add    $0x10,%esp
    fd = open("xx", O_CREATE);
    2fad:	83 ec 08             	sub    $0x8,%esp
    2fb0:	68 00 02 00 00       	push   $0x200
    2fb5:	68 57 57 00 00       	push   $0x5757
    2fba:	e8 3a 0f 00 00       	call   3ef9 <open>
    2fbf:	83 c4 10             	add    $0x10,%esp
    2fc2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0)
    2fc5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2fc9:	78 0e                	js     2fd9 <iref+0xf7>
      close(fd);
    2fcb:	83 ec 0c             	sub    $0xc,%esp
    2fce:	ff 75 f0             	pushl  -0x10(%ebp)
    2fd1:	e8 0b 0f 00 00       	call   3ee1 <close>
    2fd6:	83 c4 10             	add    $0x10,%esp
    unlink("xx");
    2fd9:	83 ec 0c             	sub    $0xc,%esp
    2fdc:	68 57 57 00 00       	push   $0x5757
    2fe1:	e8 23 0f 00 00       	call   3f09 <unlink>
    2fe6:	83 c4 10             	add    $0x10,%esp
  int i, fd;

  printf(1, "empty file name\n");

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    2fe9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    2fed:	83 7d f4 32          	cmpl   $0x32,-0xc(%ebp)
    2ff1:	0f 8e 0f ff ff ff    	jle    2f06 <iref+0x24>
    if(fd >= 0)
      close(fd);
    unlink("xx");
  }

  chdir("/");
    2ff7:	83 ec 0c             	sub    $0xc,%esp
    2ffa:	68 5e 44 00 00       	push   $0x445e
    2fff:	e8 25 0f 00 00       	call   3f29 <chdir>
    3004:	83 c4 10             	add    $0x10,%esp
  printf(1, "empty file name OK\n");
    3007:	83 ec 08             	sub    $0x8,%esp
    300a:	68 5a 57 00 00       	push   $0x575a
    300f:	6a 01                	push   $0x1
    3011:	e8 20 10 00 00       	call   4036 <printf>
    3016:	83 c4 10             	add    $0x10,%esp
}
    3019:	c9                   	leave  
    301a:	c3                   	ret    

0000301b <forktest>:
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
    301b:	55                   	push   %ebp
    301c:	89 e5                	mov    %esp,%ebp
    301e:	83 ec 18             	sub    $0x18,%esp
  int n, pid;

  printf(1, "fork test\n");
    3021:	83 ec 08             	sub    $0x8,%esp
    3024:	68 6e 57 00 00       	push   $0x576e
    3029:	6a 01                	push   $0x1
    302b:	e8 06 10 00 00       	call   4036 <printf>
    3030:	83 c4 10             	add    $0x10,%esp

  for(n=0; n<1000; n++){
    3033:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    303a:	eb 1f                	jmp    305b <forktest+0x40>
    pid = fork();
    303c:	e8 70 0e 00 00       	call   3eb1 <fork>
    3041:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0)
    3044:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3048:	79 02                	jns    304c <forktest+0x31>
      break;
    304a:	eb 18                	jmp    3064 <forktest+0x49>
    if(pid == 0)
    304c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3050:	75 05                	jne    3057 <forktest+0x3c>
      exit();
    3052:	e8 62 0e 00 00       	call   3eb9 <exit>
{
  int n, pid;

  printf(1, "fork test\n");

  for(n=0; n<1000; n++){
    3057:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    305b:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
    3062:	7e d8                	jle    303c <forktest+0x21>
      break;
    if(pid == 0)
      exit();
  }
  
  if(n == 1000){
    3064:	81 7d f4 e8 03 00 00 	cmpl   $0x3e8,-0xc(%ebp)
    306b:	75 17                	jne    3084 <forktest+0x69>
    printf(1, "fork claimed to work 1000 times!\n");
    306d:	83 ec 08             	sub    $0x8,%esp
    3070:	68 7c 57 00 00       	push   $0x577c
    3075:	6a 01                	push   $0x1
    3077:	e8 ba 0f 00 00       	call   4036 <printf>
    307c:	83 c4 10             	add    $0x10,%esp
    exit();
    307f:	e8 35 0e 00 00       	call   3eb9 <exit>
  }
  
  for(; n > 0; n--){
    3084:	eb 24                	jmp    30aa <forktest+0x8f>
    if(wait() < 0){
    3086:	e8 36 0e 00 00       	call   3ec1 <wait>
    308b:	85 c0                	test   %eax,%eax
    308d:	79 17                	jns    30a6 <forktest+0x8b>
      printf(1, "wait stopped early\n");
    308f:	83 ec 08             	sub    $0x8,%esp
    3092:	68 9e 57 00 00       	push   $0x579e
    3097:	6a 01                	push   $0x1
    3099:	e8 98 0f 00 00       	call   4036 <printf>
    309e:	83 c4 10             	add    $0x10,%esp
      exit();
    30a1:	e8 13 0e 00 00       	call   3eb9 <exit>
  if(n == 1000){
    printf(1, "fork claimed to work 1000 times!\n");
    exit();
  }
  
  for(; n > 0; n--){
    30a6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    30aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    30ae:	7f d6                	jg     3086 <forktest+0x6b>
      printf(1, "wait stopped early\n");
      exit();
    }
  }
  
  if(wait() != -1){
    30b0:	e8 0c 0e 00 00       	call   3ec1 <wait>
    30b5:	83 f8 ff             	cmp    $0xffffffff,%eax
    30b8:	74 17                	je     30d1 <forktest+0xb6>
    printf(1, "wait got too many\n");
    30ba:	83 ec 08             	sub    $0x8,%esp
    30bd:	68 b2 57 00 00       	push   $0x57b2
    30c2:	6a 01                	push   $0x1
    30c4:	e8 6d 0f 00 00       	call   4036 <printf>
    30c9:	83 c4 10             	add    $0x10,%esp
    exit();
    30cc:	e8 e8 0d 00 00       	call   3eb9 <exit>
  }
  
  printf(1, "fork test OK\n");
    30d1:	83 ec 08             	sub    $0x8,%esp
    30d4:	68 c5 57 00 00       	push   $0x57c5
    30d9:	6a 01                	push   $0x1
    30db:	e8 56 0f 00 00       	call   4036 <printf>
    30e0:	83 c4 10             	add    $0x10,%esp
}
    30e3:	c9                   	leave  
    30e4:	c3                   	ret    

000030e5 <sbrktest>:

void
sbrktest(void)
{
    30e5:	55                   	push   %ebp
    30e6:	89 e5                	mov    %esp,%ebp
    30e8:	53                   	push   %ebx
    30e9:	83 ec 64             	sub    $0x64,%esp
  int fds[2], pid, pids[10], ppid;
  char *a, *b, *c, *lastaddr, *oldbrk, *p, scratch;
  uint amt;

  printf(stdout, "sbrk test\n");
    30ec:	a1 a8 62 00 00       	mov    0x62a8,%eax
    30f1:	83 ec 08             	sub    $0x8,%esp
    30f4:	68 d3 57 00 00       	push   $0x57d3
    30f9:	50                   	push   %eax
    30fa:	e8 37 0f 00 00       	call   4036 <printf>
    30ff:	83 c4 10             	add    $0x10,%esp
  oldbrk = sbrk(0);
    3102:	83 ec 0c             	sub    $0xc,%esp
    3105:	6a 00                	push   $0x0
    3107:	e8 35 0e 00 00       	call   3f41 <sbrk>
    310c:	83 c4 10             	add    $0x10,%esp
    310f:	89 45 ec             	mov    %eax,-0x14(%ebp)

  // can one sbrk() less than a page?
  a = sbrk(0);
    3112:	83 ec 0c             	sub    $0xc,%esp
    3115:	6a 00                	push   $0x0
    3117:	e8 25 0e 00 00       	call   3f41 <sbrk>
    311c:	83 c4 10             	add    $0x10,%esp
    311f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int i;
  for(i = 0; i < 5000; i++){ 
    3122:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    3129:	eb 4f                	jmp    317a <sbrktest+0x95>
    b = sbrk(1);
    312b:	83 ec 0c             	sub    $0xc,%esp
    312e:	6a 01                	push   $0x1
    3130:	e8 0c 0e 00 00       	call   3f41 <sbrk>
    3135:	83 c4 10             	add    $0x10,%esp
    3138:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(b != a){
    313b:	8b 45 e8             	mov    -0x18(%ebp),%eax
    313e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    3141:	74 24                	je     3167 <sbrktest+0x82>
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
    3143:	a1 a8 62 00 00       	mov    0x62a8,%eax
    3148:	83 ec 0c             	sub    $0xc,%esp
    314b:	ff 75 e8             	pushl  -0x18(%ebp)
    314e:	ff 75 f4             	pushl  -0xc(%ebp)
    3151:	ff 75 f0             	pushl  -0x10(%ebp)
    3154:	68 de 57 00 00       	push   $0x57de
    3159:	50                   	push   %eax
    315a:	e8 d7 0e 00 00       	call   4036 <printf>
    315f:	83 c4 20             	add    $0x20,%esp
      exit();
    3162:	e8 52 0d 00 00       	call   3eb9 <exit>
    }
    *b = 1;
    3167:	8b 45 e8             	mov    -0x18(%ebp),%eax
    316a:	c6 00 01             	movb   $0x1,(%eax)
    a = b + 1;
    316d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3170:	83 c0 01             	add    $0x1,%eax
    3173:	89 45 f4             	mov    %eax,-0xc(%ebp)
  oldbrk = sbrk(0);

  // can one sbrk() less than a page?
  a = sbrk(0);
  int i;
  for(i = 0; i < 5000; i++){ 
    3176:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    317a:	81 7d f0 87 13 00 00 	cmpl   $0x1387,-0x10(%ebp)
    3181:	7e a8                	jle    312b <sbrktest+0x46>
      exit();
    }
    *b = 1;
    a = b + 1;
  }
  pid = fork();
    3183:	e8 29 0d 00 00       	call   3eb1 <fork>
    3188:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(pid < 0){
    318b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    318f:	79 1b                	jns    31ac <sbrktest+0xc7>
    printf(stdout, "sbrk test fork failed\n");
    3191:	a1 a8 62 00 00       	mov    0x62a8,%eax
    3196:	83 ec 08             	sub    $0x8,%esp
    3199:	68 f9 57 00 00       	push   $0x57f9
    319e:	50                   	push   %eax
    319f:	e8 92 0e 00 00       	call   4036 <printf>
    31a4:	83 c4 10             	add    $0x10,%esp
    exit();
    31a7:	e8 0d 0d 00 00       	call   3eb9 <exit>
  }
  c = sbrk(1);
    31ac:	83 ec 0c             	sub    $0xc,%esp
    31af:	6a 01                	push   $0x1
    31b1:	e8 8b 0d 00 00       	call   3f41 <sbrk>
    31b6:	83 c4 10             	add    $0x10,%esp
    31b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  c = sbrk(1);
    31bc:	83 ec 0c             	sub    $0xc,%esp
    31bf:	6a 01                	push   $0x1
    31c1:	e8 7b 0d 00 00       	call   3f41 <sbrk>
    31c6:	83 c4 10             	add    $0x10,%esp
    31c9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a + 1){
    31cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    31cf:	83 c0 01             	add    $0x1,%eax
    31d2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
    31d5:	74 1b                	je     31f2 <sbrktest+0x10d>
    printf(stdout, "sbrk test failed post-fork\n");
    31d7:	a1 a8 62 00 00       	mov    0x62a8,%eax
    31dc:	83 ec 08             	sub    $0x8,%esp
    31df:	68 10 58 00 00       	push   $0x5810
    31e4:	50                   	push   %eax
    31e5:	e8 4c 0e 00 00       	call   4036 <printf>
    31ea:	83 c4 10             	add    $0x10,%esp
    exit();
    31ed:	e8 c7 0c 00 00       	call   3eb9 <exit>
  }
  if(pid == 0)
    31f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    31f6:	75 05                	jne    31fd <sbrktest+0x118>
    exit();
    31f8:	e8 bc 0c 00 00       	call   3eb9 <exit>
  wait();
    31fd:	e8 bf 0c 00 00       	call   3ec1 <wait>

  // can one grow address space to something big?
#define BIG (100*1024*1024)
  a = sbrk(0);
    3202:	83 ec 0c             	sub    $0xc,%esp
    3205:	6a 00                	push   $0x0
    3207:	e8 35 0d 00 00       	call   3f41 <sbrk>
    320c:	83 c4 10             	add    $0x10,%esp
    320f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  amt = (BIG) - (uint)a;
    3212:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3215:	ba 00 00 40 06       	mov    $0x6400000,%edx
    321a:	29 c2                	sub    %eax,%edx
    321c:	89 d0                	mov    %edx,%eax
    321e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  p = sbrk(amt);
    3221:	8b 45 dc             	mov    -0x24(%ebp),%eax
    3224:	83 ec 0c             	sub    $0xc,%esp
    3227:	50                   	push   %eax
    3228:	e8 14 0d 00 00       	call   3f41 <sbrk>
    322d:	83 c4 10             	add    $0x10,%esp
    3230:	89 45 d8             	mov    %eax,-0x28(%ebp)
  if (p != a) { 
    3233:	8b 45 d8             	mov    -0x28(%ebp),%eax
    3236:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    3239:	74 1b                	je     3256 <sbrktest+0x171>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    323b:	a1 a8 62 00 00       	mov    0x62a8,%eax
    3240:	83 ec 08             	sub    $0x8,%esp
    3243:	68 2c 58 00 00       	push   $0x582c
    3248:	50                   	push   %eax
    3249:	e8 e8 0d 00 00       	call   4036 <printf>
    324e:	83 c4 10             	add    $0x10,%esp
    exit();
    3251:	e8 63 0c 00 00       	call   3eb9 <exit>
  }
  lastaddr = (char*) (BIG-1);
    3256:	c7 45 d4 ff ff 3f 06 	movl   $0x63fffff,-0x2c(%ebp)
  *lastaddr = 99;
    325d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    3260:	c6 00 63             	movb   $0x63,(%eax)

  // can one de-allocate?
  a = sbrk(0);
    3263:	83 ec 0c             	sub    $0xc,%esp
    3266:	6a 00                	push   $0x0
    3268:	e8 d4 0c 00 00       	call   3f41 <sbrk>
    326d:	83 c4 10             	add    $0x10,%esp
    3270:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(-4096);
    3273:	83 ec 0c             	sub    $0xc,%esp
    3276:	68 00 f0 ff ff       	push   $0xfffff000
    327b:	e8 c1 0c 00 00       	call   3f41 <sbrk>
    3280:	83 c4 10             	add    $0x10,%esp
    3283:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c == (char*)0xffffffff){
    3286:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
    328a:	75 1b                	jne    32a7 <sbrktest+0x1c2>
    printf(stdout, "sbrk could not deallocate\n");
    328c:	a1 a8 62 00 00       	mov    0x62a8,%eax
    3291:	83 ec 08             	sub    $0x8,%esp
    3294:	68 6a 58 00 00       	push   $0x586a
    3299:	50                   	push   %eax
    329a:	e8 97 0d 00 00       	call   4036 <printf>
    329f:	83 c4 10             	add    $0x10,%esp
    exit();
    32a2:	e8 12 0c 00 00       	call   3eb9 <exit>
  }
  c = sbrk(0);
    32a7:	83 ec 0c             	sub    $0xc,%esp
    32aa:	6a 00                	push   $0x0
    32ac:	e8 90 0c 00 00       	call   3f41 <sbrk>
    32b1:	83 c4 10             	add    $0x10,%esp
    32b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a - 4096){
    32b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    32ba:	2d 00 10 00 00       	sub    $0x1000,%eax
    32bf:	3b 45 e0             	cmp    -0x20(%ebp),%eax
    32c2:	74 1e                	je     32e2 <sbrktest+0x1fd>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    32c4:	a1 a8 62 00 00       	mov    0x62a8,%eax
    32c9:	ff 75 e0             	pushl  -0x20(%ebp)
    32cc:	ff 75 f4             	pushl  -0xc(%ebp)
    32cf:	68 88 58 00 00       	push   $0x5888
    32d4:	50                   	push   %eax
    32d5:	e8 5c 0d 00 00       	call   4036 <printf>
    32da:	83 c4 10             	add    $0x10,%esp
    exit();
    32dd:	e8 d7 0b 00 00       	call   3eb9 <exit>
  }

  // can one re-allocate that page?
  a = sbrk(0);
    32e2:	83 ec 0c             	sub    $0xc,%esp
    32e5:	6a 00                	push   $0x0
    32e7:	e8 55 0c 00 00       	call   3f41 <sbrk>
    32ec:	83 c4 10             	add    $0x10,%esp
    32ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(4096);
    32f2:	83 ec 0c             	sub    $0xc,%esp
    32f5:	68 00 10 00 00       	push   $0x1000
    32fa:	e8 42 0c 00 00       	call   3f41 <sbrk>
    32ff:	83 c4 10             	add    $0x10,%esp
    3302:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a || sbrk(0) != a + 4096){
    3305:	8b 45 e0             	mov    -0x20(%ebp),%eax
    3308:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    330b:	75 1b                	jne    3328 <sbrktest+0x243>
    330d:	83 ec 0c             	sub    $0xc,%esp
    3310:	6a 00                	push   $0x0
    3312:	e8 2a 0c 00 00       	call   3f41 <sbrk>
    3317:	83 c4 10             	add    $0x10,%esp
    331a:	89 c2                	mov    %eax,%edx
    331c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    331f:	05 00 10 00 00       	add    $0x1000,%eax
    3324:	39 c2                	cmp    %eax,%edx
    3326:	74 1e                	je     3346 <sbrktest+0x261>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    3328:	a1 a8 62 00 00       	mov    0x62a8,%eax
    332d:	ff 75 e0             	pushl  -0x20(%ebp)
    3330:	ff 75 f4             	pushl  -0xc(%ebp)
    3333:	68 c0 58 00 00       	push   $0x58c0
    3338:	50                   	push   %eax
    3339:	e8 f8 0c 00 00       	call   4036 <printf>
    333e:	83 c4 10             	add    $0x10,%esp
    exit();
    3341:	e8 73 0b 00 00       	call   3eb9 <exit>
  }
  if(*lastaddr == 99){
    3346:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    3349:	0f b6 00             	movzbl (%eax),%eax
    334c:	3c 63                	cmp    $0x63,%al
    334e:	75 1b                	jne    336b <sbrktest+0x286>
    // should be zero
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    3350:	a1 a8 62 00 00       	mov    0x62a8,%eax
    3355:	83 ec 08             	sub    $0x8,%esp
    3358:	68 e8 58 00 00       	push   $0x58e8
    335d:	50                   	push   %eax
    335e:	e8 d3 0c 00 00       	call   4036 <printf>
    3363:	83 c4 10             	add    $0x10,%esp
    exit();
    3366:	e8 4e 0b 00 00       	call   3eb9 <exit>
  }

  a = sbrk(0);
    336b:	83 ec 0c             	sub    $0xc,%esp
    336e:	6a 00                	push   $0x0
    3370:	e8 cc 0b 00 00       	call   3f41 <sbrk>
    3375:	83 c4 10             	add    $0x10,%esp
    3378:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(-(sbrk(0) - oldbrk));
    337b:	8b 5d ec             	mov    -0x14(%ebp),%ebx
    337e:	83 ec 0c             	sub    $0xc,%esp
    3381:	6a 00                	push   $0x0
    3383:	e8 b9 0b 00 00       	call   3f41 <sbrk>
    3388:	83 c4 10             	add    $0x10,%esp
    338b:	29 c3                	sub    %eax,%ebx
    338d:	89 d8                	mov    %ebx,%eax
    338f:	83 ec 0c             	sub    $0xc,%esp
    3392:	50                   	push   %eax
    3393:	e8 a9 0b 00 00       	call   3f41 <sbrk>
    3398:	83 c4 10             	add    $0x10,%esp
    339b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a){
    339e:	8b 45 e0             	mov    -0x20(%ebp),%eax
    33a1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    33a4:	74 1e                	je     33c4 <sbrktest+0x2df>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    33a6:	a1 a8 62 00 00       	mov    0x62a8,%eax
    33ab:	ff 75 e0             	pushl  -0x20(%ebp)
    33ae:	ff 75 f4             	pushl  -0xc(%ebp)
    33b1:	68 18 59 00 00       	push   $0x5918
    33b6:	50                   	push   %eax
    33b7:	e8 7a 0c 00 00       	call   4036 <printf>
    33bc:	83 c4 10             	add    $0x10,%esp
    exit();
    33bf:	e8 f5 0a 00 00       	call   3eb9 <exit>
  }
  
  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    33c4:	c7 45 f4 00 00 00 80 	movl   $0x80000000,-0xc(%ebp)
    33cb:	eb 76                	jmp    3443 <sbrktest+0x35e>
    ppid = getpid();
    33cd:	e8 67 0b 00 00       	call   3f39 <getpid>
    33d2:	89 45 d0             	mov    %eax,-0x30(%ebp)
    pid = fork();
    33d5:	e8 d7 0a 00 00       	call   3eb1 <fork>
    33da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(pid < 0){
    33dd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    33e1:	79 1b                	jns    33fe <sbrktest+0x319>
      printf(stdout, "fork failed\n");
    33e3:	a1 a8 62 00 00       	mov    0x62a8,%eax
    33e8:	83 ec 08             	sub    $0x8,%esp
    33eb:	68 8d 44 00 00       	push   $0x448d
    33f0:	50                   	push   %eax
    33f1:	e8 40 0c 00 00       	call   4036 <printf>
    33f6:	83 c4 10             	add    $0x10,%esp
      exit();
    33f9:	e8 bb 0a 00 00       	call   3eb9 <exit>
    }
    if(pid == 0){
    33fe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    3402:	75 33                	jne    3437 <sbrktest+0x352>
      printf(stdout, "oops could read %x = %x\n", a, *a);
    3404:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3407:	0f b6 00             	movzbl (%eax),%eax
    340a:	0f be d0             	movsbl %al,%edx
    340d:	a1 a8 62 00 00       	mov    0x62a8,%eax
    3412:	52                   	push   %edx
    3413:	ff 75 f4             	pushl  -0xc(%ebp)
    3416:	68 39 59 00 00       	push   $0x5939
    341b:	50                   	push   %eax
    341c:	e8 15 0c 00 00       	call   4036 <printf>
    3421:	83 c4 10             	add    $0x10,%esp
      kill(ppid);
    3424:	83 ec 0c             	sub    $0xc,%esp
    3427:	ff 75 d0             	pushl  -0x30(%ebp)
    342a:	e8 ba 0a 00 00       	call   3ee9 <kill>
    342f:	83 c4 10             	add    $0x10,%esp
      exit();
    3432:	e8 82 0a 00 00       	call   3eb9 <exit>
    }
    wait();
    3437:	e8 85 0a 00 00       	call   3ec1 <wait>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    exit();
  }
  
  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    343c:	81 45 f4 50 c3 00 00 	addl   $0xc350,-0xc(%ebp)
    3443:	81 7d f4 7f 84 1e 80 	cmpl   $0x801e847f,-0xc(%ebp)
    344a:	76 81                	jbe    33cd <sbrktest+0x2e8>
    wait();
  }

  // if we run the system out of memory, does it clean up the last
  // failed allocation?
  if(pipe(fds) != 0){
    344c:	83 ec 0c             	sub    $0xc,%esp
    344f:	8d 45 c8             	lea    -0x38(%ebp),%eax
    3452:	50                   	push   %eax
    3453:	e8 71 0a 00 00       	call   3ec9 <pipe>
    3458:	83 c4 10             	add    $0x10,%esp
    345b:	85 c0                	test   %eax,%eax
    345d:	74 17                	je     3476 <sbrktest+0x391>
    printf(1, "pipe() failed\n");
    345f:	83 ec 08             	sub    $0x8,%esp
    3462:	68 5e 48 00 00       	push   $0x485e
    3467:	6a 01                	push   $0x1
    3469:	e8 c8 0b 00 00       	call   4036 <printf>
    346e:	83 c4 10             	add    $0x10,%esp
    exit();
    3471:	e8 43 0a 00 00       	call   3eb9 <exit>
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3476:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    347d:	e9 88 00 00 00       	jmp    350a <sbrktest+0x425>
    if((pids[i] = fork()) == 0){
    3482:	e8 2a 0a 00 00       	call   3eb1 <fork>
    3487:	89 c2                	mov    %eax,%edx
    3489:	8b 45 f0             	mov    -0x10(%ebp),%eax
    348c:	89 54 85 a0          	mov    %edx,-0x60(%ebp,%eax,4)
    3490:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3493:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    3497:	85 c0                	test   %eax,%eax
    3499:	75 4a                	jne    34e5 <sbrktest+0x400>
      // allocate a lot of memory
      sbrk(BIG - (uint)sbrk(0));
    349b:	83 ec 0c             	sub    $0xc,%esp
    349e:	6a 00                	push   $0x0
    34a0:	e8 9c 0a 00 00       	call   3f41 <sbrk>
    34a5:	83 c4 10             	add    $0x10,%esp
    34a8:	ba 00 00 40 06       	mov    $0x6400000,%edx
    34ad:	29 c2                	sub    %eax,%edx
    34af:	89 d0                	mov    %edx,%eax
    34b1:	83 ec 0c             	sub    $0xc,%esp
    34b4:	50                   	push   %eax
    34b5:	e8 87 0a 00 00       	call   3f41 <sbrk>
    34ba:	83 c4 10             	add    $0x10,%esp
      write(fds[1], "x", 1);
    34bd:	8b 45 cc             	mov    -0x34(%ebp),%eax
    34c0:	83 ec 04             	sub    $0x4,%esp
    34c3:	6a 01                	push   $0x1
    34c5:	68 c3 48 00 00       	push   $0x48c3
    34ca:	50                   	push   %eax
    34cb:	e8 09 0a 00 00       	call   3ed9 <write>
    34d0:	83 c4 10             	add    $0x10,%esp
      // sit around until killed
      for(;;) sleep(1000);
    34d3:	83 ec 0c             	sub    $0xc,%esp
    34d6:	68 e8 03 00 00       	push   $0x3e8
    34db:	e8 69 0a 00 00       	call   3f49 <sleep>
    34e0:	83 c4 10             	add    $0x10,%esp
    34e3:	eb ee                	jmp    34d3 <sbrktest+0x3ee>
    }
    if(pids[i] != -1)
    34e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    34e8:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    34ec:	83 f8 ff             	cmp    $0xffffffff,%eax
    34ef:	74 15                	je     3506 <sbrktest+0x421>
      read(fds[0], &scratch, 1);
    34f1:	8b 45 c8             	mov    -0x38(%ebp),%eax
    34f4:	83 ec 04             	sub    $0x4,%esp
    34f7:	6a 01                	push   $0x1
    34f9:	8d 55 9f             	lea    -0x61(%ebp),%edx
    34fc:	52                   	push   %edx
    34fd:	50                   	push   %eax
    34fe:	e8 ce 09 00 00       	call   3ed1 <read>
    3503:	83 c4 10             	add    $0x10,%esp
  // failed allocation?
  if(pipe(fds) != 0){
    printf(1, "pipe() failed\n");
    exit();
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3506:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    350a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    350d:	83 f8 09             	cmp    $0x9,%eax
    3510:	0f 86 6c ff ff ff    	jbe    3482 <sbrktest+0x39d>
    if(pids[i] != -1)
      read(fds[0], &scratch, 1);
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
    3516:	83 ec 0c             	sub    $0xc,%esp
    3519:	68 00 10 00 00       	push   $0x1000
    351e:	e8 1e 0a 00 00       	call   3f41 <sbrk>
    3523:	83 c4 10             	add    $0x10,%esp
    3526:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3529:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    3530:	eb 2a                	jmp    355c <sbrktest+0x477>
    if(pids[i] == -1)
    3532:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3535:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    3539:	83 f8 ff             	cmp    $0xffffffff,%eax
    353c:	75 02                	jne    3540 <sbrktest+0x45b>
      continue;
    353e:	eb 18                	jmp    3558 <sbrktest+0x473>
    kill(pids[i]);
    3540:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3543:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    3547:	83 ec 0c             	sub    $0xc,%esp
    354a:	50                   	push   %eax
    354b:	e8 99 09 00 00       	call   3ee9 <kill>
    3550:	83 c4 10             	add    $0x10,%esp
    wait();
    3553:	e8 69 09 00 00       	call   3ec1 <wait>
      read(fds[0], &scratch, 1);
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3558:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    355c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    355f:	83 f8 09             	cmp    $0x9,%eax
    3562:	76 ce                	jbe    3532 <sbrktest+0x44d>
    if(pids[i] == -1)
      continue;
    kill(pids[i]);
    wait();
  }
  if(c == (char*)0xffffffff){
    3564:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
    3568:	75 1b                	jne    3585 <sbrktest+0x4a0>
    printf(stdout, "failed sbrk leaked memory\n");
    356a:	a1 a8 62 00 00       	mov    0x62a8,%eax
    356f:	83 ec 08             	sub    $0x8,%esp
    3572:	68 52 59 00 00       	push   $0x5952
    3577:	50                   	push   %eax
    3578:	e8 b9 0a 00 00       	call   4036 <printf>
    357d:	83 c4 10             	add    $0x10,%esp
    exit();
    3580:	e8 34 09 00 00       	call   3eb9 <exit>
  }

  if(sbrk(0) > oldbrk)
    3585:	83 ec 0c             	sub    $0xc,%esp
    3588:	6a 00                	push   $0x0
    358a:	e8 b2 09 00 00       	call   3f41 <sbrk>
    358f:	83 c4 10             	add    $0x10,%esp
    3592:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    3595:	76 20                	jbe    35b7 <sbrktest+0x4d2>
    sbrk(-(sbrk(0) - oldbrk));
    3597:	8b 5d ec             	mov    -0x14(%ebp),%ebx
    359a:	83 ec 0c             	sub    $0xc,%esp
    359d:	6a 00                	push   $0x0
    359f:	e8 9d 09 00 00       	call   3f41 <sbrk>
    35a4:	83 c4 10             	add    $0x10,%esp
    35a7:	29 c3                	sub    %eax,%ebx
    35a9:	89 d8                	mov    %ebx,%eax
    35ab:	83 ec 0c             	sub    $0xc,%esp
    35ae:	50                   	push   %eax
    35af:	e8 8d 09 00 00       	call   3f41 <sbrk>
    35b4:	83 c4 10             	add    $0x10,%esp

  printf(stdout, "sbrk test OK\n");
    35b7:	a1 a8 62 00 00       	mov    0x62a8,%eax
    35bc:	83 ec 08             	sub    $0x8,%esp
    35bf:	68 6d 59 00 00       	push   $0x596d
    35c4:	50                   	push   %eax
    35c5:	e8 6c 0a 00 00       	call   4036 <printf>
    35ca:	83 c4 10             	add    $0x10,%esp
}
    35cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    35d0:	c9                   	leave  
    35d1:	c3                   	ret    

000035d2 <validateint>:

void
validateint(int *p)
{
    35d2:	55                   	push   %ebp
    35d3:	89 e5                	mov    %esp,%ebp
    35d5:	53                   	push   %ebx
    35d6:	83 ec 10             	sub    $0x10,%esp
  int res;
  asm("mov %%esp, %%ebx\n\t"
    35d9:	b8 0d 00 00 00       	mov    $0xd,%eax
    35de:	8b 55 08             	mov    0x8(%ebp),%edx
    35e1:	89 d1                	mov    %edx,%ecx
    35e3:	89 e3                	mov    %esp,%ebx
    35e5:	89 cc                	mov    %ecx,%esp
    35e7:	cd 40                	int    $0x40
    35e9:	89 dc                	mov    %ebx,%esp
    35eb:	89 45 f8             	mov    %eax,-0x8(%ebp)
      "int %2\n\t"
      "mov %%ebx, %%esp" :
      "=a" (res) :
      "a" (SYS_sleep), "n" (T_SYSCALL), "c" (p) :
      "ebx");
}
    35ee:	83 c4 10             	add    $0x10,%esp
    35f1:	5b                   	pop    %ebx
    35f2:	5d                   	pop    %ebp
    35f3:	c3                   	ret    

000035f4 <validatetest>:

void
validatetest(void)
{
    35f4:	55                   	push   %ebp
    35f5:	89 e5                	mov    %esp,%ebp
    35f7:	83 ec 18             	sub    $0x18,%esp
  int hi, pid;
  uint p;

  printf(stdout, "validate test\n");
    35fa:	a1 a8 62 00 00       	mov    0x62a8,%eax
    35ff:	83 ec 08             	sub    $0x8,%esp
    3602:	68 7b 59 00 00       	push   $0x597b
    3607:	50                   	push   %eax
    3608:	e8 29 0a 00 00       	call   4036 <printf>
    360d:	83 c4 10             	add    $0x10,%esp
  hi = 1100*1024;
    3610:	c7 45 f0 00 30 11 00 	movl   $0x113000,-0x10(%ebp)

  for(p = 0; p <= (uint)hi; p += 4096){
    3617:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    361e:	e9 8a 00 00 00       	jmp    36ad <validatetest+0xb9>
    if((pid = fork()) == 0){
    3623:	e8 89 08 00 00       	call   3eb1 <fork>
    3628:	89 45 ec             	mov    %eax,-0x14(%ebp)
    362b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    362f:	75 14                	jne    3645 <validatetest+0x51>
      // try to crash the kernel by passing in a badly placed integer
      validateint((int*)p);
    3631:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3634:	83 ec 0c             	sub    $0xc,%esp
    3637:	50                   	push   %eax
    3638:	e8 95 ff ff ff       	call   35d2 <validateint>
    363d:	83 c4 10             	add    $0x10,%esp
      exit();
    3640:	e8 74 08 00 00       	call   3eb9 <exit>
    }
    sleep(0);
    3645:	83 ec 0c             	sub    $0xc,%esp
    3648:	6a 00                	push   $0x0
    364a:	e8 fa 08 00 00       	call   3f49 <sleep>
    364f:	83 c4 10             	add    $0x10,%esp
    sleep(0);
    3652:	83 ec 0c             	sub    $0xc,%esp
    3655:	6a 00                	push   $0x0
    3657:	e8 ed 08 00 00       	call   3f49 <sleep>
    365c:	83 c4 10             	add    $0x10,%esp
    kill(pid);
    365f:	83 ec 0c             	sub    $0xc,%esp
    3662:	ff 75 ec             	pushl  -0x14(%ebp)
    3665:	e8 7f 08 00 00       	call   3ee9 <kill>
    366a:	83 c4 10             	add    $0x10,%esp
    wait();
    366d:	e8 4f 08 00 00       	call   3ec1 <wait>

    // try to crash the kernel by passing in a bad string pointer
    if(link("nosuchfile", (char*)p) != -1){
    3672:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3675:	83 ec 08             	sub    $0x8,%esp
    3678:	50                   	push   %eax
    3679:	68 8a 59 00 00       	push   $0x598a
    367e:	e8 96 08 00 00       	call   3f19 <link>
    3683:	83 c4 10             	add    $0x10,%esp
    3686:	83 f8 ff             	cmp    $0xffffffff,%eax
    3689:	74 1b                	je     36a6 <validatetest+0xb2>
      printf(stdout, "link should not succeed\n");
    368b:	a1 a8 62 00 00       	mov    0x62a8,%eax
    3690:	83 ec 08             	sub    $0x8,%esp
    3693:	68 95 59 00 00       	push   $0x5995
    3698:	50                   	push   %eax
    3699:	e8 98 09 00 00       	call   4036 <printf>
    369e:	83 c4 10             	add    $0x10,%esp
      exit();
    36a1:	e8 13 08 00 00       	call   3eb9 <exit>
  uint p;

  printf(stdout, "validate test\n");
  hi = 1100*1024;

  for(p = 0; p <= (uint)hi; p += 4096){
    36a6:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    36ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
    36b0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    36b3:	0f 83 6a ff ff ff    	jae    3623 <validatetest+0x2f>
      printf(stdout, "link should not succeed\n");
      exit();
    }
  }

  printf(stdout, "validate ok\n");
    36b9:	a1 a8 62 00 00       	mov    0x62a8,%eax
    36be:	83 ec 08             	sub    $0x8,%esp
    36c1:	68 ae 59 00 00       	push   $0x59ae
    36c6:	50                   	push   %eax
    36c7:	e8 6a 09 00 00       	call   4036 <printf>
    36cc:	83 c4 10             	add    $0x10,%esp
}
    36cf:	c9                   	leave  
    36d0:	c3                   	ret    

000036d1 <bsstest>:

// does unintialized data start out zero?
char uninit[10000];
void
bsstest(void)
{
    36d1:	55                   	push   %ebp
    36d2:	89 e5                	mov    %esp,%ebp
    36d4:	83 ec 18             	sub    $0x18,%esp
  int i;

  printf(stdout, "bss test\n");
    36d7:	a1 a8 62 00 00       	mov    0x62a8,%eax
    36dc:	83 ec 08             	sub    $0x8,%esp
    36df:	68 bb 59 00 00       	push   $0x59bb
    36e4:	50                   	push   %eax
    36e5:	e8 4c 09 00 00       	call   4036 <printf>
    36ea:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sizeof(uninit); i++){
    36ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    36f4:	eb 2e                	jmp    3724 <bsstest+0x53>
    if(uninit[i] != '\0'){
    36f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    36f9:	05 c0 63 00 00       	add    $0x63c0,%eax
    36fe:	0f b6 00             	movzbl (%eax),%eax
    3701:	84 c0                	test   %al,%al
    3703:	74 1b                	je     3720 <bsstest+0x4f>
      printf(stdout, "bss test failed\n");
    3705:	a1 a8 62 00 00       	mov    0x62a8,%eax
    370a:	83 ec 08             	sub    $0x8,%esp
    370d:	68 c5 59 00 00       	push   $0x59c5
    3712:	50                   	push   %eax
    3713:	e8 1e 09 00 00       	call   4036 <printf>
    3718:	83 c4 10             	add    $0x10,%esp
      exit();
    371b:	e8 99 07 00 00       	call   3eb9 <exit>
bsstest(void)
{
  int i;

  printf(stdout, "bss test\n");
  for(i = 0; i < sizeof(uninit); i++){
    3720:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    3724:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3727:	3d 0f 27 00 00       	cmp    $0x270f,%eax
    372c:	76 c8                	jbe    36f6 <bsstest+0x25>
    if(uninit[i] != '\0'){
      printf(stdout, "bss test failed\n");
      exit();
    }
  }
  printf(stdout, "bss test ok\n");
    372e:	a1 a8 62 00 00       	mov    0x62a8,%eax
    3733:	83 ec 08             	sub    $0x8,%esp
    3736:	68 d6 59 00 00       	push   $0x59d6
    373b:	50                   	push   %eax
    373c:	e8 f5 08 00 00       	call   4036 <printf>
    3741:	83 c4 10             	add    $0x10,%esp
}
    3744:	c9                   	leave  
    3745:	c3                   	ret    

00003746 <bigargtest>:
// does exec return an error if the arguments
// are larger than a page? or does it write
// below the stack and wreck the instructions/data?
void
bigargtest(void)
{
    3746:	55                   	push   %ebp
    3747:	89 e5                	mov    %esp,%ebp
    3749:	83 ec 18             	sub    $0x18,%esp
  int pid, fd;

  unlink("bigarg-ok");
    374c:	83 ec 0c             	sub    $0xc,%esp
    374f:	68 e3 59 00 00       	push   $0x59e3
    3754:	e8 b0 07 00 00       	call   3f09 <unlink>
    3759:	83 c4 10             	add    $0x10,%esp
  pid = fork();
    375c:	e8 50 07 00 00       	call   3eb1 <fork>
    3761:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid == 0){
    3764:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3768:	0f 85 97 00 00 00    	jne    3805 <bigargtest+0xbf>
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
    376e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3775:	eb 12                	jmp    3789 <bigargtest+0x43>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    3777:	8b 45 f4             	mov    -0xc(%ebp),%eax
    377a:	c7 04 85 00 63 00 00 	movl   $0x59f0,0x6300(,%eax,4)
    3781:	f0 59 00 00 
  unlink("bigarg-ok");
  pid = fork();
  if(pid == 0){
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
    3785:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    3789:	83 7d f4 1e          	cmpl   $0x1e,-0xc(%ebp)
    378d:	7e e8                	jle    3777 <bigargtest+0x31>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    args[MAXARG-1] = 0;
    378f:	c7 05 7c 63 00 00 00 	movl   $0x0,0x637c
    3796:	00 00 00 
    printf(stdout, "bigarg test\n");
    3799:	a1 a8 62 00 00       	mov    0x62a8,%eax
    379e:	83 ec 08             	sub    $0x8,%esp
    37a1:	68 cd 5a 00 00       	push   $0x5acd
    37a6:	50                   	push   %eax
    37a7:	e8 8a 08 00 00       	call   4036 <printf>
    37ac:	83 c4 10             	add    $0x10,%esp
    exec("echo", args);
    37af:	83 ec 08             	sub    $0x8,%esp
    37b2:	68 00 63 00 00       	push   $0x6300
    37b7:	68 ec 43 00 00       	push   $0x43ec
    37bc:	e8 30 07 00 00       	call   3ef1 <exec>
    37c1:	83 c4 10             	add    $0x10,%esp
    printf(stdout, "bigarg test ok\n");
    37c4:	a1 a8 62 00 00       	mov    0x62a8,%eax
    37c9:	83 ec 08             	sub    $0x8,%esp
    37cc:	68 da 5a 00 00       	push   $0x5ada
    37d1:	50                   	push   %eax
    37d2:	e8 5f 08 00 00       	call   4036 <printf>
    37d7:	83 c4 10             	add    $0x10,%esp
    fd = open("bigarg-ok", O_CREATE);
    37da:	83 ec 08             	sub    $0x8,%esp
    37dd:	68 00 02 00 00       	push   $0x200
    37e2:	68 e3 59 00 00       	push   $0x59e3
    37e7:	e8 0d 07 00 00       	call   3ef9 <open>
    37ec:	83 c4 10             	add    $0x10,%esp
    37ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
    close(fd);
    37f2:	83 ec 0c             	sub    $0xc,%esp
    37f5:	ff 75 ec             	pushl  -0x14(%ebp)
    37f8:	e8 e4 06 00 00       	call   3ee1 <close>
    37fd:	83 c4 10             	add    $0x10,%esp
    exit();
    3800:	e8 b4 06 00 00       	call   3eb9 <exit>
  } else if(pid < 0){
    3805:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3809:	79 1b                	jns    3826 <bigargtest+0xe0>
    printf(stdout, "bigargtest: fork failed\n");
    380b:	a1 a8 62 00 00       	mov    0x62a8,%eax
    3810:	83 ec 08             	sub    $0x8,%esp
    3813:	68 ea 5a 00 00       	push   $0x5aea
    3818:	50                   	push   %eax
    3819:	e8 18 08 00 00       	call   4036 <printf>
    381e:	83 c4 10             	add    $0x10,%esp
    exit();
    3821:	e8 93 06 00 00       	call   3eb9 <exit>
  }
  wait();
    3826:	e8 96 06 00 00       	call   3ec1 <wait>
  fd = open("bigarg-ok", 0);
    382b:	83 ec 08             	sub    $0x8,%esp
    382e:	6a 00                	push   $0x0
    3830:	68 e3 59 00 00       	push   $0x59e3
    3835:	e8 bf 06 00 00       	call   3ef9 <open>
    383a:	83 c4 10             	add    $0x10,%esp
    383d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    3840:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3844:	79 1b                	jns    3861 <bigargtest+0x11b>
    printf(stdout, "bigarg test failed!\n");
    3846:	a1 a8 62 00 00       	mov    0x62a8,%eax
    384b:	83 ec 08             	sub    $0x8,%esp
    384e:	68 03 5b 00 00       	push   $0x5b03
    3853:	50                   	push   %eax
    3854:	e8 dd 07 00 00       	call   4036 <printf>
    3859:	83 c4 10             	add    $0x10,%esp
    exit();
    385c:	e8 58 06 00 00       	call   3eb9 <exit>
  }
  close(fd);
    3861:	83 ec 0c             	sub    $0xc,%esp
    3864:	ff 75 ec             	pushl  -0x14(%ebp)
    3867:	e8 75 06 00 00       	call   3ee1 <close>
    386c:	83 c4 10             	add    $0x10,%esp
  unlink("bigarg-ok");
    386f:	83 ec 0c             	sub    $0xc,%esp
    3872:	68 e3 59 00 00       	push   $0x59e3
    3877:	e8 8d 06 00 00       	call   3f09 <unlink>
    387c:	83 c4 10             	add    $0x10,%esp
}
    387f:	c9                   	leave  
    3880:	c3                   	ret    

00003881 <fsfull>:

// what happens when the file system runs out of blocks?
// answer: balloc panics, so this test is not useful.
void
fsfull()
{
    3881:	55                   	push   %ebp
    3882:	89 e5                	mov    %esp,%ebp
    3884:	53                   	push   %ebx
    3885:	83 ec 64             	sub    $0x64,%esp
  int nfiles;
  int fsblocks = 0;
    3888:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  printf(1, "fsfull test\n");
    388f:	83 ec 08             	sub    $0x8,%esp
    3892:	68 18 5b 00 00       	push   $0x5b18
    3897:	6a 01                	push   $0x1
    3899:	e8 98 07 00 00       	call   4036 <printf>
    389e:	83 c4 10             	add    $0x10,%esp

  for(nfiles = 0; ; nfiles++){
    38a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    char name[64];
    name[0] = 'f';
    38a8:	c6 45 a4 66          	movb   $0x66,-0x5c(%ebp)
    name[1] = '0' + nfiles / 1000;
    38ac:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    38af:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    38b4:	89 c8                	mov    %ecx,%eax
    38b6:	f7 ea                	imul   %edx
    38b8:	c1 fa 06             	sar    $0x6,%edx
    38bb:	89 c8                	mov    %ecx,%eax
    38bd:	c1 f8 1f             	sar    $0x1f,%eax
    38c0:	29 c2                	sub    %eax,%edx
    38c2:	89 d0                	mov    %edx,%eax
    38c4:	83 c0 30             	add    $0x30,%eax
    38c7:	88 45 a5             	mov    %al,-0x5b(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    38ca:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    38cd:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    38d2:	89 d8                	mov    %ebx,%eax
    38d4:	f7 ea                	imul   %edx
    38d6:	c1 fa 06             	sar    $0x6,%edx
    38d9:	89 d8                	mov    %ebx,%eax
    38db:	c1 f8 1f             	sar    $0x1f,%eax
    38de:	89 d1                	mov    %edx,%ecx
    38e0:	29 c1                	sub    %eax,%ecx
    38e2:	69 c1 e8 03 00 00    	imul   $0x3e8,%ecx,%eax
    38e8:	29 c3                	sub    %eax,%ebx
    38ea:	89 d9                	mov    %ebx,%ecx
    38ec:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    38f1:	89 c8                	mov    %ecx,%eax
    38f3:	f7 ea                	imul   %edx
    38f5:	c1 fa 05             	sar    $0x5,%edx
    38f8:	89 c8                	mov    %ecx,%eax
    38fa:	c1 f8 1f             	sar    $0x1f,%eax
    38fd:	29 c2                	sub    %eax,%edx
    38ff:	89 d0                	mov    %edx,%eax
    3901:	83 c0 30             	add    $0x30,%eax
    3904:	88 45 a6             	mov    %al,-0x5a(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    3907:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    390a:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    390f:	89 d8                	mov    %ebx,%eax
    3911:	f7 ea                	imul   %edx
    3913:	c1 fa 05             	sar    $0x5,%edx
    3916:	89 d8                	mov    %ebx,%eax
    3918:	c1 f8 1f             	sar    $0x1f,%eax
    391b:	89 d1                	mov    %edx,%ecx
    391d:	29 c1                	sub    %eax,%ecx
    391f:	6b c1 64             	imul   $0x64,%ecx,%eax
    3922:	29 c3                	sub    %eax,%ebx
    3924:	89 d9                	mov    %ebx,%ecx
    3926:	ba 67 66 66 66       	mov    $0x66666667,%edx
    392b:	89 c8                	mov    %ecx,%eax
    392d:	f7 ea                	imul   %edx
    392f:	c1 fa 02             	sar    $0x2,%edx
    3932:	89 c8                	mov    %ecx,%eax
    3934:	c1 f8 1f             	sar    $0x1f,%eax
    3937:	29 c2                	sub    %eax,%edx
    3939:	89 d0                	mov    %edx,%eax
    393b:	83 c0 30             	add    $0x30,%eax
    393e:	88 45 a7             	mov    %al,-0x59(%ebp)
    name[4] = '0' + (nfiles % 10);
    3941:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    3944:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3949:	89 c8                	mov    %ecx,%eax
    394b:	f7 ea                	imul   %edx
    394d:	c1 fa 02             	sar    $0x2,%edx
    3950:	89 c8                	mov    %ecx,%eax
    3952:	c1 f8 1f             	sar    $0x1f,%eax
    3955:	29 c2                	sub    %eax,%edx
    3957:	89 d0                	mov    %edx,%eax
    3959:	c1 e0 02             	shl    $0x2,%eax
    395c:	01 d0                	add    %edx,%eax
    395e:	01 c0                	add    %eax,%eax
    3960:	29 c1                	sub    %eax,%ecx
    3962:	89 ca                	mov    %ecx,%edx
    3964:	89 d0                	mov    %edx,%eax
    3966:	83 c0 30             	add    $0x30,%eax
    3969:	88 45 a8             	mov    %al,-0x58(%ebp)
    name[5] = '\0';
    396c:	c6 45 a9 00          	movb   $0x0,-0x57(%ebp)
    printf(1, "writing %s\n", name);
    3970:	83 ec 04             	sub    $0x4,%esp
    3973:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    3976:	50                   	push   %eax
    3977:	68 25 5b 00 00       	push   $0x5b25
    397c:	6a 01                	push   $0x1
    397e:	e8 b3 06 00 00       	call   4036 <printf>
    3983:	83 c4 10             	add    $0x10,%esp
    int fd = open(name, O_CREATE|O_RDWR);
    3986:	83 ec 08             	sub    $0x8,%esp
    3989:	68 02 02 00 00       	push   $0x202
    398e:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    3991:	50                   	push   %eax
    3992:	e8 62 05 00 00       	call   3ef9 <open>
    3997:	83 c4 10             	add    $0x10,%esp
    399a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(fd < 0){
    399d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    39a1:	79 18                	jns    39bb <fsfull+0x13a>
      printf(1, "open %s failed\n", name);
    39a3:	83 ec 04             	sub    $0x4,%esp
    39a6:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    39a9:	50                   	push   %eax
    39aa:	68 31 5b 00 00       	push   $0x5b31
    39af:	6a 01                	push   $0x1
    39b1:	e8 80 06 00 00       	call   4036 <printf>
    39b6:	83 c4 10             	add    $0x10,%esp
      break;
    39b9:	eb 6e                	jmp    3a29 <fsfull+0x1a8>
    }
    int total = 0;
    39bb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    while(1){
      int cc = write(fd, buf, 512);
    39c2:	83 ec 04             	sub    $0x4,%esp
    39c5:	68 00 02 00 00       	push   $0x200
    39ca:	68 00 8b 00 00       	push   $0x8b00
    39cf:	ff 75 e8             	pushl  -0x18(%ebp)
    39d2:	e8 02 05 00 00       	call   3ed9 <write>
    39d7:	83 c4 10             	add    $0x10,%esp
    39da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(cc < 512)
    39dd:	81 7d e4 ff 01 00 00 	cmpl   $0x1ff,-0x1c(%ebp)
    39e4:	7f 2c                	jg     3a12 <fsfull+0x191>
        break;
    39e6:	90                   	nop
      total += cc;
      fsblocks++;
    }
    printf(1, "wrote %d bytes\n", total);
    39e7:	83 ec 04             	sub    $0x4,%esp
    39ea:	ff 75 ec             	pushl  -0x14(%ebp)
    39ed:	68 41 5b 00 00       	push   $0x5b41
    39f2:	6a 01                	push   $0x1
    39f4:	e8 3d 06 00 00       	call   4036 <printf>
    39f9:	83 c4 10             	add    $0x10,%esp
    close(fd);
    39fc:	83 ec 0c             	sub    $0xc,%esp
    39ff:	ff 75 e8             	pushl  -0x18(%ebp)
    3a02:	e8 da 04 00 00       	call   3ee1 <close>
    3a07:	83 c4 10             	add    $0x10,%esp
    if(total == 0)
    3a0a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3a0e:	75 10                	jne    3a20 <fsfull+0x19f>
    3a10:	eb 0c                	jmp    3a1e <fsfull+0x19d>
    int total = 0;
    while(1){
      int cc = write(fd, buf, 512);
      if(cc < 512)
        break;
      total += cc;
    3a12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    3a15:	01 45 ec             	add    %eax,-0x14(%ebp)
      fsblocks++;
    3a18:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    }
    3a1c:	eb a4                	jmp    39c2 <fsfull+0x141>
    printf(1, "wrote %d bytes\n", total);
    close(fd);
    if(total == 0)
      break;
    3a1e:	eb 09                	jmp    3a29 <fsfull+0x1a8>
  int nfiles;
  int fsblocks = 0;

  printf(1, "fsfull test\n");

  for(nfiles = 0; ; nfiles++){
    3a20:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    }
    printf(1, "wrote %d bytes\n", total);
    close(fd);
    if(total == 0)
      break;
  }
    3a24:	e9 7f fe ff ff       	jmp    38a8 <fsfull+0x27>

  while(nfiles >= 0){
    3a29:	e9 db 00 00 00       	jmp    3b09 <fsfull+0x288>
    char name[64];
    name[0] = 'f';
    3a2e:	c6 45 a4 66          	movb   $0x66,-0x5c(%ebp)
    name[1] = '0' + nfiles / 1000;
    3a32:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    3a35:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    3a3a:	89 c8                	mov    %ecx,%eax
    3a3c:	f7 ea                	imul   %edx
    3a3e:	c1 fa 06             	sar    $0x6,%edx
    3a41:	89 c8                	mov    %ecx,%eax
    3a43:	c1 f8 1f             	sar    $0x1f,%eax
    3a46:	29 c2                	sub    %eax,%edx
    3a48:	89 d0                	mov    %edx,%eax
    3a4a:	83 c0 30             	add    $0x30,%eax
    3a4d:	88 45 a5             	mov    %al,-0x5b(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    3a50:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    3a53:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    3a58:	89 d8                	mov    %ebx,%eax
    3a5a:	f7 ea                	imul   %edx
    3a5c:	c1 fa 06             	sar    $0x6,%edx
    3a5f:	89 d8                	mov    %ebx,%eax
    3a61:	c1 f8 1f             	sar    $0x1f,%eax
    3a64:	89 d1                	mov    %edx,%ecx
    3a66:	29 c1                	sub    %eax,%ecx
    3a68:	69 c1 e8 03 00 00    	imul   $0x3e8,%ecx,%eax
    3a6e:	29 c3                	sub    %eax,%ebx
    3a70:	89 d9                	mov    %ebx,%ecx
    3a72:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    3a77:	89 c8                	mov    %ecx,%eax
    3a79:	f7 ea                	imul   %edx
    3a7b:	c1 fa 05             	sar    $0x5,%edx
    3a7e:	89 c8                	mov    %ecx,%eax
    3a80:	c1 f8 1f             	sar    $0x1f,%eax
    3a83:	29 c2                	sub    %eax,%edx
    3a85:	89 d0                	mov    %edx,%eax
    3a87:	83 c0 30             	add    $0x30,%eax
    3a8a:	88 45 a6             	mov    %al,-0x5a(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    3a8d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    3a90:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    3a95:	89 d8                	mov    %ebx,%eax
    3a97:	f7 ea                	imul   %edx
    3a99:	c1 fa 05             	sar    $0x5,%edx
    3a9c:	89 d8                	mov    %ebx,%eax
    3a9e:	c1 f8 1f             	sar    $0x1f,%eax
    3aa1:	89 d1                	mov    %edx,%ecx
    3aa3:	29 c1                	sub    %eax,%ecx
    3aa5:	6b c1 64             	imul   $0x64,%ecx,%eax
    3aa8:	29 c3                	sub    %eax,%ebx
    3aaa:	89 d9                	mov    %ebx,%ecx
    3aac:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3ab1:	89 c8                	mov    %ecx,%eax
    3ab3:	f7 ea                	imul   %edx
    3ab5:	c1 fa 02             	sar    $0x2,%edx
    3ab8:	89 c8                	mov    %ecx,%eax
    3aba:	c1 f8 1f             	sar    $0x1f,%eax
    3abd:	29 c2                	sub    %eax,%edx
    3abf:	89 d0                	mov    %edx,%eax
    3ac1:	83 c0 30             	add    $0x30,%eax
    3ac4:	88 45 a7             	mov    %al,-0x59(%ebp)
    name[4] = '0' + (nfiles % 10);
    3ac7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    3aca:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3acf:	89 c8                	mov    %ecx,%eax
    3ad1:	f7 ea                	imul   %edx
    3ad3:	c1 fa 02             	sar    $0x2,%edx
    3ad6:	89 c8                	mov    %ecx,%eax
    3ad8:	c1 f8 1f             	sar    $0x1f,%eax
    3adb:	29 c2                	sub    %eax,%edx
    3add:	89 d0                	mov    %edx,%eax
    3adf:	c1 e0 02             	shl    $0x2,%eax
    3ae2:	01 d0                	add    %edx,%eax
    3ae4:	01 c0                	add    %eax,%eax
    3ae6:	29 c1                	sub    %eax,%ecx
    3ae8:	89 ca                	mov    %ecx,%edx
    3aea:	89 d0                	mov    %edx,%eax
    3aec:	83 c0 30             	add    $0x30,%eax
    3aef:	88 45 a8             	mov    %al,-0x58(%ebp)
    name[5] = '\0';
    3af2:	c6 45 a9 00          	movb   $0x0,-0x57(%ebp)
    unlink(name);
    3af6:	83 ec 0c             	sub    $0xc,%esp
    3af9:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    3afc:	50                   	push   %eax
    3afd:	e8 07 04 00 00       	call   3f09 <unlink>
    3b02:	83 c4 10             	add    $0x10,%esp
    nfiles--;
    3b05:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    close(fd);
    if(total == 0)
      break;
  }

  while(nfiles >= 0){
    3b09:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3b0d:	0f 89 1b ff ff ff    	jns    3a2e <fsfull+0x1ad>
    name[5] = '\0';
    unlink(name);
    nfiles--;
  }

  printf(1, "fsfull test finished\n");
    3b13:	83 ec 08             	sub    $0x8,%esp
    3b16:	68 51 5b 00 00       	push   $0x5b51
    3b1b:	6a 01                	push   $0x1
    3b1d:	e8 14 05 00 00       	call   4036 <printf>
    3b22:	83 c4 10             	add    $0x10,%esp
}
    3b25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    3b28:	c9                   	leave  
    3b29:	c3                   	ret    

00003b2a <rand>:

unsigned long randstate = 1;
unsigned int
rand()
{
    3b2a:	55                   	push   %ebp
    3b2b:	89 e5                	mov    %esp,%ebp
  randstate = randstate * 1664525 + 1013904223;
    3b2d:	a1 ac 62 00 00       	mov    0x62ac,%eax
    3b32:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    3b38:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
    3b3d:	a3 ac 62 00 00       	mov    %eax,0x62ac
  return randstate;
    3b42:	a1 ac 62 00 00       	mov    0x62ac,%eax
}
    3b47:	5d                   	pop    %ebp
    3b48:	c3                   	ret    

00003b49 <main>:

int
main(int argc, char *argv[])
{
    3b49:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    3b4d:	83 e4 f0             	and    $0xfffffff0,%esp
    3b50:	ff 71 fc             	pushl  -0x4(%ecx)
    3b53:	55                   	push   %ebp
    3b54:	89 e5                	mov    %esp,%ebp
    3b56:	51                   	push   %ecx
    3b57:	83 ec 04             	sub    $0x4,%esp
  printf(1, "usertests starting\n");
    3b5a:	83 ec 08             	sub    $0x8,%esp
    3b5d:	68 67 5b 00 00       	push   $0x5b67
    3b62:	6a 01                	push   $0x1
    3b64:	e8 cd 04 00 00       	call   4036 <printf>
    3b69:	83 c4 10             	add    $0x10,%esp

  if(open("usertests.ran", 0) >= 0){
    3b6c:	83 ec 08             	sub    $0x8,%esp
    3b6f:	6a 00                	push   $0x0
    3b71:	68 7b 5b 00 00       	push   $0x5b7b
    3b76:	e8 7e 03 00 00       	call   3ef9 <open>
    3b7b:	83 c4 10             	add    $0x10,%esp
    3b7e:	85 c0                	test   %eax,%eax
    3b80:	78 17                	js     3b99 <main+0x50>
    printf(1, "already ran user tests -- rebuild fs.img\n");
    3b82:	83 ec 08             	sub    $0x8,%esp
    3b85:	68 8c 5b 00 00       	push   $0x5b8c
    3b8a:	6a 01                	push   $0x1
    3b8c:	e8 a5 04 00 00       	call   4036 <printf>
    3b91:	83 c4 10             	add    $0x10,%esp
    exit();
    3b94:	e8 20 03 00 00       	call   3eb9 <exit>
  }
  close(open("usertests.ran", O_CREATE));
    3b99:	83 ec 08             	sub    $0x8,%esp
    3b9c:	68 00 02 00 00       	push   $0x200
    3ba1:	68 7b 5b 00 00       	push   $0x5b7b
    3ba6:	e8 4e 03 00 00       	call   3ef9 <open>
    3bab:	83 c4 10             	add    $0x10,%esp
    3bae:	83 ec 0c             	sub    $0xc,%esp
    3bb1:	50                   	push   %eax
    3bb2:	e8 2a 03 00 00       	call   3ee1 <close>
    3bb7:	83 c4 10             	add    $0x10,%esp

  createdelete();
    3bba:	e8 e2 d6 ff ff       	call   12a1 <createdelete>
  linkunlink();
    3bbf:	e8 ff e0 ff ff       	call   1cc3 <linkunlink>
  concreate();
    3bc4:	e8 4b dd ff ff       	call   1914 <concreate>
  fourfiles();
    3bc9:	e8 83 d4 ff ff       	call   1051 <fourfiles>
  sharedfd();
    3bce:	e8 9b d2 ff ff       	call   e6e <sharedfd>

  bigargtest();
    3bd3:	e8 6e fb ff ff       	call   3746 <bigargtest>
  bigwrite();
    3bd8:	e8 d5 ea ff ff       	call   26b2 <bigwrite>
  bigargtest();
    3bdd:	e8 64 fb ff ff       	call   3746 <bigargtest>
  bsstest();
    3be2:	e8 ea fa ff ff       	call   36d1 <bsstest>
  sbrktest();
    3be7:	e8 f9 f4 ff ff       	call   30e5 <sbrktest>
  validatetest();
    3bec:	e8 03 fa ff ff       	call   35f4 <validatetest>

  opentest();
    3bf1:	e8 06 c7 ff ff       	call   2fc <opentest>
  writetest();
    3bf6:	e8 af c7 ff ff       	call   3aa <writetest>
  writetest1();
    3bfb:	e8 b9 c9 ff ff       	call   5b9 <writetest1>
  createtest();
    3c00:	e8 b1 cb ff ff       	call   7b6 <createtest>

  openiputtest();
    3c05:	e8 e4 c5 ff ff       	call   1ee <openiputtest>
  exitiputtest();
    3c0a:	e8 e1 c4 ff ff       	call   f0 <exitiputtest>
  iputtest();
    3c0f:	e8 ec c3 ff ff       	call   0 <iputtest>

  mem();
    3c14:	e8 65 d1 ff ff       	call   d7e <mem>
  pipe1();
    3c19:	e8 9c cd ff ff       	call   9ba <pipe1>
  preempt();
    3c1e:	e8 80 cf ff ff       	call   ba3 <preempt>
  exitwait();
    3c23:	e8 de d0 ff ff       	call   d06 <exitwait>

  rmdot();
    3c28:	e8 fa ee ff ff       	call   2b27 <rmdot>
  fourteen();
    3c2d:	e8 9a ed ff ff       	call   29cc <fourteen>
  bigfile();
    3c32:	e8 78 eb ff ff       	call   27af <bigfile>
  subdir();
    3c37:	e8 33 e3 ff ff       	call   1f6f <subdir>
  linktest();
    3c3c:	e8 92 da ff ff       	call   16d3 <linktest>
  unlinkread();
    3c41:	e8 cc d8 ff ff       	call   1512 <unlinkread>
  dirfile();
    3c46:	e8 60 f0 ff ff       	call   2cab <dirfile>
  iref();
    3c4b:	e8 92 f2 ff ff       	call   2ee2 <iref>
  forktest();
    3c50:	e8 c6 f3 ff ff       	call   301b <forktest>
  bigdir(); // slow
    3c55:	e8 a1 e1 ff ff       	call   1dfb <bigdir>
  exectest();
    3c5a:	e8 09 cd ff ff       	call   968 <exectest>

  exit();
    3c5f:	e8 55 02 00 00       	call   3eb9 <exit>

00003c64 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    3c64:	55                   	push   %ebp
    3c65:	89 e5                	mov    %esp,%ebp
    3c67:	57                   	push   %edi
    3c68:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    3c69:	8b 4d 08             	mov    0x8(%ebp),%ecx
    3c6c:	8b 55 10             	mov    0x10(%ebp),%edx
    3c6f:	8b 45 0c             	mov    0xc(%ebp),%eax
    3c72:	89 cb                	mov    %ecx,%ebx
    3c74:	89 df                	mov    %ebx,%edi
    3c76:	89 d1                	mov    %edx,%ecx
    3c78:	fc                   	cld    
    3c79:	f3 aa                	rep stos %al,%es:(%edi)
    3c7b:	89 ca                	mov    %ecx,%edx
    3c7d:	89 fb                	mov    %edi,%ebx
    3c7f:	89 5d 08             	mov    %ebx,0x8(%ebp)
    3c82:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    3c85:	5b                   	pop    %ebx
    3c86:	5f                   	pop    %edi
    3c87:	5d                   	pop    %ebp
    3c88:	c3                   	ret    

00003c89 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    3c89:	55                   	push   %ebp
    3c8a:	89 e5                	mov    %esp,%ebp
    3c8c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    3c8f:	8b 45 08             	mov    0x8(%ebp),%eax
    3c92:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    3c95:	90                   	nop
    3c96:	8b 45 08             	mov    0x8(%ebp),%eax
    3c99:	8d 50 01             	lea    0x1(%eax),%edx
    3c9c:	89 55 08             	mov    %edx,0x8(%ebp)
    3c9f:	8b 55 0c             	mov    0xc(%ebp),%edx
    3ca2:	8d 4a 01             	lea    0x1(%edx),%ecx
    3ca5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    3ca8:	0f b6 12             	movzbl (%edx),%edx
    3cab:	88 10                	mov    %dl,(%eax)
    3cad:	0f b6 00             	movzbl (%eax),%eax
    3cb0:	84 c0                	test   %al,%al
    3cb2:	75 e2                	jne    3c96 <strcpy+0xd>
    ;
  return os;
    3cb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3cb7:	c9                   	leave  
    3cb8:	c3                   	ret    

00003cb9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    3cb9:	55                   	push   %ebp
    3cba:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    3cbc:	eb 08                	jmp    3cc6 <strcmp+0xd>
    p++, q++;
    3cbe:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    3cc2:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    3cc6:	8b 45 08             	mov    0x8(%ebp),%eax
    3cc9:	0f b6 00             	movzbl (%eax),%eax
    3ccc:	84 c0                	test   %al,%al
    3cce:	74 10                	je     3ce0 <strcmp+0x27>
    3cd0:	8b 45 08             	mov    0x8(%ebp),%eax
    3cd3:	0f b6 10             	movzbl (%eax),%edx
    3cd6:	8b 45 0c             	mov    0xc(%ebp),%eax
    3cd9:	0f b6 00             	movzbl (%eax),%eax
    3cdc:	38 c2                	cmp    %al,%dl
    3cde:	74 de                	je     3cbe <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    3ce0:	8b 45 08             	mov    0x8(%ebp),%eax
    3ce3:	0f b6 00             	movzbl (%eax),%eax
    3ce6:	0f b6 d0             	movzbl %al,%edx
    3ce9:	8b 45 0c             	mov    0xc(%ebp),%eax
    3cec:	0f b6 00             	movzbl (%eax),%eax
    3cef:	0f b6 c0             	movzbl %al,%eax
    3cf2:	29 c2                	sub    %eax,%edx
    3cf4:	89 d0                	mov    %edx,%eax
}
    3cf6:	5d                   	pop    %ebp
    3cf7:	c3                   	ret    

00003cf8 <strlen>:

uint
strlen(char *s)
{
    3cf8:	55                   	push   %ebp
    3cf9:	89 e5                	mov    %esp,%ebp
    3cfb:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    3cfe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    3d05:	eb 04                	jmp    3d0b <strlen+0x13>
    3d07:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    3d0b:	8b 55 fc             	mov    -0x4(%ebp),%edx
    3d0e:	8b 45 08             	mov    0x8(%ebp),%eax
    3d11:	01 d0                	add    %edx,%eax
    3d13:	0f b6 00             	movzbl (%eax),%eax
    3d16:	84 c0                	test   %al,%al
    3d18:	75 ed                	jne    3d07 <strlen+0xf>
    ;
  return n;
    3d1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3d1d:	c9                   	leave  
    3d1e:	c3                   	ret    

00003d1f <memset>:

void*
memset(void *dst, int c, uint n)
{
    3d1f:	55                   	push   %ebp
    3d20:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
    3d22:	8b 45 10             	mov    0x10(%ebp),%eax
    3d25:	50                   	push   %eax
    3d26:	ff 75 0c             	pushl  0xc(%ebp)
    3d29:	ff 75 08             	pushl  0x8(%ebp)
    3d2c:	e8 33 ff ff ff       	call   3c64 <stosb>
    3d31:	83 c4 0c             	add    $0xc,%esp
  return dst;
    3d34:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3d37:	c9                   	leave  
    3d38:	c3                   	ret    

00003d39 <strchr>:

char*
strchr(const char *s, char c)
{
    3d39:	55                   	push   %ebp
    3d3a:	89 e5                	mov    %esp,%ebp
    3d3c:	83 ec 04             	sub    $0x4,%esp
    3d3f:	8b 45 0c             	mov    0xc(%ebp),%eax
    3d42:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    3d45:	eb 14                	jmp    3d5b <strchr+0x22>
    if(*s == c)
    3d47:	8b 45 08             	mov    0x8(%ebp),%eax
    3d4a:	0f b6 00             	movzbl (%eax),%eax
    3d4d:	3a 45 fc             	cmp    -0x4(%ebp),%al
    3d50:	75 05                	jne    3d57 <strchr+0x1e>
      return (char*)s;
    3d52:	8b 45 08             	mov    0x8(%ebp),%eax
    3d55:	eb 13                	jmp    3d6a <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    3d57:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    3d5b:	8b 45 08             	mov    0x8(%ebp),%eax
    3d5e:	0f b6 00             	movzbl (%eax),%eax
    3d61:	84 c0                	test   %al,%al
    3d63:	75 e2                	jne    3d47 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    3d65:	b8 00 00 00 00       	mov    $0x0,%eax
}
    3d6a:	c9                   	leave  
    3d6b:	c3                   	ret    

00003d6c <gets>:

char*
gets(char *buf, int max)
{
    3d6c:	55                   	push   %ebp
    3d6d:	89 e5                	mov    %esp,%ebp
    3d6f:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3d72:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3d79:	eb 44                	jmp    3dbf <gets+0x53>
    cc = read(0, &c, 1);
    3d7b:	83 ec 04             	sub    $0x4,%esp
    3d7e:	6a 01                	push   $0x1
    3d80:	8d 45 ef             	lea    -0x11(%ebp),%eax
    3d83:	50                   	push   %eax
    3d84:	6a 00                	push   $0x0
    3d86:	e8 46 01 00 00       	call   3ed1 <read>
    3d8b:	83 c4 10             	add    $0x10,%esp
    3d8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    3d91:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3d95:	7f 02                	jg     3d99 <gets+0x2d>
      break;
    3d97:	eb 31                	jmp    3dca <gets+0x5e>
    buf[i++] = c;
    3d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3d9c:	8d 50 01             	lea    0x1(%eax),%edx
    3d9f:	89 55 f4             	mov    %edx,-0xc(%ebp)
    3da2:	89 c2                	mov    %eax,%edx
    3da4:	8b 45 08             	mov    0x8(%ebp),%eax
    3da7:	01 c2                	add    %eax,%edx
    3da9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    3dad:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    3daf:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    3db3:	3c 0a                	cmp    $0xa,%al
    3db5:	74 13                	je     3dca <gets+0x5e>
    3db7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    3dbb:	3c 0d                	cmp    $0xd,%al
    3dbd:	74 0b                	je     3dca <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3dbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3dc2:	83 c0 01             	add    $0x1,%eax
    3dc5:	3b 45 0c             	cmp    0xc(%ebp),%eax
    3dc8:	7c b1                	jl     3d7b <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    3dca:	8b 55 f4             	mov    -0xc(%ebp),%edx
    3dcd:	8b 45 08             	mov    0x8(%ebp),%eax
    3dd0:	01 d0                	add    %edx,%eax
    3dd2:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    3dd5:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3dd8:	c9                   	leave  
    3dd9:	c3                   	ret    

00003dda <stat>:

int
stat(char *n, struct stat *st)
{
    3dda:	55                   	push   %ebp
    3ddb:	89 e5                	mov    %esp,%ebp
    3ddd:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    3de0:	83 ec 08             	sub    $0x8,%esp
    3de3:	6a 00                	push   $0x0
    3de5:	ff 75 08             	pushl  0x8(%ebp)
    3de8:	e8 0c 01 00 00       	call   3ef9 <open>
    3ded:	83 c4 10             	add    $0x10,%esp
    3df0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    3df3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3df7:	79 07                	jns    3e00 <stat+0x26>
    return -1;
    3df9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    3dfe:	eb 25                	jmp    3e25 <stat+0x4b>
  r = fstat(fd, st);
    3e00:	83 ec 08             	sub    $0x8,%esp
    3e03:	ff 75 0c             	pushl  0xc(%ebp)
    3e06:	ff 75 f4             	pushl  -0xc(%ebp)
    3e09:	e8 03 01 00 00       	call   3f11 <fstat>
    3e0e:	83 c4 10             	add    $0x10,%esp
    3e11:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    3e14:	83 ec 0c             	sub    $0xc,%esp
    3e17:	ff 75 f4             	pushl  -0xc(%ebp)
    3e1a:	e8 c2 00 00 00       	call   3ee1 <close>
    3e1f:	83 c4 10             	add    $0x10,%esp
  return r;
    3e22:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    3e25:	c9                   	leave  
    3e26:	c3                   	ret    

00003e27 <atoi>:

int
atoi(const char *s)
{
    3e27:	55                   	push   %ebp
    3e28:	89 e5                	mov    %esp,%ebp
    3e2a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    3e2d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    3e34:	eb 25                	jmp    3e5b <atoi+0x34>
    n = n*10 + *s++ - '0';
    3e36:	8b 55 fc             	mov    -0x4(%ebp),%edx
    3e39:	89 d0                	mov    %edx,%eax
    3e3b:	c1 e0 02             	shl    $0x2,%eax
    3e3e:	01 d0                	add    %edx,%eax
    3e40:	01 c0                	add    %eax,%eax
    3e42:	89 c1                	mov    %eax,%ecx
    3e44:	8b 45 08             	mov    0x8(%ebp),%eax
    3e47:	8d 50 01             	lea    0x1(%eax),%edx
    3e4a:	89 55 08             	mov    %edx,0x8(%ebp)
    3e4d:	0f b6 00             	movzbl (%eax),%eax
    3e50:	0f be c0             	movsbl %al,%eax
    3e53:	01 c8                	add    %ecx,%eax
    3e55:	83 e8 30             	sub    $0x30,%eax
    3e58:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    3e5b:	8b 45 08             	mov    0x8(%ebp),%eax
    3e5e:	0f b6 00             	movzbl (%eax),%eax
    3e61:	3c 2f                	cmp    $0x2f,%al
    3e63:	7e 0a                	jle    3e6f <atoi+0x48>
    3e65:	8b 45 08             	mov    0x8(%ebp),%eax
    3e68:	0f b6 00             	movzbl (%eax),%eax
    3e6b:	3c 39                	cmp    $0x39,%al
    3e6d:	7e c7                	jle    3e36 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    3e6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3e72:	c9                   	leave  
    3e73:	c3                   	ret    

00003e74 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    3e74:	55                   	push   %ebp
    3e75:	89 e5                	mov    %esp,%ebp
    3e77:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    3e7a:	8b 45 08             	mov    0x8(%ebp),%eax
    3e7d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    3e80:	8b 45 0c             	mov    0xc(%ebp),%eax
    3e83:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    3e86:	eb 17                	jmp    3e9f <memmove+0x2b>
    *dst++ = *src++;
    3e88:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3e8b:	8d 50 01             	lea    0x1(%eax),%edx
    3e8e:	89 55 fc             	mov    %edx,-0x4(%ebp)
    3e91:	8b 55 f8             	mov    -0x8(%ebp),%edx
    3e94:	8d 4a 01             	lea    0x1(%edx),%ecx
    3e97:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    3e9a:	0f b6 12             	movzbl (%edx),%edx
    3e9d:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    3e9f:	8b 45 10             	mov    0x10(%ebp),%eax
    3ea2:	8d 50 ff             	lea    -0x1(%eax),%edx
    3ea5:	89 55 10             	mov    %edx,0x10(%ebp)
    3ea8:	85 c0                	test   %eax,%eax
    3eaa:	7f dc                	jg     3e88 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    3eac:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3eaf:	c9                   	leave  
    3eb0:	c3                   	ret    

00003eb1 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    3eb1:	b8 01 00 00 00       	mov    $0x1,%eax
    3eb6:	cd 40                	int    $0x40
    3eb8:	c3                   	ret    

00003eb9 <exit>:
SYSCALL(exit)
    3eb9:	b8 02 00 00 00       	mov    $0x2,%eax
    3ebe:	cd 40                	int    $0x40
    3ec0:	c3                   	ret    

00003ec1 <wait>:
SYSCALL(wait)
    3ec1:	b8 03 00 00 00       	mov    $0x3,%eax
    3ec6:	cd 40                	int    $0x40
    3ec8:	c3                   	ret    

00003ec9 <pipe>:
SYSCALL(pipe)
    3ec9:	b8 04 00 00 00       	mov    $0x4,%eax
    3ece:	cd 40                	int    $0x40
    3ed0:	c3                   	ret    

00003ed1 <read>:
SYSCALL(read)
    3ed1:	b8 05 00 00 00       	mov    $0x5,%eax
    3ed6:	cd 40                	int    $0x40
    3ed8:	c3                   	ret    

00003ed9 <write>:
SYSCALL(write)
    3ed9:	b8 10 00 00 00       	mov    $0x10,%eax
    3ede:	cd 40                	int    $0x40
    3ee0:	c3                   	ret    

00003ee1 <close>:
SYSCALL(close)
    3ee1:	b8 15 00 00 00       	mov    $0x15,%eax
    3ee6:	cd 40                	int    $0x40
    3ee8:	c3                   	ret    

00003ee9 <kill>:
SYSCALL(kill)
    3ee9:	b8 06 00 00 00       	mov    $0x6,%eax
    3eee:	cd 40                	int    $0x40
    3ef0:	c3                   	ret    

00003ef1 <exec>:
SYSCALL(exec)
    3ef1:	b8 07 00 00 00       	mov    $0x7,%eax
    3ef6:	cd 40                	int    $0x40
    3ef8:	c3                   	ret    

00003ef9 <open>:
SYSCALL(open)
    3ef9:	b8 0f 00 00 00       	mov    $0xf,%eax
    3efe:	cd 40                	int    $0x40
    3f00:	c3                   	ret    

00003f01 <mknod>:
SYSCALL(mknod)
    3f01:	b8 11 00 00 00       	mov    $0x11,%eax
    3f06:	cd 40                	int    $0x40
    3f08:	c3                   	ret    

00003f09 <unlink>:
SYSCALL(unlink)
    3f09:	b8 12 00 00 00       	mov    $0x12,%eax
    3f0e:	cd 40                	int    $0x40
    3f10:	c3                   	ret    

00003f11 <fstat>:
SYSCALL(fstat)
    3f11:	b8 08 00 00 00       	mov    $0x8,%eax
    3f16:	cd 40                	int    $0x40
    3f18:	c3                   	ret    

00003f19 <link>:
SYSCALL(link)
    3f19:	b8 13 00 00 00       	mov    $0x13,%eax
    3f1e:	cd 40                	int    $0x40
    3f20:	c3                   	ret    

00003f21 <mkdir>:
SYSCALL(mkdir)
    3f21:	b8 14 00 00 00       	mov    $0x14,%eax
    3f26:	cd 40                	int    $0x40
    3f28:	c3                   	ret    

00003f29 <chdir>:
SYSCALL(chdir)
    3f29:	b8 09 00 00 00       	mov    $0x9,%eax
    3f2e:	cd 40                	int    $0x40
    3f30:	c3                   	ret    

00003f31 <dup>:
SYSCALL(dup)
    3f31:	b8 0a 00 00 00       	mov    $0xa,%eax
    3f36:	cd 40                	int    $0x40
    3f38:	c3                   	ret    

00003f39 <getpid>:
SYSCALL(getpid)
    3f39:	b8 0b 00 00 00       	mov    $0xb,%eax
    3f3e:	cd 40                	int    $0x40
    3f40:	c3                   	ret    

00003f41 <sbrk>:
SYSCALL(sbrk)
    3f41:	b8 0c 00 00 00       	mov    $0xc,%eax
    3f46:	cd 40                	int    $0x40
    3f48:	c3                   	ret    

00003f49 <sleep>:
SYSCALL(sleep)
    3f49:	b8 0d 00 00 00       	mov    $0xd,%eax
    3f4e:	cd 40                	int    $0x40
    3f50:	c3                   	ret    

00003f51 <uptime>:
SYSCALL(uptime)
    3f51:	b8 0e 00 00 00       	mov    $0xe,%eax
    3f56:	cd 40                	int    $0x40
    3f58:	c3                   	ret    

00003f59 <getpcount>:
SYSCALL(getpcount)
    3f59:	b8 16 00 00 00       	mov    $0x16,%eax
    3f5e:	cd 40                	int    $0x40
    3f60:	c3                   	ret    

00003f61 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    3f61:	55                   	push   %ebp
    3f62:	89 e5                	mov    %esp,%ebp
    3f64:	83 ec 18             	sub    $0x18,%esp
    3f67:	8b 45 0c             	mov    0xc(%ebp),%eax
    3f6a:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    3f6d:	83 ec 04             	sub    $0x4,%esp
    3f70:	6a 01                	push   $0x1
    3f72:	8d 45 f4             	lea    -0xc(%ebp),%eax
    3f75:	50                   	push   %eax
    3f76:	ff 75 08             	pushl  0x8(%ebp)
    3f79:	e8 5b ff ff ff       	call   3ed9 <write>
    3f7e:	83 c4 10             	add    $0x10,%esp
}
    3f81:	c9                   	leave  
    3f82:	c3                   	ret    

00003f83 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    3f83:	55                   	push   %ebp
    3f84:	89 e5                	mov    %esp,%ebp
    3f86:	53                   	push   %ebx
    3f87:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    3f8a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    3f91:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    3f95:	74 17                	je     3fae <printint+0x2b>
    3f97:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    3f9b:	79 11                	jns    3fae <printint+0x2b>
    neg = 1;
    3f9d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    3fa4:	8b 45 0c             	mov    0xc(%ebp),%eax
    3fa7:	f7 d8                	neg    %eax
    3fa9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    3fac:	eb 06                	jmp    3fb4 <printint+0x31>
  } else {
    x = xx;
    3fae:	8b 45 0c             	mov    0xc(%ebp),%eax
    3fb1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    3fb4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    3fbb:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    3fbe:	8d 41 01             	lea    0x1(%ecx),%eax
    3fc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    3fc4:	8b 5d 10             	mov    0x10(%ebp),%ebx
    3fc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3fca:	ba 00 00 00 00       	mov    $0x0,%edx
    3fcf:	f7 f3                	div    %ebx
    3fd1:	89 d0                	mov    %edx,%eax
    3fd3:	0f b6 80 b0 62 00 00 	movzbl 0x62b0(%eax),%eax
    3fda:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    3fde:	8b 5d 10             	mov    0x10(%ebp),%ebx
    3fe1:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3fe4:	ba 00 00 00 00       	mov    $0x0,%edx
    3fe9:	f7 f3                	div    %ebx
    3feb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    3fee:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3ff2:	75 c7                	jne    3fbb <printint+0x38>
  if(neg)
    3ff4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3ff8:	74 0e                	je     4008 <printint+0x85>
    buf[i++] = '-';
    3ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3ffd:	8d 50 01             	lea    0x1(%eax),%edx
    4000:	89 55 f4             	mov    %edx,-0xc(%ebp)
    4003:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    4008:	eb 1d                	jmp    4027 <printint+0xa4>
    putc(fd, buf[i]);
    400a:	8d 55 dc             	lea    -0x24(%ebp),%edx
    400d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4010:	01 d0                	add    %edx,%eax
    4012:	0f b6 00             	movzbl (%eax),%eax
    4015:	0f be c0             	movsbl %al,%eax
    4018:	83 ec 08             	sub    $0x8,%esp
    401b:	50                   	push   %eax
    401c:	ff 75 08             	pushl  0x8(%ebp)
    401f:	e8 3d ff ff ff       	call   3f61 <putc>
    4024:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    4027:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    402b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    402f:	79 d9                	jns    400a <printint+0x87>
    putc(fd, buf[i]);
}
    4031:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    4034:	c9                   	leave  
    4035:	c3                   	ret    

00004036 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    4036:	55                   	push   %ebp
    4037:	89 e5                	mov    %esp,%ebp
    4039:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    403c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    4043:	8d 45 0c             	lea    0xc(%ebp),%eax
    4046:	83 c0 04             	add    $0x4,%eax
    4049:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    404c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    4053:	e9 59 01 00 00       	jmp    41b1 <printf+0x17b>
    c = fmt[i] & 0xff;
    4058:	8b 55 0c             	mov    0xc(%ebp),%edx
    405b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    405e:	01 d0                	add    %edx,%eax
    4060:	0f b6 00             	movzbl (%eax),%eax
    4063:	0f be c0             	movsbl %al,%eax
    4066:	25 ff 00 00 00       	and    $0xff,%eax
    406b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    406e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    4072:	75 2c                	jne    40a0 <printf+0x6a>
      if(c == '%'){
    4074:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    4078:	75 0c                	jne    4086 <printf+0x50>
        state = '%';
    407a:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    4081:	e9 27 01 00 00       	jmp    41ad <printf+0x177>
      } else {
        putc(fd, c);
    4086:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    4089:	0f be c0             	movsbl %al,%eax
    408c:	83 ec 08             	sub    $0x8,%esp
    408f:	50                   	push   %eax
    4090:	ff 75 08             	pushl  0x8(%ebp)
    4093:	e8 c9 fe ff ff       	call   3f61 <putc>
    4098:	83 c4 10             	add    $0x10,%esp
    409b:	e9 0d 01 00 00       	jmp    41ad <printf+0x177>
      }
    } else if(state == '%'){
    40a0:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    40a4:	0f 85 03 01 00 00    	jne    41ad <printf+0x177>
      if(c == 'd'){
    40aa:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    40ae:	75 1e                	jne    40ce <printf+0x98>
        printint(fd, *ap, 10, 1);
    40b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
    40b3:	8b 00                	mov    (%eax),%eax
    40b5:	6a 01                	push   $0x1
    40b7:	6a 0a                	push   $0xa
    40b9:	50                   	push   %eax
    40ba:	ff 75 08             	pushl  0x8(%ebp)
    40bd:	e8 c1 fe ff ff       	call   3f83 <printint>
    40c2:	83 c4 10             	add    $0x10,%esp
        ap++;
    40c5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    40c9:	e9 d8 00 00 00       	jmp    41a6 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
    40ce:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    40d2:	74 06                	je     40da <printf+0xa4>
    40d4:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    40d8:	75 1e                	jne    40f8 <printf+0xc2>
        printint(fd, *ap, 16, 0);
    40da:	8b 45 e8             	mov    -0x18(%ebp),%eax
    40dd:	8b 00                	mov    (%eax),%eax
    40df:	6a 00                	push   $0x0
    40e1:	6a 10                	push   $0x10
    40e3:	50                   	push   %eax
    40e4:	ff 75 08             	pushl  0x8(%ebp)
    40e7:	e8 97 fe ff ff       	call   3f83 <printint>
    40ec:	83 c4 10             	add    $0x10,%esp
        ap++;
    40ef:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    40f3:	e9 ae 00 00 00       	jmp    41a6 <printf+0x170>
      } else if(c == 's'){
    40f8:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    40fc:	75 43                	jne    4141 <printf+0x10b>
        s = (char*)*ap;
    40fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
    4101:	8b 00                	mov    (%eax),%eax
    4103:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    4106:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    410a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    410e:	75 07                	jne    4117 <printf+0xe1>
          s = "(null)";
    4110:	c7 45 f4 b6 5b 00 00 	movl   $0x5bb6,-0xc(%ebp)
        while(*s != 0){
    4117:	eb 1c                	jmp    4135 <printf+0xff>
          putc(fd, *s);
    4119:	8b 45 f4             	mov    -0xc(%ebp),%eax
    411c:	0f b6 00             	movzbl (%eax),%eax
    411f:	0f be c0             	movsbl %al,%eax
    4122:	83 ec 08             	sub    $0x8,%esp
    4125:	50                   	push   %eax
    4126:	ff 75 08             	pushl  0x8(%ebp)
    4129:	e8 33 fe ff ff       	call   3f61 <putc>
    412e:	83 c4 10             	add    $0x10,%esp
          s++;
    4131:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    4135:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4138:	0f b6 00             	movzbl (%eax),%eax
    413b:	84 c0                	test   %al,%al
    413d:	75 da                	jne    4119 <printf+0xe3>
    413f:	eb 65                	jmp    41a6 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    4141:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    4145:	75 1d                	jne    4164 <printf+0x12e>
        putc(fd, *ap);
    4147:	8b 45 e8             	mov    -0x18(%ebp),%eax
    414a:	8b 00                	mov    (%eax),%eax
    414c:	0f be c0             	movsbl %al,%eax
    414f:	83 ec 08             	sub    $0x8,%esp
    4152:	50                   	push   %eax
    4153:	ff 75 08             	pushl  0x8(%ebp)
    4156:	e8 06 fe ff ff       	call   3f61 <putc>
    415b:	83 c4 10             	add    $0x10,%esp
        ap++;
    415e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    4162:	eb 42                	jmp    41a6 <printf+0x170>
      } else if(c == '%'){
    4164:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    4168:	75 17                	jne    4181 <printf+0x14b>
        putc(fd, c);
    416a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    416d:	0f be c0             	movsbl %al,%eax
    4170:	83 ec 08             	sub    $0x8,%esp
    4173:	50                   	push   %eax
    4174:	ff 75 08             	pushl  0x8(%ebp)
    4177:	e8 e5 fd ff ff       	call   3f61 <putc>
    417c:	83 c4 10             	add    $0x10,%esp
    417f:	eb 25                	jmp    41a6 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    4181:	83 ec 08             	sub    $0x8,%esp
    4184:	6a 25                	push   $0x25
    4186:	ff 75 08             	pushl  0x8(%ebp)
    4189:	e8 d3 fd ff ff       	call   3f61 <putc>
    418e:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
    4191:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    4194:	0f be c0             	movsbl %al,%eax
    4197:	83 ec 08             	sub    $0x8,%esp
    419a:	50                   	push   %eax
    419b:	ff 75 08             	pushl  0x8(%ebp)
    419e:	e8 be fd ff ff       	call   3f61 <putc>
    41a3:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    41a6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    41ad:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    41b1:	8b 55 0c             	mov    0xc(%ebp),%edx
    41b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    41b7:	01 d0                	add    %edx,%eax
    41b9:	0f b6 00             	movzbl (%eax),%eax
    41bc:	84 c0                	test   %al,%al
    41be:	0f 85 94 fe ff ff    	jne    4058 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    41c4:	c9                   	leave  
    41c5:	c3                   	ret    

000041c6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    41c6:	55                   	push   %ebp
    41c7:	89 e5                	mov    %esp,%ebp
    41c9:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    41cc:	8b 45 08             	mov    0x8(%ebp),%eax
    41cf:	83 e8 08             	sub    $0x8,%eax
    41d2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    41d5:	a1 88 63 00 00       	mov    0x6388,%eax
    41da:	89 45 fc             	mov    %eax,-0x4(%ebp)
    41dd:	eb 24                	jmp    4203 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    41df:	8b 45 fc             	mov    -0x4(%ebp),%eax
    41e2:	8b 00                	mov    (%eax),%eax
    41e4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    41e7:	77 12                	ja     41fb <free+0x35>
    41e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    41ec:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    41ef:	77 24                	ja     4215 <free+0x4f>
    41f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    41f4:	8b 00                	mov    (%eax),%eax
    41f6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    41f9:	77 1a                	ja     4215 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    41fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
    41fe:	8b 00                	mov    (%eax),%eax
    4200:	89 45 fc             	mov    %eax,-0x4(%ebp)
    4203:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4206:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    4209:	76 d4                	jbe    41df <free+0x19>
    420b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    420e:	8b 00                	mov    (%eax),%eax
    4210:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    4213:	76 ca                	jbe    41df <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    4215:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4218:	8b 40 04             	mov    0x4(%eax),%eax
    421b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    4222:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4225:	01 c2                	add    %eax,%edx
    4227:	8b 45 fc             	mov    -0x4(%ebp),%eax
    422a:	8b 00                	mov    (%eax),%eax
    422c:	39 c2                	cmp    %eax,%edx
    422e:	75 24                	jne    4254 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    4230:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4233:	8b 50 04             	mov    0x4(%eax),%edx
    4236:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4239:	8b 00                	mov    (%eax),%eax
    423b:	8b 40 04             	mov    0x4(%eax),%eax
    423e:	01 c2                	add    %eax,%edx
    4240:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4243:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    4246:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4249:	8b 00                	mov    (%eax),%eax
    424b:	8b 10                	mov    (%eax),%edx
    424d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4250:	89 10                	mov    %edx,(%eax)
    4252:	eb 0a                	jmp    425e <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    4254:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4257:	8b 10                	mov    (%eax),%edx
    4259:	8b 45 f8             	mov    -0x8(%ebp),%eax
    425c:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    425e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4261:	8b 40 04             	mov    0x4(%eax),%eax
    4264:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    426b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    426e:	01 d0                	add    %edx,%eax
    4270:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    4273:	75 20                	jne    4295 <free+0xcf>
    p->s.size += bp->s.size;
    4275:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4278:	8b 50 04             	mov    0x4(%eax),%edx
    427b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    427e:	8b 40 04             	mov    0x4(%eax),%eax
    4281:	01 c2                	add    %eax,%edx
    4283:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4286:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    4289:	8b 45 f8             	mov    -0x8(%ebp),%eax
    428c:	8b 10                	mov    (%eax),%edx
    428e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4291:	89 10                	mov    %edx,(%eax)
    4293:	eb 08                	jmp    429d <free+0xd7>
  } else
    p->s.ptr = bp;
    4295:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4298:	8b 55 f8             	mov    -0x8(%ebp),%edx
    429b:	89 10                	mov    %edx,(%eax)
  freep = p;
    429d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    42a0:	a3 88 63 00 00       	mov    %eax,0x6388
}
    42a5:	c9                   	leave  
    42a6:	c3                   	ret    

000042a7 <morecore>:

static Header*
morecore(uint nu)
{
    42a7:	55                   	push   %ebp
    42a8:	89 e5                	mov    %esp,%ebp
    42aa:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    42ad:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    42b4:	77 07                	ja     42bd <morecore+0x16>
    nu = 4096;
    42b6:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    42bd:	8b 45 08             	mov    0x8(%ebp),%eax
    42c0:	c1 e0 03             	shl    $0x3,%eax
    42c3:	83 ec 0c             	sub    $0xc,%esp
    42c6:	50                   	push   %eax
    42c7:	e8 75 fc ff ff       	call   3f41 <sbrk>
    42cc:	83 c4 10             	add    $0x10,%esp
    42cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    42d2:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    42d6:	75 07                	jne    42df <morecore+0x38>
    return 0;
    42d8:	b8 00 00 00 00       	mov    $0x0,%eax
    42dd:	eb 26                	jmp    4305 <morecore+0x5e>
  hp = (Header*)p;
    42df:	8b 45 f4             	mov    -0xc(%ebp),%eax
    42e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    42e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    42e8:	8b 55 08             	mov    0x8(%ebp),%edx
    42eb:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    42ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
    42f1:	83 c0 08             	add    $0x8,%eax
    42f4:	83 ec 0c             	sub    $0xc,%esp
    42f7:	50                   	push   %eax
    42f8:	e8 c9 fe ff ff       	call   41c6 <free>
    42fd:	83 c4 10             	add    $0x10,%esp
  return freep;
    4300:	a1 88 63 00 00       	mov    0x6388,%eax
}
    4305:	c9                   	leave  
    4306:	c3                   	ret    

00004307 <malloc>:

void*
malloc(uint nbytes)
{
    4307:	55                   	push   %ebp
    4308:	89 e5                	mov    %esp,%ebp
    430a:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    430d:	8b 45 08             	mov    0x8(%ebp),%eax
    4310:	83 c0 07             	add    $0x7,%eax
    4313:	c1 e8 03             	shr    $0x3,%eax
    4316:	83 c0 01             	add    $0x1,%eax
    4319:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    431c:	a1 88 63 00 00       	mov    0x6388,%eax
    4321:	89 45 f0             	mov    %eax,-0x10(%ebp)
    4324:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    4328:	75 23                	jne    434d <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    432a:	c7 45 f0 80 63 00 00 	movl   $0x6380,-0x10(%ebp)
    4331:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4334:	a3 88 63 00 00       	mov    %eax,0x6388
    4339:	a1 88 63 00 00       	mov    0x6388,%eax
    433e:	a3 80 63 00 00       	mov    %eax,0x6380
    base.s.size = 0;
    4343:	c7 05 84 63 00 00 00 	movl   $0x0,0x6384
    434a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    434d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4350:	8b 00                	mov    (%eax),%eax
    4352:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    4355:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4358:	8b 40 04             	mov    0x4(%eax),%eax
    435b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    435e:	72 4d                	jb     43ad <malloc+0xa6>
      if(p->s.size == nunits)
    4360:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4363:	8b 40 04             	mov    0x4(%eax),%eax
    4366:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    4369:	75 0c                	jne    4377 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    436b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    436e:	8b 10                	mov    (%eax),%edx
    4370:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4373:	89 10                	mov    %edx,(%eax)
    4375:	eb 26                	jmp    439d <malloc+0x96>
      else {
        p->s.size -= nunits;
    4377:	8b 45 f4             	mov    -0xc(%ebp),%eax
    437a:	8b 40 04             	mov    0x4(%eax),%eax
    437d:	2b 45 ec             	sub    -0x14(%ebp),%eax
    4380:	89 c2                	mov    %eax,%edx
    4382:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4385:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    4388:	8b 45 f4             	mov    -0xc(%ebp),%eax
    438b:	8b 40 04             	mov    0x4(%eax),%eax
    438e:	c1 e0 03             	shl    $0x3,%eax
    4391:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    4394:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4397:	8b 55 ec             	mov    -0x14(%ebp),%edx
    439a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    439d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    43a0:	a3 88 63 00 00       	mov    %eax,0x6388
      return (void*)(p + 1);
    43a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    43a8:	83 c0 08             	add    $0x8,%eax
    43ab:	eb 3b                	jmp    43e8 <malloc+0xe1>
    }
    if(p == freep)
    43ad:	a1 88 63 00 00       	mov    0x6388,%eax
    43b2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    43b5:	75 1e                	jne    43d5 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
    43b7:	83 ec 0c             	sub    $0xc,%esp
    43ba:	ff 75 ec             	pushl  -0x14(%ebp)
    43bd:	e8 e5 fe ff ff       	call   42a7 <morecore>
    43c2:	83 c4 10             	add    $0x10,%esp
    43c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    43c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    43cc:	75 07                	jne    43d5 <malloc+0xce>
        return 0;
    43ce:	b8 00 00 00 00       	mov    $0x0,%eax
    43d3:	eb 13                	jmp    43e8 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    43d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    43d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    43db:	8b 45 f4             	mov    -0xc(%ebp),%eax
    43de:	8b 00                	mov    (%eax),%eax
    43e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    43e3:	e9 6d ff ff ff       	jmp    4355 <malloc+0x4e>
}
    43e8:	c9                   	leave  
    43e9:	c3                   	ret    
