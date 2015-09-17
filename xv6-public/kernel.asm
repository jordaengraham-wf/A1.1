
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 70 c6 10 80       	mov    $0x8010c670,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 21 38 10 80       	mov    $0x80103821,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	83 ec 08             	sub    $0x8,%esp
8010003d:	68 88 84 10 80       	push   $0x80108488
80100042:	68 80 c6 10 80       	push   $0x8010c680
80100047:	e8 0e 4f 00 00       	call   80104f5a <initlock>
8010004c:	83 c4 10             	add    $0x10,%esp

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004f:	c7 05 90 05 11 80 84 	movl   $0x80110584,0x80110590
80100056:	05 11 80 
  bcache.head.next = &bcache.head;
80100059:	c7 05 94 05 11 80 84 	movl   $0x80110584,0x80110594
80100060:	05 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100063:	c7 45 f4 b4 c6 10 80 	movl   $0x8010c6b4,-0xc(%ebp)
8010006a:	eb 3a                	jmp    801000a6 <binit+0x72>
    b->next = bcache.head.next;
8010006c:	8b 15 94 05 11 80    	mov    0x80110594,%edx
80100072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100075:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007b:	c7 40 0c 84 05 11 80 	movl   $0x80110584,0xc(%eax)
    b->dev = -1;
80100082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100085:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008c:	a1 94 05 11 80       	mov    0x80110594,%eax
80100091:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100094:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100097:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010009a:	a3 94 05 11 80       	mov    %eax,0x80110594

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009f:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a6:	81 7d f4 84 05 11 80 	cmpl   $0x80110584,-0xc(%ebp)
801000ad:	72 bd                	jb     8010006c <binit+0x38>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000af:	c9                   	leave  
801000b0:	c3                   	ret    

801000b1 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000b1:	55                   	push   %ebp
801000b2:	89 e5                	mov    %esp,%ebp
801000b4:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b7:	83 ec 0c             	sub    $0xc,%esp
801000ba:	68 80 c6 10 80       	push   $0x8010c680
801000bf:	e8 b7 4e 00 00       	call   80104f7b <acquire>
801000c4:	83 c4 10             	add    $0x10,%esp

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c7:	a1 94 05 11 80       	mov    0x80110594,%eax
801000cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000cf:	eb 67                	jmp    80100138 <bget+0x87>
    if(b->dev == dev && b->blockno == blockno){
801000d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000d4:	8b 40 04             	mov    0x4(%eax),%eax
801000d7:	3b 45 08             	cmp    0x8(%ebp),%eax
801000da:	75 53                	jne    8010012f <bget+0x7e>
801000dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000df:	8b 40 08             	mov    0x8(%eax),%eax
801000e2:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e5:	75 48                	jne    8010012f <bget+0x7e>
      if(!(b->flags & B_BUSY)){
801000e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ea:	8b 00                	mov    (%eax),%eax
801000ec:	83 e0 01             	and    $0x1,%eax
801000ef:	85 c0                	test   %eax,%eax
801000f1:	75 27                	jne    8010011a <bget+0x69>
        b->flags |= B_BUSY;
801000f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f6:	8b 00                	mov    (%eax),%eax
801000f8:	83 c8 01             	or     $0x1,%eax
801000fb:	89 c2                	mov    %eax,%edx
801000fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100100:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
80100102:	83 ec 0c             	sub    $0xc,%esp
80100105:	68 80 c6 10 80       	push   $0x8010c680
8010010a:	e8 d2 4e 00 00       	call   80104fe1 <release>
8010010f:	83 c4 10             	add    $0x10,%esp
        return b;
80100112:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100115:	e9 98 00 00 00       	jmp    801001b2 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011a:	83 ec 08             	sub    $0x8,%esp
8010011d:	68 80 c6 10 80       	push   $0x8010c680
80100122:	ff 75 f4             	pushl  -0xc(%ebp)
80100125:	e8 61 4b 00 00       	call   80104c8b <sleep>
8010012a:	83 c4 10             	add    $0x10,%esp
      goto loop;
8010012d:	eb 98                	jmp    801000c7 <bget+0x16>

  acquire(&bcache.lock);

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
8010012f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100132:	8b 40 10             	mov    0x10(%eax),%eax
80100135:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100138:	81 7d f4 84 05 11 80 	cmpl   $0x80110584,-0xc(%ebp)
8010013f:	75 90                	jne    801000d1 <bget+0x20>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100141:	a1 90 05 11 80       	mov    0x80110590,%eax
80100146:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100149:	eb 51                	jmp    8010019c <bget+0xeb>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
8010014b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010014e:	8b 00                	mov    (%eax),%eax
80100150:	83 e0 01             	and    $0x1,%eax
80100153:	85 c0                	test   %eax,%eax
80100155:	75 3c                	jne    80100193 <bget+0xe2>
80100157:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015a:	8b 00                	mov    (%eax),%eax
8010015c:	83 e0 04             	and    $0x4,%eax
8010015f:	85 c0                	test   %eax,%eax
80100161:	75 30                	jne    80100193 <bget+0xe2>
      b->dev = dev;
80100163:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100166:	8b 55 08             	mov    0x8(%ebp),%edx
80100169:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
8010016c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010016f:	8b 55 0c             	mov    0xc(%ebp),%edx
80100172:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
80100175:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100178:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
8010017e:	83 ec 0c             	sub    $0xc,%esp
80100181:	68 80 c6 10 80       	push   $0x8010c680
80100186:	e8 56 4e 00 00       	call   80104fe1 <release>
8010018b:	83 c4 10             	add    $0x10,%esp
      return b;
8010018e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100191:	eb 1f                	jmp    801001b2 <bget+0x101>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100193:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100196:	8b 40 0c             	mov    0xc(%eax),%eax
80100199:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010019c:	81 7d f4 84 05 11 80 	cmpl   $0x80110584,-0xc(%ebp)
801001a3:	75 a6                	jne    8010014b <bget+0x9a>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
801001a5:	83 ec 0c             	sub    $0xc,%esp
801001a8:	68 8f 84 10 80       	push   $0x8010848f
801001ad:	e8 aa 03 00 00       	call   8010055c <panic>
}
801001b2:	c9                   	leave  
801001b3:	c3                   	ret    

801001b4 <bread>:

// Return a B_BUSY buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801001b4:	55                   	push   %ebp
801001b5:	89 e5                	mov    %esp,%ebp
801001b7:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, blockno);
801001ba:	83 ec 08             	sub    $0x8,%esp
801001bd:	ff 75 0c             	pushl  0xc(%ebp)
801001c0:	ff 75 08             	pushl  0x8(%ebp)
801001c3:	e8 e9 fe ff ff       	call   801000b1 <bget>
801001c8:	83 c4 10             	add    $0x10,%esp
801001cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID)) {
801001ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d1:	8b 00                	mov    (%eax),%eax
801001d3:	83 e0 02             	and    $0x2,%eax
801001d6:	85 c0                	test   %eax,%eax
801001d8:	75 0e                	jne    801001e8 <bread+0x34>
    iderw(b);
801001da:	83 ec 0c             	sub    $0xc,%esp
801001dd:	ff 75 f4             	pushl  -0xc(%ebp)
801001e0:	e8 d4 26 00 00       	call   801028b9 <iderw>
801001e5:	83 c4 10             	add    $0x10,%esp
  }
  return b;
801001e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001eb:	c9                   	leave  
801001ec:	c3                   	ret    

801001ed <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001ed:	55                   	push   %ebp
801001ee:	89 e5                	mov    %esp,%ebp
801001f0:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
801001f3:	8b 45 08             	mov    0x8(%ebp),%eax
801001f6:	8b 00                	mov    (%eax),%eax
801001f8:	83 e0 01             	and    $0x1,%eax
801001fb:	85 c0                	test   %eax,%eax
801001fd:	75 0d                	jne    8010020c <bwrite+0x1f>
    panic("bwrite");
801001ff:	83 ec 0c             	sub    $0xc,%esp
80100202:	68 a0 84 10 80       	push   $0x801084a0
80100207:	e8 50 03 00 00       	call   8010055c <panic>
  b->flags |= B_DIRTY;
8010020c:	8b 45 08             	mov    0x8(%ebp),%eax
8010020f:	8b 00                	mov    (%eax),%eax
80100211:	83 c8 04             	or     $0x4,%eax
80100214:	89 c2                	mov    %eax,%edx
80100216:	8b 45 08             	mov    0x8(%ebp),%eax
80100219:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010021b:	83 ec 0c             	sub    $0xc,%esp
8010021e:	ff 75 08             	pushl  0x8(%ebp)
80100221:	e8 93 26 00 00       	call   801028b9 <iderw>
80100226:	83 c4 10             	add    $0x10,%esp
}
80100229:	c9                   	leave  
8010022a:	c3                   	ret    

8010022b <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
8010022b:	55                   	push   %ebp
8010022c:	89 e5                	mov    %esp,%ebp
8010022e:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
80100231:	8b 45 08             	mov    0x8(%ebp),%eax
80100234:	8b 00                	mov    (%eax),%eax
80100236:	83 e0 01             	and    $0x1,%eax
80100239:	85 c0                	test   %eax,%eax
8010023b:	75 0d                	jne    8010024a <brelse+0x1f>
    panic("brelse");
8010023d:	83 ec 0c             	sub    $0xc,%esp
80100240:	68 a7 84 10 80       	push   $0x801084a7
80100245:	e8 12 03 00 00       	call   8010055c <panic>

  acquire(&bcache.lock);
8010024a:	83 ec 0c             	sub    $0xc,%esp
8010024d:	68 80 c6 10 80       	push   $0x8010c680
80100252:	e8 24 4d 00 00       	call   80104f7b <acquire>
80100257:	83 c4 10             	add    $0x10,%esp

  b->next->prev = b->prev;
8010025a:	8b 45 08             	mov    0x8(%ebp),%eax
8010025d:	8b 40 10             	mov    0x10(%eax),%eax
80100260:	8b 55 08             	mov    0x8(%ebp),%edx
80100263:	8b 52 0c             	mov    0xc(%edx),%edx
80100266:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
80100269:	8b 45 08             	mov    0x8(%ebp),%eax
8010026c:	8b 40 0c             	mov    0xc(%eax),%eax
8010026f:	8b 55 08             	mov    0x8(%ebp),%edx
80100272:	8b 52 10             	mov    0x10(%edx),%edx
80100275:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
80100278:	8b 15 94 05 11 80    	mov    0x80110594,%edx
8010027e:	8b 45 08             	mov    0x8(%ebp),%eax
80100281:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
80100284:	8b 45 08             	mov    0x8(%ebp),%eax
80100287:	c7 40 0c 84 05 11 80 	movl   $0x80110584,0xc(%eax)
  bcache.head.next->prev = b;
8010028e:	a1 94 05 11 80       	mov    0x80110594,%eax
80100293:	8b 55 08             	mov    0x8(%ebp),%edx
80100296:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
80100299:	8b 45 08             	mov    0x8(%ebp),%eax
8010029c:	a3 94 05 11 80       	mov    %eax,0x80110594

  b->flags &= ~B_BUSY;
801002a1:	8b 45 08             	mov    0x8(%ebp),%eax
801002a4:	8b 00                	mov    (%eax),%eax
801002a6:	83 e0 fe             	and    $0xfffffffe,%eax
801002a9:	89 c2                	mov    %eax,%edx
801002ab:	8b 45 08             	mov    0x8(%ebp),%eax
801002ae:	89 10                	mov    %edx,(%eax)
  wakeup(b);
801002b0:	83 ec 0c             	sub    $0xc,%esp
801002b3:	ff 75 08             	pushl  0x8(%ebp)
801002b6:	e8 b9 4a 00 00       	call   80104d74 <wakeup>
801002bb:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002be:	83 ec 0c             	sub    $0xc,%esp
801002c1:	68 80 c6 10 80       	push   $0x8010c680
801002c6:	e8 16 4d 00 00       	call   80104fe1 <release>
801002cb:	83 c4 10             	add    $0x10,%esp
}
801002ce:	c9                   	leave  
801002cf:	c3                   	ret    

801002d0 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002d0:	55                   	push   %ebp
801002d1:	89 e5                	mov    %esp,%ebp
801002d3:	83 ec 14             	sub    $0x14,%esp
801002d6:	8b 45 08             	mov    0x8(%ebp),%eax
801002d9:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002dd:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002e1:	89 c2                	mov    %eax,%edx
801002e3:	ec                   	in     (%dx),%al
801002e4:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002e7:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002eb:	c9                   	leave  
801002ec:	c3                   	ret    

801002ed <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002ed:	55                   	push   %ebp
801002ee:	89 e5                	mov    %esp,%ebp
801002f0:	83 ec 08             	sub    $0x8,%esp
801002f3:	8b 55 08             	mov    0x8(%ebp),%edx
801002f6:	8b 45 0c             	mov    0xc(%ebp),%eax
801002f9:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801002fd:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100300:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80100304:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80100308:	ee                   	out    %al,(%dx)
}
80100309:	c9                   	leave  
8010030a:	c3                   	ret    

8010030b <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
8010030b:	55                   	push   %ebp
8010030c:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
8010030e:	fa                   	cli    
}
8010030f:	5d                   	pop    %ebp
80100310:	c3                   	ret    

80100311 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100311:	55                   	push   %ebp
80100312:	89 e5                	mov    %esp,%ebp
80100314:	53                   	push   %ebx
80100315:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100318:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010031c:	74 1c                	je     8010033a <printint+0x29>
8010031e:	8b 45 08             	mov    0x8(%ebp),%eax
80100321:	c1 e8 1f             	shr    $0x1f,%eax
80100324:	0f b6 c0             	movzbl %al,%eax
80100327:	89 45 10             	mov    %eax,0x10(%ebp)
8010032a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010032e:	74 0a                	je     8010033a <printint+0x29>
    x = -xx;
80100330:	8b 45 08             	mov    0x8(%ebp),%eax
80100333:	f7 d8                	neg    %eax
80100335:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100338:	eb 06                	jmp    80100340 <printint+0x2f>
  else
    x = xx;
8010033a:	8b 45 08             	mov    0x8(%ebp),%eax
8010033d:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100340:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
80100347:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010034a:	8d 41 01             	lea    0x1(%ecx),%eax
8010034d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100350:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100353:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100356:	ba 00 00 00 00       	mov    $0x0,%edx
8010035b:	f7 f3                	div    %ebx
8010035d:	89 d0                	mov    %edx,%eax
8010035f:	0f b6 80 04 90 10 80 	movzbl -0x7fef6ffc(%eax),%eax
80100366:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
8010036a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010036d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100370:	ba 00 00 00 00       	mov    $0x0,%edx
80100375:	f7 f3                	div    %ebx
80100377:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010037a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010037e:	75 c7                	jne    80100347 <printint+0x36>

  if(sign)
80100380:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100384:	74 0e                	je     80100394 <printint+0x83>
    buf[i++] = '-';
80100386:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100389:	8d 50 01             	lea    0x1(%eax),%edx
8010038c:	89 55 f4             	mov    %edx,-0xc(%ebp)
8010038f:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
80100394:	eb 1a                	jmp    801003b0 <printint+0x9f>
    consputc(buf[i]);
80100396:	8d 55 e0             	lea    -0x20(%ebp),%edx
80100399:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010039c:	01 d0                	add    %edx,%eax
8010039e:	0f b6 00             	movzbl (%eax),%eax
801003a1:	0f be c0             	movsbl %al,%eax
801003a4:	83 ec 0c             	sub    $0xc,%esp
801003a7:	50                   	push   %eax
801003a8:	e8 be 03 00 00       	call   8010076b <consputc>
801003ad:	83 c4 10             	add    $0x10,%esp
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801003b0:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003b8:	79 dc                	jns    80100396 <printint+0x85>
    consputc(buf[i]);
}
801003ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801003bd:	c9                   	leave  
801003be:	c3                   	ret    

801003bf <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003bf:	55                   	push   %ebp
801003c0:	89 e5                	mov    %esp,%ebp
801003c2:	83 ec 28             	sub    $0x28,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003c5:	a1 14 b6 10 80       	mov    0x8010b614,%eax
801003ca:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003cd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003d1:	74 10                	je     801003e3 <cprintf+0x24>
    acquire(&cons.lock);
801003d3:	83 ec 0c             	sub    $0xc,%esp
801003d6:	68 e0 b5 10 80       	push   $0x8010b5e0
801003db:	e8 9b 4b 00 00       	call   80104f7b <acquire>
801003e0:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003e3:	8b 45 08             	mov    0x8(%ebp),%eax
801003e6:	85 c0                	test   %eax,%eax
801003e8:	75 0d                	jne    801003f7 <cprintf+0x38>
    panic("null fmt");
801003ea:	83 ec 0c             	sub    $0xc,%esp
801003ed:	68 ae 84 10 80       	push   $0x801084ae
801003f2:	e8 65 01 00 00       	call   8010055c <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003f7:	8d 45 0c             	lea    0xc(%ebp),%eax
801003fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801003fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100404:	e9 1b 01 00 00       	jmp    80100524 <cprintf+0x165>
    if(c != '%'){
80100409:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
8010040d:	74 13                	je     80100422 <cprintf+0x63>
      consputc(c);
8010040f:	83 ec 0c             	sub    $0xc,%esp
80100412:	ff 75 e4             	pushl  -0x1c(%ebp)
80100415:	e8 51 03 00 00       	call   8010076b <consputc>
8010041a:	83 c4 10             	add    $0x10,%esp
      continue;
8010041d:	e9 fe 00 00 00       	jmp    80100520 <cprintf+0x161>
    }
    c = fmt[++i] & 0xff;
80100422:	8b 55 08             	mov    0x8(%ebp),%edx
80100425:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100429:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010042c:	01 d0                	add    %edx,%eax
8010042e:	0f b6 00             	movzbl (%eax),%eax
80100431:	0f be c0             	movsbl %al,%eax
80100434:	25 ff 00 00 00       	and    $0xff,%eax
80100439:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
8010043c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100440:	75 05                	jne    80100447 <cprintf+0x88>
      break;
80100442:	e9 fd 00 00 00       	jmp    80100544 <cprintf+0x185>
    switch(c){
80100447:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010044a:	83 f8 70             	cmp    $0x70,%eax
8010044d:	74 47                	je     80100496 <cprintf+0xd7>
8010044f:	83 f8 70             	cmp    $0x70,%eax
80100452:	7f 13                	jg     80100467 <cprintf+0xa8>
80100454:	83 f8 25             	cmp    $0x25,%eax
80100457:	0f 84 98 00 00 00    	je     801004f5 <cprintf+0x136>
8010045d:	83 f8 64             	cmp    $0x64,%eax
80100460:	74 14                	je     80100476 <cprintf+0xb7>
80100462:	e9 9d 00 00 00       	jmp    80100504 <cprintf+0x145>
80100467:	83 f8 73             	cmp    $0x73,%eax
8010046a:	74 47                	je     801004b3 <cprintf+0xf4>
8010046c:	83 f8 78             	cmp    $0x78,%eax
8010046f:	74 25                	je     80100496 <cprintf+0xd7>
80100471:	e9 8e 00 00 00       	jmp    80100504 <cprintf+0x145>
    case 'd':
      printint(*argp++, 10, 1);
80100476:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100479:	8d 50 04             	lea    0x4(%eax),%edx
8010047c:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010047f:	8b 00                	mov    (%eax),%eax
80100481:	83 ec 04             	sub    $0x4,%esp
80100484:	6a 01                	push   $0x1
80100486:	6a 0a                	push   $0xa
80100488:	50                   	push   %eax
80100489:	e8 83 fe ff ff       	call   80100311 <printint>
8010048e:	83 c4 10             	add    $0x10,%esp
      break;
80100491:	e9 8a 00 00 00       	jmp    80100520 <cprintf+0x161>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
80100496:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100499:	8d 50 04             	lea    0x4(%eax),%edx
8010049c:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010049f:	8b 00                	mov    (%eax),%eax
801004a1:	83 ec 04             	sub    $0x4,%esp
801004a4:	6a 00                	push   $0x0
801004a6:	6a 10                	push   $0x10
801004a8:	50                   	push   %eax
801004a9:	e8 63 fe ff ff       	call   80100311 <printint>
801004ae:	83 c4 10             	add    $0x10,%esp
      break;
801004b1:	eb 6d                	jmp    80100520 <cprintf+0x161>
    case 's':
      if((s = (char*)*argp++) == 0)
801004b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004b6:	8d 50 04             	lea    0x4(%eax),%edx
801004b9:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004bc:	8b 00                	mov    (%eax),%eax
801004be:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004c1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004c5:	75 07                	jne    801004ce <cprintf+0x10f>
        s = "(null)";
801004c7:	c7 45 ec b7 84 10 80 	movl   $0x801084b7,-0x14(%ebp)
      for(; *s; s++)
801004ce:	eb 19                	jmp    801004e9 <cprintf+0x12a>
        consputc(*s);
801004d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004d3:	0f b6 00             	movzbl (%eax),%eax
801004d6:	0f be c0             	movsbl %al,%eax
801004d9:	83 ec 0c             	sub    $0xc,%esp
801004dc:	50                   	push   %eax
801004dd:	e8 89 02 00 00       	call   8010076b <consputc>
801004e2:	83 c4 10             	add    $0x10,%esp
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004e5:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801004e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004ec:	0f b6 00             	movzbl (%eax),%eax
801004ef:	84 c0                	test   %al,%al
801004f1:	75 dd                	jne    801004d0 <cprintf+0x111>
        consputc(*s);
      break;
801004f3:	eb 2b                	jmp    80100520 <cprintf+0x161>
    case '%':
      consputc('%');
801004f5:	83 ec 0c             	sub    $0xc,%esp
801004f8:	6a 25                	push   $0x25
801004fa:	e8 6c 02 00 00       	call   8010076b <consputc>
801004ff:	83 c4 10             	add    $0x10,%esp
      break;
80100502:	eb 1c                	jmp    80100520 <cprintf+0x161>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100504:	83 ec 0c             	sub    $0xc,%esp
80100507:	6a 25                	push   $0x25
80100509:	e8 5d 02 00 00       	call   8010076b <consputc>
8010050e:	83 c4 10             	add    $0x10,%esp
      consputc(c);
80100511:	83 ec 0c             	sub    $0xc,%esp
80100514:	ff 75 e4             	pushl  -0x1c(%ebp)
80100517:	e8 4f 02 00 00       	call   8010076b <consputc>
8010051c:	83 c4 10             	add    $0x10,%esp
      break;
8010051f:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100520:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100524:	8b 55 08             	mov    0x8(%ebp),%edx
80100527:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010052a:	01 d0                	add    %edx,%eax
8010052c:	0f b6 00             	movzbl (%eax),%eax
8010052f:	0f be c0             	movsbl %al,%eax
80100532:	25 ff 00 00 00       	and    $0xff,%eax
80100537:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010053a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
8010053e:	0f 85 c5 fe ff ff    	jne    80100409 <cprintf+0x4a>
      consputc(c);
      break;
    }
  }

  if(locking)
80100544:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100548:	74 10                	je     8010055a <cprintf+0x19b>
    release(&cons.lock);
8010054a:	83 ec 0c             	sub    $0xc,%esp
8010054d:	68 e0 b5 10 80       	push   $0x8010b5e0
80100552:	e8 8a 4a 00 00       	call   80104fe1 <release>
80100557:	83 c4 10             	add    $0x10,%esp
}
8010055a:	c9                   	leave  
8010055b:	c3                   	ret    

8010055c <panic>:

void
panic(char *s)
{
8010055c:	55                   	push   %ebp
8010055d:	89 e5                	mov    %esp,%ebp
8010055f:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];
  
  cli();
80100562:	e8 a4 fd ff ff       	call   8010030b <cli>
  cons.locking = 0;
80100567:	c7 05 14 b6 10 80 00 	movl   $0x0,0x8010b614
8010056e:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
80100571:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100577:	0f b6 00             	movzbl (%eax),%eax
8010057a:	0f b6 c0             	movzbl %al,%eax
8010057d:	83 ec 08             	sub    $0x8,%esp
80100580:	50                   	push   %eax
80100581:	68 be 84 10 80       	push   $0x801084be
80100586:	e8 34 fe ff ff       	call   801003bf <cprintf>
8010058b:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
8010058e:	8b 45 08             	mov    0x8(%ebp),%eax
80100591:	83 ec 0c             	sub    $0xc,%esp
80100594:	50                   	push   %eax
80100595:	e8 25 fe ff ff       	call   801003bf <cprintf>
8010059a:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
8010059d:	83 ec 0c             	sub    $0xc,%esp
801005a0:	68 cd 84 10 80       	push   $0x801084cd
801005a5:	e8 15 fe ff ff       	call   801003bf <cprintf>
801005aa:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005ad:	83 ec 08             	sub    $0x8,%esp
801005b0:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005b3:	50                   	push   %eax
801005b4:	8d 45 08             	lea    0x8(%ebp),%eax
801005b7:	50                   	push   %eax
801005b8:	e8 75 4a 00 00       	call   80105032 <getcallerpcs>
801005bd:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005c7:	eb 1c                	jmp    801005e5 <panic+0x89>
    cprintf(" %p", pcs[i]);
801005c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005cc:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005d0:	83 ec 08             	sub    $0x8,%esp
801005d3:	50                   	push   %eax
801005d4:	68 cf 84 10 80       	push   $0x801084cf
801005d9:	e8 e1 fd ff ff       	call   801003bf <cprintf>
801005de:	83 c4 10             	add    $0x10,%esp
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005e1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005e5:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005e9:	7e de                	jle    801005c9 <panic+0x6d>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005eb:	c7 05 c0 b5 10 80 01 	movl   $0x1,0x8010b5c0
801005f2:	00 00 00 
  for(;;)
    ;
801005f5:	eb fe                	jmp    801005f5 <panic+0x99>

801005f7 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
801005f7:	55                   	push   %ebp
801005f8:	89 e5                	mov    %esp,%ebp
801005fa:	83 ec 18             	sub    $0x18,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
801005fd:	6a 0e                	push   $0xe
801005ff:	68 d4 03 00 00       	push   $0x3d4
80100604:	e8 e4 fc ff ff       	call   801002ed <outb>
80100609:	83 c4 08             	add    $0x8,%esp
  pos = inb(CRTPORT+1) << 8;
8010060c:	68 d5 03 00 00       	push   $0x3d5
80100611:	e8 ba fc ff ff       	call   801002d0 <inb>
80100616:	83 c4 04             	add    $0x4,%esp
80100619:	0f b6 c0             	movzbl %al,%eax
8010061c:	c1 e0 08             	shl    $0x8,%eax
8010061f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
80100622:	6a 0f                	push   $0xf
80100624:	68 d4 03 00 00       	push   $0x3d4
80100629:	e8 bf fc ff ff       	call   801002ed <outb>
8010062e:	83 c4 08             	add    $0x8,%esp
  pos |= inb(CRTPORT+1);
80100631:	68 d5 03 00 00       	push   $0x3d5
80100636:	e8 95 fc ff ff       	call   801002d0 <inb>
8010063b:	83 c4 04             	add    $0x4,%esp
8010063e:	0f b6 c0             	movzbl %al,%eax
80100641:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
80100644:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100648:	75 30                	jne    8010067a <cgaputc+0x83>
    pos += 80 - pos%80;
8010064a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010064d:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100652:	89 c8                	mov    %ecx,%eax
80100654:	f7 ea                	imul   %edx
80100656:	c1 fa 05             	sar    $0x5,%edx
80100659:	89 c8                	mov    %ecx,%eax
8010065b:	c1 f8 1f             	sar    $0x1f,%eax
8010065e:	29 c2                	sub    %eax,%edx
80100660:	89 d0                	mov    %edx,%eax
80100662:	c1 e0 02             	shl    $0x2,%eax
80100665:	01 d0                	add    %edx,%eax
80100667:	c1 e0 04             	shl    $0x4,%eax
8010066a:	29 c1                	sub    %eax,%ecx
8010066c:	89 ca                	mov    %ecx,%edx
8010066e:	b8 50 00 00 00       	mov    $0x50,%eax
80100673:	29 d0                	sub    %edx,%eax
80100675:	01 45 f4             	add    %eax,-0xc(%ebp)
80100678:	eb 34                	jmp    801006ae <cgaputc+0xb7>
  else if(c == BACKSPACE){
8010067a:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100681:	75 0c                	jne    8010068f <cgaputc+0x98>
    if(pos > 0) --pos;
80100683:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100687:	7e 25                	jle    801006ae <cgaputc+0xb7>
80100689:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
8010068d:	eb 1f                	jmp    801006ae <cgaputc+0xb7>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010068f:	8b 0d 00 90 10 80    	mov    0x80109000,%ecx
80100695:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100698:	8d 50 01             	lea    0x1(%eax),%edx
8010069b:	89 55 f4             	mov    %edx,-0xc(%ebp)
8010069e:	01 c0                	add    %eax,%eax
801006a0:	01 c8                	add    %ecx,%eax
801006a2:	8b 55 08             	mov    0x8(%ebp),%edx
801006a5:	0f b6 d2             	movzbl %dl,%edx
801006a8:	80 ce 07             	or     $0x7,%dh
801006ab:	66 89 10             	mov    %dx,(%eax)
  
  if((pos/80) >= 24){  // Scroll up.
801006ae:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006b5:	7e 4c                	jle    80100703 <cgaputc+0x10c>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801006b7:	a1 00 90 10 80       	mov    0x80109000,%eax
801006bc:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006c2:	a1 00 90 10 80       	mov    0x80109000,%eax
801006c7:	83 ec 04             	sub    $0x4,%esp
801006ca:	68 60 0e 00 00       	push   $0xe60
801006cf:	52                   	push   %edx
801006d0:	50                   	push   %eax
801006d1:	e8 c0 4b 00 00       	call   80105296 <memmove>
801006d6:	83 c4 10             	add    $0x10,%esp
    pos -= 80;
801006d9:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006dd:	b8 80 07 00 00       	mov    $0x780,%eax
801006e2:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006e5:	8d 14 00             	lea    (%eax,%eax,1),%edx
801006e8:	a1 00 90 10 80       	mov    0x80109000,%eax
801006ed:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801006f0:	01 c9                	add    %ecx,%ecx
801006f2:	01 c8                	add    %ecx,%eax
801006f4:	83 ec 04             	sub    $0x4,%esp
801006f7:	52                   	push   %edx
801006f8:	6a 00                	push   $0x0
801006fa:	50                   	push   %eax
801006fb:	e8 d7 4a 00 00       	call   801051d7 <memset>
80100700:	83 c4 10             	add    $0x10,%esp
  }
  
  outb(CRTPORT, 14);
80100703:	83 ec 08             	sub    $0x8,%esp
80100706:	6a 0e                	push   $0xe
80100708:	68 d4 03 00 00       	push   $0x3d4
8010070d:	e8 db fb ff ff       	call   801002ed <outb>
80100712:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos>>8);
80100715:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100718:	c1 f8 08             	sar    $0x8,%eax
8010071b:	0f b6 c0             	movzbl %al,%eax
8010071e:	83 ec 08             	sub    $0x8,%esp
80100721:	50                   	push   %eax
80100722:	68 d5 03 00 00       	push   $0x3d5
80100727:	e8 c1 fb ff ff       	call   801002ed <outb>
8010072c:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT, 15);
8010072f:	83 ec 08             	sub    $0x8,%esp
80100732:	6a 0f                	push   $0xf
80100734:	68 d4 03 00 00       	push   $0x3d4
80100739:	e8 af fb ff ff       	call   801002ed <outb>
8010073e:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos);
80100741:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100744:	0f b6 c0             	movzbl %al,%eax
80100747:	83 ec 08             	sub    $0x8,%esp
8010074a:	50                   	push   %eax
8010074b:	68 d5 03 00 00       	push   $0x3d5
80100750:	e8 98 fb ff ff       	call   801002ed <outb>
80100755:	83 c4 10             	add    $0x10,%esp
  crt[pos] = ' ' | 0x0700;
80100758:	a1 00 90 10 80       	mov    0x80109000,%eax
8010075d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100760:	01 d2                	add    %edx,%edx
80100762:	01 d0                	add    %edx,%eax
80100764:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
80100769:	c9                   	leave  
8010076a:	c3                   	ret    

8010076b <consputc>:

void
consputc(int c)
{
8010076b:	55                   	push   %ebp
8010076c:	89 e5                	mov    %esp,%ebp
8010076e:	83 ec 08             	sub    $0x8,%esp
  if(panicked){
80100771:	a1 c0 b5 10 80       	mov    0x8010b5c0,%eax
80100776:	85 c0                	test   %eax,%eax
80100778:	74 07                	je     80100781 <consputc+0x16>
    cli();
8010077a:	e8 8c fb ff ff       	call   8010030b <cli>
    for(;;)
      ;
8010077f:	eb fe                	jmp    8010077f <consputc+0x14>
  }

  if(c == BACKSPACE){
80100781:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100788:	75 29                	jne    801007b3 <consputc+0x48>
    uartputc('\b'); uartputc(' '); uartputc('\b');
8010078a:	83 ec 0c             	sub    $0xc,%esp
8010078d:	6a 08                	push   $0x8
8010078f:	e8 88 63 00 00       	call   80106b1c <uartputc>
80100794:	83 c4 10             	add    $0x10,%esp
80100797:	83 ec 0c             	sub    $0xc,%esp
8010079a:	6a 20                	push   $0x20
8010079c:	e8 7b 63 00 00       	call   80106b1c <uartputc>
801007a1:	83 c4 10             	add    $0x10,%esp
801007a4:	83 ec 0c             	sub    $0xc,%esp
801007a7:	6a 08                	push   $0x8
801007a9:	e8 6e 63 00 00       	call   80106b1c <uartputc>
801007ae:	83 c4 10             	add    $0x10,%esp
801007b1:	eb 0e                	jmp    801007c1 <consputc+0x56>
  } else
    uartputc(c);
801007b3:	83 ec 0c             	sub    $0xc,%esp
801007b6:	ff 75 08             	pushl  0x8(%ebp)
801007b9:	e8 5e 63 00 00       	call   80106b1c <uartputc>
801007be:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
801007c1:	83 ec 0c             	sub    $0xc,%esp
801007c4:	ff 75 08             	pushl  0x8(%ebp)
801007c7:	e8 2b fe ff ff       	call   801005f7 <cgaputc>
801007cc:	83 c4 10             	add    $0x10,%esp
}
801007cf:	c9                   	leave  
801007d0:	c3                   	ret    

801007d1 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007d1:	55                   	push   %ebp
801007d2:	89 e5                	mov    %esp,%ebp
801007d4:	83 ec 18             	sub    $0x18,%esp
  int c;

  acquire(&input.lock);
801007d7:	83 ec 0c             	sub    $0xc,%esp
801007da:	68 c0 07 11 80       	push   $0x801107c0
801007df:	e8 97 47 00 00       	call   80104f7b <acquire>
801007e4:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
801007e7:	e9 3a 01 00 00       	jmp    80100926 <consoleintr+0x155>
    switch(c){
801007ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801007ef:	83 f8 10             	cmp    $0x10,%eax
801007f2:	74 1e                	je     80100812 <consoleintr+0x41>
801007f4:	83 f8 10             	cmp    $0x10,%eax
801007f7:	7f 0a                	jg     80100803 <consoleintr+0x32>
801007f9:	83 f8 08             	cmp    $0x8,%eax
801007fc:	74 65                	je     80100863 <consoleintr+0x92>
801007fe:	e9 91 00 00 00       	jmp    80100894 <consoleintr+0xc3>
80100803:	83 f8 15             	cmp    $0x15,%eax
80100806:	74 31                	je     80100839 <consoleintr+0x68>
80100808:	83 f8 7f             	cmp    $0x7f,%eax
8010080b:	74 56                	je     80100863 <consoleintr+0x92>
8010080d:	e9 82 00 00 00       	jmp    80100894 <consoleintr+0xc3>
    case C('P'):  // Process listing.
      procdump();
80100812:	e8 17 46 00 00       	call   80104e2e <procdump>
      break;
80100817:	e9 0a 01 00 00       	jmp    80100926 <consoleintr+0x155>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
8010081c:	a1 7c 08 11 80       	mov    0x8011087c,%eax
80100821:	83 e8 01             	sub    $0x1,%eax
80100824:	a3 7c 08 11 80       	mov    %eax,0x8011087c
        consputc(BACKSPACE);
80100829:	83 ec 0c             	sub    $0xc,%esp
8010082c:	68 00 01 00 00       	push   $0x100
80100831:	e8 35 ff ff ff       	call   8010076b <consputc>
80100836:	83 c4 10             	add    $0x10,%esp
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100839:	8b 15 7c 08 11 80    	mov    0x8011087c,%edx
8010083f:	a1 78 08 11 80       	mov    0x80110878,%eax
80100844:	39 c2                	cmp    %eax,%edx
80100846:	74 16                	je     8010085e <consoleintr+0x8d>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100848:	a1 7c 08 11 80       	mov    0x8011087c,%eax
8010084d:	83 e8 01             	sub    $0x1,%eax
80100850:	83 e0 7f             	and    $0x7f,%eax
80100853:	0f b6 80 f4 07 11 80 	movzbl -0x7feef80c(%eax),%eax
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010085a:	3c 0a                	cmp    $0xa,%al
8010085c:	75 be                	jne    8010081c <consoleintr+0x4b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
8010085e:	e9 c3 00 00 00       	jmp    80100926 <consoleintr+0x155>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100863:	8b 15 7c 08 11 80    	mov    0x8011087c,%edx
80100869:	a1 78 08 11 80       	mov    0x80110878,%eax
8010086e:	39 c2                	cmp    %eax,%edx
80100870:	74 1d                	je     8010088f <consoleintr+0xbe>
        input.e--;
80100872:	a1 7c 08 11 80       	mov    0x8011087c,%eax
80100877:	83 e8 01             	sub    $0x1,%eax
8010087a:	a3 7c 08 11 80       	mov    %eax,0x8011087c
        consputc(BACKSPACE);
8010087f:	83 ec 0c             	sub    $0xc,%esp
80100882:	68 00 01 00 00       	push   $0x100
80100887:	e8 df fe ff ff       	call   8010076b <consputc>
8010088c:	83 c4 10             	add    $0x10,%esp
      }
      break;
8010088f:	e9 92 00 00 00       	jmp    80100926 <consoleintr+0x155>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100894:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100898:	0f 84 87 00 00 00    	je     80100925 <consoleintr+0x154>
8010089e:	8b 15 7c 08 11 80    	mov    0x8011087c,%edx
801008a4:	a1 74 08 11 80       	mov    0x80110874,%eax
801008a9:	29 c2                	sub    %eax,%edx
801008ab:	89 d0                	mov    %edx,%eax
801008ad:	83 f8 7f             	cmp    $0x7f,%eax
801008b0:	77 73                	ja     80100925 <consoleintr+0x154>
        c = (c == '\r') ? '\n' : c;
801008b2:	83 7d f4 0d          	cmpl   $0xd,-0xc(%ebp)
801008b6:	74 05                	je     801008bd <consoleintr+0xec>
801008b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008bb:	eb 05                	jmp    801008c2 <consoleintr+0xf1>
801008bd:	b8 0a 00 00 00       	mov    $0xa,%eax
801008c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
801008c5:	a1 7c 08 11 80       	mov    0x8011087c,%eax
801008ca:	8d 50 01             	lea    0x1(%eax),%edx
801008cd:	89 15 7c 08 11 80    	mov    %edx,0x8011087c
801008d3:	83 e0 7f             	and    $0x7f,%eax
801008d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801008d9:	88 90 f4 07 11 80    	mov    %dl,-0x7feef80c(%eax)
        consputc(c);
801008df:	83 ec 0c             	sub    $0xc,%esp
801008e2:	ff 75 f4             	pushl  -0xc(%ebp)
801008e5:	e8 81 fe ff ff       	call   8010076b <consputc>
801008ea:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008ed:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
801008f1:	74 18                	je     8010090b <consoleintr+0x13a>
801008f3:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
801008f7:	74 12                	je     8010090b <consoleintr+0x13a>
801008f9:	a1 7c 08 11 80       	mov    0x8011087c,%eax
801008fe:	8b 15 74 08 11 80    	mov    0x80110874,%edx
80100904:	83 ea 80             	sub    $0xffffff80,%edx
80100907:	39 d0                	cmp    %edx,%eax
80100909:	75 1a                	jne    80100925 <consoleintr+0x154>
          input.w = input.e;
8010090b:	a1 7c 08 11 80       	mov    0x8011087c,%eax
80100910:	a3 78 08 11 80       	mov    %eax,0x80110878
          wakeup(&input.r);
80100915:	83 ec 0c             	sub    $0xc,%esp
80100918:	68 74 08 11 80       	push   $0x80110874
8010091d:	e8 52 44 00 00       	call   80104d74 <wakeup>
80100922:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
80100925:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c;

  acquire(&input.lock);
  while((c = getc()) >= 0){
80100926:	8b 45 08             	mov    0x8(%ebp),%eax
80100929:	ff d0                	call   *%eax
8010092b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010092e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100932:	0f 89 b4 fe ff ff    	jns    801007ec <consoleintr+0x1b>
        }
      }
      break;
    }
  }
  release(&input.lock);
80100938:	83 ec 0c             	sub    $0xc,%esp
8010093b:	68 c0 07 11 80       	push   $0x801107c0
80100940:	e8 9c 46 00 00       	call   80104fe1 <release>
80100945:	83 c4 10             	add    $0x10,%esp
}
80100948:	c9                   	leave  
80100949:	c3                   	ret    

8010094a <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
8010094a:	55                   	push   %ebp
8010094b:	89 e5                	mov    %esp,%ebp
8010094d:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
80100950:	83 ec 0c             	sub    $0xc,%esp
80100953:	ff 75 08             	pushl  0x8(%ebp)
80100956:	e8 20 11 00 00       	call   80101a7b <iunlock>
8010095b:	83 c4 10             	add    $0x10,%esp
  target = n;
8010095e:	8b 45 10             	mov    0x10(%ebp),%eax
80100961:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&input.lock);
80100964:	83 ec 0c             	sub    $0xc,%esp
80100967:	68 c0 07 11 80       	push   $0x801107c0
8010096c:	e8 0a 46 00 00       	call   80104f7b <acquire>
80100971:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
80100974:	e9 b2 00 00 00       	jmp    80100a2b <consoleread+0xe1>
    while(input.r == input.w){
80100979:	eb 4a                	jmp    801009c5 <consoleread+0x7b>
      if(proc->killed){
8010097b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100981:	8b 40 24             	mov    0x24(%eax),%eax
80100984:	85 c0                	test   %eax,%eax
80100986:	74 28                	je     801009b0 <consoleread+0x66>
        release(&input.lock);
80100988:	83 ec 0c             	sub    $0xc,%esp
8010098b:	68 c0 07 11 80       	push   $0x801107c0
80100990:	e8 4c 46 00 00       	call   80104fe1 <release>
80100995:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
80100998:	83 ec 0c             	sub    $0xc,%esp
8010099b:	ff 75 08             	pushl  0x8(%ebp)
8010099e:	e8 7b 0f 00 00       	call   8010191e <ilock>
801009a3:	83 c4 10             	add    $0x10,%esp
        return -1;
801009a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801009ab:	e9 ad 00 00 00       	jmp    80100a5d <consoleread+0x113>
      }
      sleep(&input.r, &input.lock);
801009b0:	83 ec 08             	sub    $0x8,%esp
801009b3:	68 c0 07 11 80       	push   $0x801107c0
801009b8:	68 74 08 11 80       	push   $0x80110874
801009bd:	e8 c9 42 00 00       	call   80104c8b <sleep>
801009c2:	83 c4 10             	add    $0x10,%esp

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
801009c5:	8b 15 74 08 11 80    	mov    0x80110874,%edx
801009cb:	a1 78 08 11 80       	mov    0x80110878,%eax
801009d0:	39 c2                	cmp    %eax,%edx
801009d2:	74 a7                	je     8010097b <consoleread+0x31>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
801009d4:	a1 74 08 11 80       	mov    0x80110874,%eax
801009d9:	8d 50 01             	lea    0x1(%eax),%edx
801009dc:	89 15 74 08 11 80    	mov    %edx,0x80110874
801009e2:	83 e0 7f             	and    $0x7f,%eax
801009e5:	0f b6 80 f4 07 11 80 	movzbl -0x7feef80c(%eax),%eax
801009ec:	0f be c0             	movsbl %al,%eax
801009ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
801009f2:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
801009f6:	75 19                	jne    80100a11 <consoleread+0xc7>
      if(n < target){
801009f8:	8b 45 10             	mov    0x10(%ebp),%eax
801009fb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801009fe:	73 0f                	jae    80100a0f <consoleread+0xc5>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100a00:	a1 74 08 11 80       	mov    0x80110874,%eax
80100a05:	83 e8 01             	sub    $0x1,%eax
80100a08:	a3 74 08 11 80       	mov    %eax,0x80110874
      }
      break;
80100a0d:	eb 26                	jmp    80100a35 <consoleread+0xeb>
80100a0f:	eb 24                	jmp    80100a35 <consoleread+0xeb>
    }
    *dst++ = c;
80100a11:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a14:	8d 50 01             	lea    0x1(%eax),%edx
80100a17:	89 55 0c             	mov    %edx,0xc(%ebp)
80100a1a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100a1d:	88 10                	mov    %dl,(%eax)
    --n;
80100a1f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100a23:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100a27:	75 02                	jne    80100a2b <consoleread+0xe1>
      break;
80100a29:	eb 0a                	jmp    80100a35 <consoleread+0xeb>
  int c;

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
80100a2b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100a2f:	0f 8f 44 ff ff ff    	jg     80100979 <consoleread+0x2f>
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&input.lock);
80100a35:	83 ec 0c             	sub    $0xc,%esp
80100a38:	68 c0 07 11 80       	push   $0x801107c0
80100a3d:	e8 9f 45 00 00       	call   80104fe1 <release>
80100a42:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100a45:	83 ec 0c             	sub    $0xc,%esp
80100a48:	ff 75 08             	pushl  0x8(%ebp)
80100a4b:	e8 ce 0e 00 00       	call   8010191e <ilock>
80100a50:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100a53:	8b 45 10             	mov    0x10(%ebp),%eax
80100a56:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a59:	29 c2                	sub    %eax,%edx
80100a5b:	89 d0                	mov    %edx,%eax
}
80100a5d:	c9                   	leave  
80100a5e:	c3                   	ret    

80100a5f <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100a5f:	55                   	push   %ebp
80100a60:	89 e5                	mov    %esp,%ebp
80100a62:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100a65:	83 ec 0c             	sub    $0xc,%esp
80100a68:	ff 75 08             	pushl  0x8(%ebp)
80100a6b:	e8 0b 10 00 00       	call   80101a7b <iunlock>
80100a70:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100a73:	83 ec 0c             	sub    $0xc,%esp
80100a76:	68 e0 b5 10 80       	push   $0x8010b5e0
80100a7b:	e8 fb 44 00 00       	call   80104f7b <acquire>
80100a80:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100a83:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100a8a:	eb 21                	jmp    80100aad <consolewrite+0x4e>
    consputc(buf[i] & 0xff);
80100a8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a8f:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a92:	01 d0                	add    %edx,%eax
80100a94:	0f b6 00             	movzbl (%eax),%eax
80100a97:	0f be c0             	movsbl %al,%eax
80100a9a:	0f b6 c0             	movzbl %al,%eax
80100a9d:	83 ec 0c             	sub    $0xc,%esp
80100aa0:	50                   	push   %eax
80100aa1:	e8 c5 fc ff ff       	call   8010076b <consputc>
80100aa6:	83 c4 10             	add    $0x10,%esp
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100aa9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ab0:	3b 45 10             	cmp    0x10(%ebp),%eax
80100ab3:	7c d7                	jl     80100a8c <consolewrite+0x2d>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100ab5:	83 ec 0c             	sub    $0xc,%esp
80100ab8:	68 e0 b5 10 80       	push   $0x8010b5e0
80100abd:	e8 1f 45 00 00       	call   80104fe1 <release>
80100ac2:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100ac5:	83 ec 0c             	sub    $0xc,%esp
80100ac8:	ff 75 08             	pushl  0x8(%ebp)
80100acb:	e8 4e 0e 00 00       	call   8010191e <ilock>
80100ad0:	83 c4 10             	add    $0x10,%esp

  return n;
80100ad3:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100ad6:	c9                   	leave  
80100ad7:	c3                   	ret    

80100ad8 <consoleinit>:

void
consoleinit(void)
{
80100ad8:	55                   	push   %ebp
80100ad9:	89 e5                	mov    %esp,%ebp
80100adb:	83 ec 08             	sub    $0x8,%esp
  initlock(&cons.lock, "console");
80100ade:	83 ec 08             	sub    $0x8,%esp
80100ae1:	68 d3 84 10 80       	push   $0x801084d3
80100ae6:	68 e0 b5 10 80       	push   $0x8010b5e0
80100aeb:	e8 6a 44 00 00       	call   80104f5a <initlock>
80100af0:	83 c4 10             	add    $0x10,%esp
  initlock(&input.lock, "input");
80100af3:	83 ec 08             	sub    $0x8,%esp
80100af6:	68 db 84 10 80       	push   $0x801084db
80100afb:	68 c0 07 11 80       	push   $0x801107c0
80100b00:	e8 55 44 00 00       	call   80104f5a <initlock>
80100b05:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100b08:	c7 05 4c 12 11 80 5f 	movl   $0x80100a5f,0x8011124c
80100b0f:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100b12:	c7 05 48 12 11 80 4a 	movl   $0x8010094a,0x80111248
80100b19:	09 10 80 
  cons.locking = 1;
80100b1c:	c7 05 14 b6 10 80 01 	movl   $0x1,0x8010b614
80100b23:	00 00 00 

  picenable(IRQ_KBD);
80100b26:	83 ec 0c             	sub    $0xc,%esp
80100b29:	6a 01                	push   $0x1
80100b2b:	e8 86 33 00 00       	call   80103eb6 <picenable>
80100b30:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_KBD, 0);
80100b33:	83 ec 08             	sub    $0x8,%esp
80100b36:	6a 00                	push   $0x0
80100b38:	6a 01                	push   $0x1
80100b3a:	e8 43 1f 00 00       	call   80102a82 <ioapicenable>
80100b3f:	83 c4 10             	add    $0x10,%esp
}
80100b42:	c9                   	leave  
80100b43:	c3                   	ret    

80100b44 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b44:	55                   	push   %ebp
80100b45:	89 e5                	mov    %esp,%ebp
80100b47:	81 ec 18 01 00 00    	sub    $0x118,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
80100b4d:	e8 90 29 00 00       	call   801034e2 <begin_op>
  if((ip = namei(path)) == 0){
80100b52:	83 ec 0c             	sub    $0xc,%esp
80100b55:	ff 75 08             	pushl  0x8(%ebp)
80100b58:	e8 7c 19 00 00       	call   801024d9 <namei>
80100b5d:	83 c4 10             	add    $0x10,%esp
80100b60:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100b63:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100b67:	75 0f                	jne    80100b78 <exec+0x34>
    end_op();
80100b69:	e8 02 2a 00 00       	call   80103570 <end_op>
    return -1;
80100b6e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b73:	e9 b9 03 00 00       	jmp    80100f31 <exec+0x3ed>
  }
  ilock(ip);
80100b78:	83 ec 0c             	sub    $0xc,%esp
80100b7b:	ff 75 d8             	pushl  -0x28(%ebp)
80100b7e:	e8 9b 0d 00 00       	call   8010191e <ilock>
80100b83:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100b86:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100b8d:	6a 34                	push   $0x34
80100b8f:	6a 00                	push   $0x0
80100b91:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100b97:	50                   	push   %eax
80100b98:	ff 75 d8             	pushl  -0x28(%ebp)
80100b9b:	e8 e6 12 00 00       	call   80101e86 <readi>
80100ba0:	83 c4 10             	add    $0x10,%esp
80100ba3:	83 f8 33             	cmp    $0x33,%eax
80100ba6:	77 05                	ja     80100bad <exec+0x69>
    goto bad;
80100ba8:	e9 52 03 00 00       	jmp    80100eff <exec+0x3bb>
  if(elf.magic != ELF_MAGIC)
80100bad:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bb3:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100bb8:	74 05                	je     80100bbf <exec+0x7b>
    goto bad;
80100bba:	e9 40 03 00 00       	jmp    80100eff <exec+0x3bb>

  if((pgdir = setupkvm()) == 0)
80100bbf:	e8 a8 70 00 00       	call   80107c6c <setupkvm>
80100bc4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100bc7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100bcb:	75 05                	jne    80100bd2 <exec+0x8e>
    goto bad;
80100bcd:	e9 2d 03 00 00       	jmp    80100eff <exec+0x3bb>

  // Load program into memory.
  sz = 0;
80100bd2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bd9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100be0:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100be6:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100be9:	e9 ae 00 00 00       	jmp    80100c9c <exec+0x158>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bee:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100bf1:	6a 20                	push   $0x20
80100bf3:	50                   	push   %eax
80100bf4:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100bfa:	50                   	push   %eax
80100bfb:	ff 75 d8             	pushl  -0x28(%ebp)
80100bfe:	e8 83 12 00 00       	call   80101e86 <readi>
80100c03:	83 c4 10             	add    $0x10,%esp
80100c06:	83 f8 20             	cmp    $0x20,%eax
80100c09:	74 05                	je     80100c10 <exec+0xcc>
      goto bad;
80100c0b:	e9 ef 02 00 00       	jmp    80100eff <exec+0x3bb>
    if(ph.type != ELF_PROG_LOAD)
80100c10:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100c16:	83 f8 01             	cmp    $0x1,%eax
80100c19:	74 02                	je     80100c1d <exec+0xd9>
      continue;
80100c1b:	eb 72                	jmp    80100c8f <exec+0x14b>
    if(ph.memsz < ph.filesz)
80100c1d:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100c23:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100c29:	39 c2                	cmp    %eax,%edx
80100c2b:	73 05                	jae    80100c32 <exec+0xee>
      goto bad;
80100c2d:	e9 cd 02 00 00       	jmp    80100eff <exec+0x3bb>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100c32:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100c38:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100c3e:	01 d0                	add    %edx,%eax
80100c40:	83 ec 04             	sub    $0x4,%esp
80100c43:	50                   	push   %eax
80100c44:	ff 75 e0             	pushl  -0x20(%ebp)
80100c47:	ff 75 d4             	pushl  -0x2c(%ebp)
80100c4a:	e8 c0 73 00 00       	call   8010800f <allocuvm>
80100c4f:	83 c4 10             	add    $0x10,%esp
80100c52:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100c55:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100c59:	75 05                	jne    80100c60 <exec+0x11c>
      goto bad;
80100c5b:	e9 9f 02 00 00       	jmp    80100eff <exec+0x3bb>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c60:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100c66:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c6c:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100c72:	83 ec 0c             	sub    $0xc,%esp
80100c75:	52                   	push   %edx
80100c76:	50                   	push   %eax
80100c77:	ff 75 d8             	pushl  -0x28(%ebp)
80100c7a:	51                   	push   %ecx
80100c7b:	ff 75 d4             	pushl  -0x2c(%ebp)
80100c7e:	e8 b5 72 00 00       	call   80107f38 <loaduvm>
80100c83:	83 c4 20             	add    $0x20,%esp
80100c86:	85 c0                	test   %eax,%eax
80100c88:	79 05                	jns    80100c8f <exec+0x14b>
      goto bad;
80100c8a:	e9 70 02 00 00       	jmp    80100eff <exec+0x3bb>
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c8f:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100c93:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c96:	83 c0 20             	add    $0x20,%eax
80100c99:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c9c:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100ca3:	0f b7 c0             	movzwl %ax,%eax
80100ca6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100ca9:	0f 8f 3f ff ff ff    	jg     80100bee <exec+0xaa>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100caf:	83 ec 0c             	sub    $0xc,%esp
80100cb2:	ff 75 d8             	pushl  -0x28(%ebp)
80100cb5:	e8 21 0f 00 00       	call   80101bdb <iunlockput>
80100cba:	83 c4 10             	add    $0x10,%esp
  end_op();
80100cbd:	e8 ae 28 00 00       	call   80103570 <end_op>
  ip = 0;
80100cc2:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100cc9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ccc:	05 ff 0f 00 00       	add    $0xfff,%eax
80100cd1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100cd6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100cd9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cdc:	05 00 20 00 00       	add    $0x2000,%eax
80100ce1:	83 ec 04             	sub    $0x4,%esp
80100ce4:	50                   	push   %eax
80100ce5:	ff 75 e0             	pushl  -0x20(%ebp)
80100ce8:	ff 75 d4             	pushl  -0x2c(%ebp)
80100ceb:	e8 1f 73 00 00       	call   8010800f <allocuvm>
80100cf0:	83 c4 10             	add    $0x10,%esp
80100cf3:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100cf6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100cfa:	75 05                	jne    80100d01 <exec+0x1bd>
    goto bad;
80100cfc:	e9 fe 01 00 00       	jmp    80100eff <exec+0x3bb>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d01:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d04:	2d 00 20 00 00       	sub    $0x2000,%eax
80100d09:	83 ec 08             	sub    $0x8,%esp
80100d0c:	50                   	push   %eax
80100d0d:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d10:	e8 1f 75 00 00       	call   80108234 <clearpteu>
80100d15:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100d18:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d1b:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d1e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100d25:	e9 98 00 00 00       	jmp    80100dc2 <exec+0x27e>
    if(argc >= MAXARG)
80100d2a:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100d2e:	76 05                	jbe    80100d35 <exec+0x1f1>
      goto bad;
80100d30:	e9 ca 01 00 00       	jmp    80100eff <exec+0x3bb>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d38:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d3f:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d42:	01 d0                	add    %edx,%eax
80100d44:	8b 00                	mov    (%eax),%eax
80100d46:	83 ec 0c             	sub    $0xc,%esp
80100d49:	50                   	push   %eax
80100d4a:	e8 d7 46 00 00       	call   80105426 <strlen>
80100d4f:	83 c4 10             	add    $0x10,%esp
80100d52:	89 c2                	mov    %eax,%edx
80100d54:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d57:	29 d0                	sub    %edx,%eax
80100d59:	83 e8 01             	sub    $0x1,%eax
80100d5c:	83 e0 fc             	and    $0xfffffffc,%eax
80100d5f:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d65:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d6c:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d6f:	01 d0                	add    %edx,%eax
80100d71:	8b 00                	mov    (%eax),%eax
80100d73:	83 ec 0c             	sub    $0xc,%esp
80100d76:	50                   	push   %eax
80100d77:	e8 aa 46 00 00       	call   80105426 <strlen>
80100d7c:	83 c4 10             	add    $0x10,%esp
80100d7f:	83 c0 01             	add    $0x1,%eax
80100d82:	89 c1                	mov    %eax,%ecx
80100d84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d87:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d8e:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d91:	01 d0                	add    %edx,%eax
80100d93:	8b 00                	mov    (%eax),%eax
80100d95:	51                   	push   %ecx
80100d96:	50                   	push   %eax
80100d97:	ff 75 dc             	pushl  -0x24(%ebp)
80100d9a:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d9d:	e8 48 76 00 00       	call   801083ea <copyout>
80100da2:	83 c4 10             	add    $0x10,%esp
80100da5:	85 c0                	test   %eax,%eax
80100da7:	79 05                	jns    80100dae <exec+0x26a>
      goto bad;
80100da9:	e9 51 01 00 00       	jmp    80100eff <exec+0x3bb>
    ustack[3+argc] = sp;
80100dae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100db1:	8d 50 03             	lea    0x3(%eax),%edx
80100db4:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100db7:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100dbe:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100dc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dc5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100dcc:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dcf:	01 d0                	add    %edx,%eax
80100dd1:	8b 00                	mov    (%eax),%eax
80100dd3:	85 c0                	test   %eax,%eax
80100dd5:	0f 85 4f ff ff ff    	jne    80100d2a <exec+0x1e6>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100ddb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dde:	83 c0 03             	add    $0x3,%eax
80100de1:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100de8:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100dec:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100df3:	ff ff ff 
  ustack[1] = argc;
80100df6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100df9:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100dff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e02:	83 c0 01             	add    $0x1,%eax
80100e05:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e0c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e0f:	29 d0                	sub    %edx,%eax
80100e11:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100e17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e1a:	83 c0 04             	add    $0x4,%eax
80100e1d:	c1 e0 02             	shl    $0x2,%eax
80100e20:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e26:	83 c0 04             	add    $0x4,%eax
80100e29:	c1 e0 02             	shl    $0x2,%eax
80100e2c:	50                   	push   %eax
80100e2d:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100e33:	50                   	push   %eax
80100e34:	ff 75 dc             	pushl  -0x24(%ebp)
80100e37:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e3a:	e8 ab 75 00 00       	call   801083ea <copyout>
80100e3f:	83 c4 10             	add    $0x10,%esp
80100e42:	85 c0                	test   %eax,%eax
80100e44:	79 05                	jns    80100e4b <exec+0x307>
    goto bad;
80100e46:	e9 b4 00 00 00       	jmp    80100eff <exec+0x3bb>

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e4b:	8b 45 08             	mov    0x8(%ebp),%eax
80100e4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e54:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100e57:	eb 17                	jmp    80100e70 <exec+0x32c>
    if(*s == '/')
80100e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e5c:	0f b6 00             	movzbl (%eax),%eax
80100e5f:	3c 2f                	cmp    $0x2f,%al
80100e61:	75 09                	jne    80100e6c <exec+0x328>
      last = s+1;
80100e63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e66:	83 c0 01             	add    $0x1,%eax
80100e69:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e6c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e73:	0f b6 00             	movzbl (%eax),%eax
80100e76:	84 c0                	test   %al,%al
80100e78:	75 df                	jne    80100e59 <exec+0x315>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100e7a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e80:	83 c0 6c             	add    $0x6c,%eax
80100e83:	83 ec 04             	sub    $0x4,%esp
80100e86:	6a 10                	push   $0x10
80100e88:	ff 75 f0             	pushl  -0x10(%ebp)
80100e8b:	50                   	push   %eax
80100e8c:	e8 4b 45 00 00       	call   801053dc <safestrcpy>
80100e91:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100e94:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e9a:	8b 40 04             	mov    0x4(%eax),%eax
80100e9d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100ea0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ea6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100ea9:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100eac:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eb2:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100eb5:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100eb7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ebd:	8b 40 18             	mov    0x18(%eax),%eax
80100ec0:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100ec6:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100ec9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ecf:	8b 40 18             	mov    0x18(%eax),%eax
80100ed2:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100ed5:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100ed8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ede:	83 ec 0c             	sub    $0xc,%esp
80100ee1:	50                   	push   %eax
80100ee2:	e8 6a 6e 00 00       	call   80107d51 <switchuvm>
80100ee7:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100eea:	83 ec 0c             	sub    $0xc,%esp
80100eed:	ff 75 d0             	pushl  -0x30(%ebp)
80100ef0:	e8 a0 72 00 00       	call   80108195 <freevm>
80100ef5:	83 c4 10             	add    $0x10,%esp
  return 0;
80100ef8:	b8 00 00 00 00       	mov    $0x0,%eax
80100efd:	eb 32                	jmp    80100f31 <exec+0x3ed>

 bad:
  if(pgdir)
80100eff:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100f03:	74 0e                	je     80100f13 <exec+0x3cf>
    freevm(pgdir);
80100f05:	83 ec 0c             	sub    $0xc,%esp
80100f08:	ff 75 d4             	pushl  -0x2c(%ebp)
80100f0b:	e8 85 72 00 00       	call   80108195 <freevm>
80100f10:	83 c4 10             	add    $0x10,%esp
  if(ip){
80100f13:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100f17:	74 13                	je     80100f2c <exec+0x3e8>
    iunlockput(ip);
80100f19:	83 ec 0c             	sub    $0xc,%esp
80100f1c:	ff 75 d8             	pushl  -0x28(%ebp)
80100f1f:	e8 b7 0c 00 00       	call   80101bdb <iunlockput>
80100f24:	83 c4 10             	add    $0x10,%esp
    end_op();
80100f27:	e8 44 26 00 00       	call   80103570 <end_op>
  }
  return -1;
80100f2c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f31:	c9                   	leave  
80100f32:	c3                   	ret    

80100f33 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f33:	55                   	push   %ebp
80100f34:	89 e5                	mov    %esp,%ebp
80100f36:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
80100f39:	83 ec 08             	sub    $0x8,%esp
80100f3c:	68 e1 84 10 80       	push   $0x801084e1
80100f41:	68 80 08 11 80       	push   $0x80110880
80100f46:	e8 0f 40 00 00       	call   80104f5a <initlock>
80100f4b:	83 c4 10             	add    $0x10,%esp
}
80100f4e:	c9                   	leave  
80100f4f:	c3                   	ret    

80100f50 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f50:	55                   	push   %ebp
80100f51:	89 e5                	mov    %esp,%ebp
80100f53:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
80100f56:	83 ec 0c             	sub    $0xc,%esp
80100f59:	68 80 08 11 80       	push   $0x80110880
80100f5e:	e8 18 40 00 00       	call   80104f7b <acquire>
80100f63:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f66:	c7 45 f4 b4 08 11 80 	movl   $0x801108b4,-0xc(%ebp)
80100f6d:	eb 2d                	jmp    80100f9c <filealloc+0x4c>
    if(f->ref == 0){
80100f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f72:	8b 40 04             	mov    0x4(%eax),%eax
80100f75:	85 c0                	test   %eax,%eax
80100f77:	75 1f                	jne    80100f98 <filealloc+0x48>
      f->ref = 1;
80100f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f7c:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100f83:	83 ec 0c             	sub    $0xc,%esp
80100f86:	68 80 08 11 80       	push   $0x80110880
80100f8b:	e8 51 40 00 00       	call   80104fe1 <release>
80100f90:	83 c4 10             	add    $0x10,%esp
      return f;
80100f93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f96:	eb 22                	jmp    80100fba <filealloc+0x6a>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f98:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100f9c:	81 7d f4 14 12 11 80 	cmpl   $0x80111214,-0xc(%ebp)
80100fa3:	72 ca                	jb     80100f6f <filealloc+0x1f>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100fa5:	83 ec 0c             	sub    $0xc,%esp
80100fa8:	68 80 08 11 80       	push   $0x80110880
80100fad:	e8 2f 40 00 00       	call   80104fe1 <release>
80100fb2:	83 c4 10             	add    $0x10,%esp
  return 0;
80100fb5:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100fba:	c9                   	leave  
80100fbb:	c3                   	ret    

80100fbc <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100fbc:	55                   	push   %ebp
80100fbd:	89 e5                	mov    %esp,%ebp
80100fbf:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
80100fc2:	83 ec 0c             	sub    $0xc,%esp
80100fc5:	68 80 08 11 80       	push   $0x80110880
80100fca:	e8 ac 3f 00 00       	call   80104f7b <acquire>
80100fcf:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80100fd2:	8b 45 08             	mov    0x8(%ebp),%eax
80100fd5:	8b 40 04             	mov    0x4(%eax),%eax
80100fd8:	85 c0                	test   %eax,%eax
80100fda:	7f 0d                	jg     80100fe9 <filedup+0x2d>
    panic("filedup");
80100fdc:	83 ec 0c             	sub    $0xc,%esp
80100fdf:	68 e8 84 10 80       	push   $0x801084e8
80100fe4:	e8 73 f5 ff ff       	call   8010055c <panic>
  f->ref++;
80100fe9:	8b 45 08             	mov    0x8(%ebp),%eax
80100fec:	8b 40 04             	mov    0x4(%eax),%eax
80100fef:	8d 50 01             	lea    0x1(%eax),%edx
80100ff2:	8b 45 08             	mov    0x8(%ebp),%eax
80100ff5:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80100ff8:	83 ec 0c             	sub    $0xc,%esp
80100ffb:	68 80 08 11 80       	push   $0x80110880
80101000:	e8 dc 3f 00 00       	call   80104fe1 <release>
80101005:	83 c4 10             	add    $0x10,%esp
  return f;
80101008:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010100b:	c9                   	leave  
8010100c:	c3                   	ret    

8010100d <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
8010100d:	55                   	push   %ebp
8010100e:	89 e5                	mov    %esp,%ebp
80101010:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
80101013:	83 ec 0c             	sub    $0xc,%esp
80101016:	68 80 08 11 80       	push   $0x80110880
8010101b:	e8 5b 3f 00 00       	call   80104f7b <acquire>
80101020:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101023:	8b 45 08             	mov    0x8(%ebp),%eax
80101026:	8b 40 04             	mov    0x4(%eax),%eax
80101029:	85 c0                	test   %eax,%eax
8010102b:	7f 0d                	jg     8010103a <fileclose+0x2d>
    panic("fileclose");
8010102d:	83 ec 0c             	sub    $0xc,%esp
80101030:	68 f0 84 10 80       	push   $0x801084f0
80101035:	e8 22 f5 ff ff       	call   8010055c <panic>
  if(--f->ref > 0){
8010103a:	8b 45 08             	mov    0x8(%ebp),%eax
8010103d:	8b 40 04             	mov    0x4(%eax),%eax
80101040:	8d 50 ff             	lea    -0x1(%eax),%edx
80101043:	8b 45 08             	mov    0x8(%ebp),%eax
80101046:	89 50 04             	mov    %edx,0x4(%eax)
80101049:	8b 45 08             	mov    0x8(%ebp),%eax
8010104c:	8b 40 04             	mov    0x4(%eax),%eax
8010104f:	85 c0                	test   %eax,%eax
80101051:	7e 15                	jle    80101068 <fileclose+0x5b>
    release(&ftable.lock);
80101053:	83 ec 0c             	sub    $0xc,%esp
80101056:	68 80 08 11 80       	push   $0x80110880
8010105b:	e8 81 3f 00 00       	call   80104fe1 <release>
80101060:	83 c4 10             	add    $0x10,%esp
80101063:	e9 8b 00 00 00       	jmp    801010f3 <fileclose+0xe6>
    return;
  }
  ff = *f;
80101068:	8b 45 08             	mov    0x8(%ebp),%eax
8010106b:	8b 10                	mov    (%eax),%edx
8010106d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101070:	8b 50 04             	mov    0x4(%eax),%edx
80101073:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101076:	8b 50 08             	mov    0x8(%eax),%edx
80101079:	89 55 e8             	mov    %edx,-0x18(%ebp)
8010107c:	8b 50 0c             	mov    0xc(%eax),%edx
8010107f:	89 55 ec             	mov    %edx,-0x14(%ebp)
80101082:	8b 50 10             	mov    0x10(%eax),%edx
80101085:	89 55 f0             	mov    %edx,-0x10(%ebp)
80101088:	8b 40 14             	mov    0x14(%eax),%eax
8010108b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
8010108e:	8b 45 08             	mov    0x8(%ebp),%eax
80101091:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101098:	8b 45 08             	mov    0x8(%ebp),%eax
8010109b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
801010a1:	83 ec 0c             	sub    $0xc,%esp
801010a4:	68 80 08 11 80       	push   $0x80110880
801010a9:	e8 33 3f 00 00       	call   80104fe1 <release>
801010ae:	83 c4 10             	add    $0x10,%esp
  
  if(ff.type == FD_PIPE)
801010b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010b4:	83 f8 01             	cmp    $0x1,%eax
801010b7:	75 19                	jne    801010d2 <fileclose+0xc5>
    pipeclose(ff.pipe, ff.writable);
801010b9:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
801010bd:	0f be d0             	movsbl %al,%edx
801010c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801010c3:	83 ec 08             	sub    $0x8,%esp
801010c6:	52                   	push   %edx
801010c7:	50                   	push   %eax
801010c8:	e8 50 30 00 00       	call   8010411d <pipeclose>
801010cd:	83 c4 10             	add    $0x10,%esp
801010d0:	eb 21                	jmp    801010f3 <fileclose+0xe6>
  else if(ff.type == FD_INODE){
801010d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010d5:	83 f8 02             	cmp    $0x2,%eax
801010d8:	75 19                	jne    801010f3 <fileclose+0xe6>
    begin_op();
801010da:	e8 03 24 00 00       	call   801034e2 <begin_op>
    iput(ff.ip);
801010df:	8b 45 f0             	mov    -0x10(%ebp),%eax
801010e2:	83 ec 0c             	sub    $0xc,%esp
801010e5:	50                   	push   %eax
801010e6:	e8 01 0a 00 00       	call   80101aec <iput>
801010eb:	83 c4 10             	add    $0x10,%esp
    end_op();
801010ee:	e8 7d 24 00 00       	call   80103570 <end_op>
  }
}
801010f3:	c9                   	leave  
801010f4:	c3                   	ret    

801010f5 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801010f5:	55                   	push   %ebp
801010f6:	89 e5                	mov    %esp,%ebp
801010f8:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
801010fb:	8b 45 08             	mov    0x8(%ebp),%eax
801010fe:	8b 00                	mov    (%eax),%eax
80101100:	83 f8 02             	cmp    $0x2,%eax
80101103:	75 40                	jne    80101145 <filestat+0x50>
    ilock(f->ip);
80101105:	8b 45 08             	mov    0x8(%ebp),%eax
80101108:	8b 40 10             	mov    0x10(%eax),%eax
8010110b:	83 ec 0c             	sub    $0xc,%esp
8010110e:	50                   	push   %eax
8010110f:	e8 0a 08 00 00       	call   8010191e <ilock>
80101114:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
80101117:	8b 45 08             	mov    0x8(%ebp),%eax
8010111a:	8b 40 10             	mov    0x10(%eax),%eax
8010111d:	83 ec 08             	sub    $0x8,%esp
80101120:	ff 75 0c             	pushl  0xc(%ebp)
80101123:	50                   	push   %eax
80101124:	e8 18 0d 00 00       	call   80101e41 <stati>
80101129:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
8010112c:	8b 45 08             	mov    0x8(%ebp),%eax
8010112f:	8b 40 10             	mov    0x10(%eax),%eax
80101132:	83 ec 0c             	sub    $0xc,%esp
80101135:	50                   	push   %eax
80101136:	e8 40 09 00 00       	call   80101a7b <iunlock>
8010113b:	83 c4 10             	add    $0x10,%esp
    return 0;
8010113e:	b8 00 00 00 00       	mov    $0x0,%eax
80101143:	eb 05                	jmp    8010114a <filestat+0x55>
  }
  return -1;
80101145:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010114a:	c9                   	leave  
8010114b:	c3                   	ret    

8010114c <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
8010114c:	55                   	push   %ebp
8010114d:	89 e5                	mov    %esp,%ebp
8010114f:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
80101152:	8b 45 08             	mov    0x8(%ebp),%eax
80101155:	0f b6 40 08          	movzbl 0x8(%eax),%eax
80101159:	84 c0                	test   %al,%al
8010115b:	75 0a                	jne    80101167 <fileread+0x1b>
    return -1;
8010115d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101162:	e9 9b 00 00 00       	jmp    80101202 <fileread+0xb6>
  if(f->type == FD_PIPE)
80101167:	8b 45 08             	mov    0x8(%ebp),%eax
8010116a:	8b 00                	mov    (%eax),%eax
8010116c:	83 f8 01             	cmp    $0x1,%eax
8010116f:	75 1a                	jne    8010118b <fileread+0x3f>
    return piperead(f->pipe, addr, n);
80101171:	8b 45 08             	mov    0x8(%ebp),%eax
80101174:	8b 40 0c             	mov    0xc(%eax),%eax
80101177:	83 ec 04             	sub    $0x4,%esp
8010117a:	ff 75 10             	pushl  0x10(%ebp)
8010117d:	ff 75 0c             	pushl  0xc(%ebp)
80101180:	50                   	push   %eax
80101181:	e8 44 31 00 00       	call   801042ca <piperead>
80101186:	83 c4 10             	add    $0x10,%esp
80101189:	eb 77                	jmp    80101202 <fileread+0xb6>
  if(f->type == FD_INODE){
8010118b:	8b 45 08             	mov    0x8(%ebp),%eax
8010118e:	8b 00                	mov    (%eax),%eax
80101190:	83 f8 02             	cmp    $0x2,%eax
80101193:	75 60                	jne    801011f5 <fileread+0xa9>
    ilock(f->ip);
80101195:	8b 45 08             	mov    0x8(%ebp),%eax
80101198:	8b 40 10             	mov    0x10(%eax),%eax
8010119b:	83 ec 0c             	sub    $0xc,%esp
8010119e:	50                   	push   %eax
8010119f:	e8 7a 07 00 00       	call   8010191e <ilock>
801011a4:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801011a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801011aa:	8b 45 08             	mov    0x8(%ebp),%eax
801011ad:	8b 50 14             	mov    0x14(%eax),%edx
801011b0:	8b 45 08             	mov    0x8(%ebp),%eax
801011b3:	8b 40 10             	mov    0x10(%eax),%eax
801011b6:	51                   	push   %ecx
801011b7:	52                   	push   %edx
801011b8:	ff 75 0c             	pushl  0xc(%ebp)
801011bb:	50                   	push   %eax
801011bc:	e8 c5 0c 00 00       	call   80101e86 <readi>
801011c1:	83 c4 10             	add    $0x10,%esp
801011c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801011c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801011cb:	7e 11                	jle    801011de <fileread+0x92>
      f->off += r;
801011cd:	8b 45 08             	mov    0x8(%ebp),%eax
801011d0:	8b 50 14             	mov    0x14(%eax),%edx
801011d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011d6:	01 c2                	add    %eax,%edx
801011d8:	8b 45 08             	mov    0x8(%ebp),%eax
801011db:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
801011de:	8b 45 08             	mov    0x8(%ebp),%eax
801011e1:	8b 40 10             	mov    0x10(%eax),%eax
801011e4:	83 ec 0c             	sub    $0xc,%esp
801011e7:	50                   	push   %eax
801011e8:	e8 8e 08 00 00       	call   80101a7b <iunlock>
801011ed:	83 c4 10             	add    $0x10,%esp
    return r;
801011f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011f3:	eb 0d                	jmp    80101202 <fileread+0xb6>
  }
  panic("fileread");
801011f5:	83 ec 0c             	sub    $0xc,%esp
801011f8:	68 fa 84 10 80       	push   $0x801084fa
801011fd:	e8 5a f3 ff ff       	call   8010055c <panic>
}
80101202:	c9                   	leave  
80101203:	c3                   	ret    

80101204 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101204:	55                   	push   %ebp
80101205:	89 e5                	mov    %esp,%ebp
80101207:	53                   	push   %ebx
80101208:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
8010120b:	8b 45 08             	mov    0x8(%ebp),%eax
8010120e:	0f b6 40 09          	movzbl 0x9(%eax),%eax
80101212:	84 c0                	test   %al,%al
80101214:	75 0a                	jne    80101220 <filewrite+0x1c>
    return -1;
80101216:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010121b:	e9 1a 01 00 00       	jmp    8010133a <filewrite+0x136>
  if(f->type == FD_PIPE)
80101220:	8b 45 08             	mov    0x8(%ebp),%eax
80101223:	8b 00                	mov    (%eax),%eax
80101225:	83 f8 01             	cmp    $0x1,%eax
80101228:	75 1d                	jne    80101247 <filewrite+0x43>
    return pipewrite(f->pipe, addr, n);
8010122a:	8b 45 08             	mov    0x8(%ebp),%eax
8010122d:	8b 40 0c             	mov    0xc(%eax),%eax
80101230:	83 ec 04             	sub    $0x4,%esp
80101233:	ff 75 10             	pushl  0x10(%ebp)
80101236:	ff 75 0c             	pushl  0xc(%ebp)
80101239:	50                   	push   %eax
8010123a:	e8 87 2f 00 00       	call   801041c6 <pipewrite>
8010123f:	83 c4 10             	add    $0x10,%esp
80101242:	e9 f3 00 00 00       	jmp    8010133a <filewrite+0x136>
  if(f->type == FD_INODE){
80101247:	8b 45 08             	mov    0x8(%ebp),%eax
8010124a:	8b 00                	mov    (%eax),%eax
8010124c:	83 f8 02             	cmp    $0x2,%eax
8010124f:	0f 85 d8 00 00 00    	jne    8010132d <filewrite+0x129>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
80101255:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
8010125c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
80101263:	e9 a5 00 00 00       	jmp    8010130d <filewrite+0x109>
      int n1 = n - i;
80101268:	8b 45 10             	mov    0x10(%ebp),%eax
8010126b:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010126e:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
80101271:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101274:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101277:	7e 06                	jle    8010127f <filewrite+0x7b>
        n1 = max;
80101279:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010127c:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
8010127f:	e8 5e 22 00 00       	call   801034e2 <begin_op>
      ilock(f->ip);
80101284:	8b 45 08             	mov    0x8(%ebp),%eax
80101287:	8b 40 10             	mov    0x10(%eax),%eax
8010128a:	83 ec 0c             	sub    $0xc,%esp
8010128d:	50                   	push   %eax
8010128e:	e8 8b 06 00 00       	call   8010191e <ilock>
80101293:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101296:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80101299:	8b 45 08             	mov    0x8(%ebp),%eax
8010129c:	8b 50 14             	mov    0x14(%eax),%edx
8010129f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801012a2:	8b 45 0c             	mov    0xc(%ebp),%eax
801012a5:	01 c3                	add    %eax,%ebx
801012a7:	8b 45 08             	mov    0x8(%ebp),%eax
801012aa:	8b 40 10             	mov    0x10(%eax),%eax
801012ad:	51                   	push   %ecx
801012ae:	52                   	push   %edx
801012af:	53                   	push   %ebx
801012b0:	50                   	push   %eax
801012b1:	e8 2a 0d 00 00       	call   80101fe0 <writei>
801012b6:	83 c4 10             	add    $0x10,%esp
801012b9:	89 45 e8             	mov    %eax,-0x18(%ebp)
801012bc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012c0:	7e 11                	jle    801012d3 <filewrite+0xcf>
        f->off += r;
801012c2:	8b 45 08             	mov    0x8(%ebp),%eax
801012c5:	8b 50 14             	mov    0x14(%eax),%edx
801012c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012cb:	01 c2                	add    %eax,%edx
801012cd:	8b 45 08             	mov    0x8(%ebp),%eax
801012d0:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
801012d3:	8b 45 08             	mov    0x8(%ebp),%eax
801012d6:	8b 40 10             	mov    0x10(%eax),%eax
801012d9:	83 ec 0c             	sub    $0xc,%esp
801012dc:	50                   	push   %eax
801012dd:	e8 99 07 00 00       	call   80101a7b <iunlock>
801012e2:	83 c4 10             	add    $0x10,%esp
      end_op();
801012e5:	e8 86 22 00 00       	call   80103570 <end_op>

      if(r < 0)
801012ea:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012ee:	79 02                	jns    801012f2 <filewrite+0xee>
        break;
801012f0:	eb 27                	jmp    80101319 <filewrite+0x115>
      if(r != n1)
801012f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012f5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801012f8:	74 0d                	je     80101307 <filewrite+0x103>
        panic("short filewrite");
801012fa:	83 ec 0c             	sub    $0xc,%esp
801012fd:	68 03 85 10 80       	push   $0x80108503
80101302:	e8 55 f2 ff ff       	call   8010055c <panic>
      i += r;
80101307:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010130a:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010130d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101310:	3b 45 10             	cmp    0x10(%ebp),%eax
80101313:	0f 8c 4f ff ff ff    	jl     80101268 <filewrite+0x64>
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
80101319:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010131c:	3b 45 10             	cmp    0x10(%ebp),%eax
8010131f:	75 05                	jne    80101326 <filewrite+0x122>
80101321:	8b 45 10             	mov    0x10(%ebp),%eax
80101324:	eb 14                	jmp    8010133a <filewrite+0x136>
80101326:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010132b:	eb 0d                	jmp    8010133a <filewrite+0x136>
  }
  panic("filewrite");
8010132d:	83 ec 0c             	sub    $0xc,%esp
80101330:	68 13 85 10 80       	push   $0x80108513
80101335:	e8 22 f2 ff ff       	call   8010055c <panic>
}
8010133a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010133d:	c9                   	leave  
8010133e:	c3                   	ret    

8010133f <readsb>:
struct superblock sb;   // there should be one per dev, but we run with one dev

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
8010133f:	55                   	push   %ebp
80101340:	89 e5                	mov    %esp,%ebp
80101342:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
80101345:	8b 45 08             	mov    0x8(%ebp),%eax
80101348:	83 ec 08             	sub    $0x8,%esp
8010134b:	6a 01                	push   $0x1
8010134d:	50                   	push   %eax
8010134e:	e8 61 ee ff ff       	call   801001b4 <bread>
80101353:	83 c4 10             	add    $0x10,%esp
80101356:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
80101359:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010135c:	83 c0 18             	add    $0x18,%eax
8010135f:	83 ec 04             	sub    $0x4,%esp
80101362:	6a 1c                	push   $0x1c
80101364:	50                   	push   %eax
80101365:	ff 75 0c             	pushl  0xc(%ebp)
80101368:	e8 29 3f 00 00       	call   80105296 <memmove>
8010136d:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101370:	83 ec 0c             	sub    $0xc,%esp
80101373:	ff 75 f4             	pushl  -0xc(%ebp)
80101376:	e8 b0 ee ff ff       	call   8010022b <brelse>
8010137b:	83 c4 10             	add    $0x10,%esp
}
8010137e:	c9                   	leave  
8010137f:	c3                   	ret    

80101380 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101380:	55                   	push   %ebp
80101381:	89 e5                	mov    %esp,%ebp
80101383:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
80101386:	8b 55 0c             	mov    0xc(%ebp),%edx
80101389:	8b 45 08             	mov    0x8(%ebp),%eax
8010138c:	83 ec 08             	sub    $0x8,%esp
8010138f:	52                   	push   %edx
80101390:	50                   	push   %eax
80101391:	e8 1e ee ff ff       	call   801001b4 <bread>
80101396:	83 c4 10             	add    $0x10,%esp
80101399:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
8010139c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010139f:	83 c0 18             	add    $0x18,%eax
801013a2:	83 ec 04             	sub    $0x4,%esp
801013a5:	68 00 02 00 00       	push   $0x200
801013aa:	6a 00                	push   $0x0
801013ac:	50                   	push   %eax
801013ad:	e8 25 3e 00 00       	call   801051d7 <memset>
801013b2:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801013b5:	83 ec 0c             	sub    $0xc,%esp
801013b8:	ff 75 f4             	pushl  -0xc(%ebp)
801013bb:	e8 59 23 00 00       	call   80103719 <log_write>
801013c0:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801013c3:	83 ec 0c             	sub    $0xc,%esp
801013c6:	ff 75 f4             	pushl  -0xc(%ebp)
801013c9:	e8 5d ee ff ff       	call   8010022b <brelse>
801013ce:	83 c4 10             	add    $0x10,%esp
}
801013d1:	c9                   	leave  
801013d2:	c3                   	ret    

801013d3 <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801013d3:	55                   	push   %ebp
801013d4:	89 e5                	mov    %esp,%ebp
801013d6:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
801013d9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801013e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801013e7:	e9 13 01 00 00       	jmp    801014ff <balloc+0x12c>
    bp = bread(dev, BBLOCK(b, sb));
801013ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013ef:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801013f5:	85 c0                	test   %eax,%eax
801013f7:	0f 48 c2             	cmovs  %edx,%eax
801013fa:	c1 f8 0c             	sar    $0xc,%eax
801013fd:	89 c2                	mov    %eax,%edx
801013ff:	a1 d8 12 11 80       	mov    0x801112d8,%eax
80101404:	01 d0                	add    %edx,%eax
80101406:	83 ec 08             	sub    $0x8,%esp
80101409:	50                   	push   %eax
8010140a:	ff 75 08             	pushl  0x8(%ebp)
8010140d:	e8 a2 ed ff ff       	call   801001b4 <bread>
80101412:	83 c4 10             	add    $0x10,%esp
80101415:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101418:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010141f:	e9 a6 00 00 00       	jmp    801014ca <balloc+0xf7>
      m = 1 << (bi % 8);
80101424:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101427:	99                   	cltd   
80101428:	c1 ea 1d             	shr    $0x1d,%edx
8010142b:	01 d0                	add    %edx,%eax
8010142d:	83 e0 07             	and    $0x7,%eax
80101430:	29 d0                	sub    %edx,%eax
80101432:	ba 01 00 00 00       	mov    $0x1,%edx
80101437:	89 c1                	mov    %eax,%ecx
80101439:	d3 e2                	shl    %cl,%edx
8010143b:	89 d0                	mov    %edx,%eax
8010143d:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101440:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101443:	8d 50 07             	lea    0x7(%eax),%edx
80101446:	85 c0                	test   %eax,%eax
80101448:	0f 48 c2             	cmovs  %edx,%eax
8010144b:	c1 f8 03             	sar    $0x3,%eax
8010144e:	89 c2                	mov    %eax,%edx
80101450:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101453:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
80101458:	0f b6 c0             	movzbl %al,%eax
8010145b:	23 45 e8             	and    -0x18(%ebp),%eax
8010145e:	85 c0                	test   %eax,%eax
80101460:	75 64                	jne    801014c6 <balloc+0xf3>
        bp->data[bi/8] |= m;  // Mark block in use.
80101462:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101465:	8d 50 07             	lea    0x7(%eax),%edx
80101468:	85 c0                	test   %eax,%eax
8010146a:	0f 48 c2             	cmovs  %edx,%eax
8010146d:	c1 f8 03             	sar    $0x3,%eax
80101470:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101473:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
80101478:	89 d1                	mov    %edx,%ecx
8010147a:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010147d:	09 ca                	or     %ecx,%edx
8010147f:	89 d1                	mov    %edx,%ecx
80101481:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101484:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
80101488:	83 ec 0c             	sub    $0xc,%esp
8010148b:	ff 75 ec             	pushl  -0x14(%ebp)
8010148e:	e8 86 22 00 00       	call   80103719 <log_write>
80101493:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
80101496:	83 ec 0c             	sub    $0xc,%esp
80101499:	ff 75 ec             	pushl  -0x14(%ebp)
8010149c:	e8 8a ed ff ff       	call   8010022b <brelse>
801014a1:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
801014a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014aa:	01 c2                	add    %eax,%edx
801014ac:	8b 45 08             	mov    0x8(%ebp),%eax
801014af:	83 ec 08             	sub    $0x8,%esp
801014b2:	52                   	push   %edx
801014b3:	50                   	push   %eax
801014b4:	e8 c7 fe ff ff       	call   80101380 <bzero>
801014b9:	83 c4 10             	add    $0x10,%esp
        return b + bi;
801014bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014c2:	01 d0                	add    %edx,%eax
801014c4:	eb 56                	jmp    8010151c <balloc+0x149>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801014c6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801014ca:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
801014d1:	7f 17                	jg     801014ea <balloc+0x117>
801014d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014d9:	01 d0                	add    %edx,%eax
801014db:	89 c2                	mov    %eax,%edx
801014dd:	a1 c0 12 11 80       	mov    0x801112c0,%eax
801014e2:	39 c2                	cmp    %eax,%edx
801014e4:	0f 82 3a ff ff ff    	jb     80101424 <balloc+0x51>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801014ea:	83 ec 0c             	sub    $0xc,%esp
801014ed:	ff 75 ec             	pushl  -0x14(%ebp)
801014f0:	e8 36 ed ff ff       	call   8010022b <brelse>
801014f5:	83 c4 10             	add    $0x10,%esp
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801014f8:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801014ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101502:	a1 c0 12 11 80       	mov    0x801112c0,%eax
80101507:	39 c2                	cmp    %eax,%edx
80101509:	0f 82 dd fe ff ff    	jb     801013ec <balloc+0x19>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
8010150f:	83 ec 0c             	sub    $0xc,%esp
80101512:	68 20 85 10 80       	push   $0x80108520
80101517:	e8 40 f0 ff ff       	call   8010055c <panic>
}
8010151c:	c9                   	leave  
8010151d:	c3                   	ret    

8010151e <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
8010151e:	55                   	push   %ebp
8010151f:	89 e5                	mov    %esp,%ebp
80101521:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
80101524:	83 ec 08             	sub    $0x8,%esp
80101527:	68 c0 12 11 80       	push   $0x801112c0
8010152c:	ff 75 08             	pushl  0x8(%ebp)
8010152f:	e8 0b fe ff ff       	call   8010133f <readsb>
80101534:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101537:	8b 45 0c             	mov    0xc(%ebp),%eax
8010153a:	c1 e8 0c             	shr    $0xc,%eax
8010153d:	89 c2                	mov    %eax,%edx
8010153f:	a1 d8 12 11 80       	mov    0x801112d8,%eax
80101544:	01 c2                	add    %eax,%edx
80101546:	8b 45 08             	mov    0x8(%ebp),%eax
80101549:	83 ec 08             	sub    $0x8,%esp
8010154c:	52                   	push   %edx
8010154d:	50                   	push   %eax
8010154e:	e8 61 ec ff ff       	call   801001b4 <bread>
80101553:	83 c4 10             	add    $0x10,%esp
80101556:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
80101559:	8b 45 0c             	mov    0xc(%ebp),%eax
8010155c:	25 ff 0f 00 00       	and    $0xfff,%eax
80101561:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
80101564:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101567:	99                   	cltd   
80101568:	c1 ea 1d             	shr    $0x1d,%edx
8010156b:	01 d0                	add    %edx,%eax
8010156d:	83 e0 07             	and    $0x7,%eax
80101570:	29 d0                	sub    %edx,%eax
80101572:	ba 01 00 00 00       	mov    $0x1,%edx
80101577:	89 c1                	mov    %eax,%ecx
80101579:	d3 e2                	shl    %cl,%edx
8010157b:	89 d0                	mov    %edx,%eax
8010157d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101580:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101583:	8d 50 07             	lea    0x7(%eax),%edx
80101586:	85 c0                	test   %eax,%eax
80101588:	0f 48 c2             	cmovs  %edx,%eax
8010158b:	c1 f8 03             	sar    $0x3,%eax
8010158e:	89 c2                	mov    %eax,%edx
80101590:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101593:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
80101598:	0f b6 c0             	movzbl %al,%eax
8010159b:	23 45 ec             	and    -0x14(%ebp),%eax
8010159e:	85 c0                	test   %eax,%eax
801015a0:	75 0d                	jne    801015af <bfree+0x91>
    panic("freeing free block");
801015a2:	83 ec 0c             	sub    $0xc,%esp
801015a5:	68 36 85 10 80       	push   $0x80108536
801015aa:	e8 ad ef ff ff       	call   8010055c <panic>
  bp->data[bi/8] &= ~m;
801015af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015b2:	8d 50 07             	lea    0x7(%eax),%edx
801015b5:	85 c0                	test   %eax,%eax
801015b7:	0f 48 c2             	cmovs  %edx,%eax
801015ba:	c1 f8 03             	sar    $0x3,%eax
801015bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015c0:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
801015c5:	89 d1                	mov    %edx,%ecx
801015c7:	8b 55 ec             	mov    -0x14(%ebp),%edx
801015ca:	f7 d2                	not    %edx
801015cc:	21 ca                	and    %ecx,%edx
801015ce:	89 d1                	mov    %edx,%ecx
801015d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015d3:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
801015d7:	83 ec 0c             	sub    $0xc,%esp
801015da:	ff 75 f4             	pushl  -0xc(%ebp)
801015dd:	e8 37 21 00 00       	call   80103719 <log_write>
801015e2:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801015e5:	83 ec 0c             	sub    $0xc,%esp
801015e8:	ff 75 f4             	pushl  -0xc(%ebp)
801015eb:	e8 3b ec ff ff       	call   8010022b <brelse>
801015f0:	83 c4 10             	add    $0x10,%esp
}
801015f3:	c9                   	leave  
801015f4:	c3                   	ret    

801015f5 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
801015f5:	55                   	push   %ebp
801015f6:	89 e5                	mov    %esp,%ebp
801015f8:	57                   	push   %edi
801015f9:	56                   	push   %esi
801015fa:	53                   	push   %ebx
801015fb:	83 ec 1c             	sub    $0x1c,%esp
  initlock(&icache.lock, "icache");
801015fe:	83 ec 08             	sub    $0x8,%esp
80101601:	68 49 85 10 80       	push   $0x80108549
80101606:	68 00 13 11 80       	push   $0x80111300
8010160b:	e8 4a 39 00 00       	call   80104f5a <initlock>
80101610:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
80101613:	83 ec 08             	sub    $0x8,%esp
80101616:	68 c0 12 11 80       	push   $0x801112c0
8010161b:	ff 75 08             	pushl  0x8(%ebp)
8010161e:	e8 1c fd ff ff       	call   8010133f <readsb>
80101623:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d inodestart %d bmap start %d\n", sb.size,
80101626:	a1 d8 12 11 80       	mov    0x801112d8,%eax
8010162b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010162e:	8b 3d d4 12 11 80    	mov    0x801112d4,%edi
80101634:	8b 35 d0 12 11 80    	mov    0x801112d0,%esi
8010163a:	8b 1d cc 12 11 80    	mov    0x801112cc,%ebx
80101640:	8b 0d c8 12 11 80    	mov    0x801112c8,%ecx
80101646:	8b 15 c4 12 11 80    	mov    0x801112c4,%edx
8010164c:	a1 c0 12 11 80       	mov    0x801112c0,%eax
80101651:	ff 75 e4             	pushl  -0x1c(%ebp)
80101654:	57                   	push   %edi
80101655:	56                   	push   %esi
80101656:	53                   	push   %ebx
80101657:	51                   	push   %ecx
80101658:	52                   	push   %edx
80101659:	50                   	push   %eax
8010165a:	68 50 85 10 80       	push   $0x80108550
8010165f:	e8 5b ed ff ff       	call   801003bf <cprintf>
80101664:	83 c4 20             	add    $0x20,%esp
          sb.nblocks, sb.ninodes, sb.nlog, sb.logstart, sb.inodestart, sb.bmapstart);
}
80101667:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010166a:	5b                   	pop    %ebx
8010166b:	5e                   	pop    %esi
8010166c:	5f                   	pop    %edi
8010166d:	5d                   	pop    %ebp
8010166e:	c3                   	ret    

8010166f <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
8010166f:	55                   	push   %ebp
80101670:	89 e5                	mov    %esp,%ebp
80101672:	83 ec 28             	sub    $0x28,%esp
80101675:	8b 45 0c             	mov    0xc(%ebp),%eax
80101678:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010167c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
80101683:	e9 9e 00 00 00       	jmp    80101726 <ialloc+0xb7>
    bp = bread(dev, IBLOCK(inum, sb));
80101688:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010168b:	c1 e8 03             	shr    $0x3,%eax
8010168e:	89 c2                	mov    %eax,%edx
80101690:	a1 d4 12 11 80       	mov    0x801112d4,%eax
80101695:	01 d0                	add    %edx,%eax
80101697:	83 ec 08             	sub    $0x8,%esp
8010169a:	50                   	push   %eax
8010169b:	ff 75 08             	pushl  0x8(%ebp)
8010169e:	e8 11 eb ff ff       	call   801001b4 <bread>
801016a3:	83 c4 10             	add    $0x10,%esp
801016a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
801016a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016ac:	8d 50 18             	lea    0x18(%eax),%edx
801016af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016b2:	83 e0 07             	and    $0x7,%eax
801016b5:	c1 e0 06             	shl    $0x6,%eax
801016b8:	01 d0                	add    %edx,%eax
801016ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
801016bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801016c0:	0f b7 00             	movzwl (%eax),%eax
801016c3:	66 85 c0             	test   %ax,%ax
801016c6:	75 4c                	jne    80101714 <ialloc+0xa5>
      memset(dip, 0, sizeof(*dip));
801016c8:	83 ec 04             	sub    $0x4,%esp
801016cb:	6a 40                	push   $0x40
801016cd:	6a 00                	push   $0x0
801016cf:	ff 75 ec             	pushl  -0x14(%ebp)
801016d2:	e8 00 3b 00 00       	call   801051d7 <memset>
801016d7:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
801016da:	8b 45 ec             	mov    -0x14(%ebp),%eax
801016dd:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
801016e1:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
801016e4:	83 ec 0c             	sub    $0xc,%esp
801016e7:	ff 75 f0             	pushl  -0x10(%ebp)
801016ea:	e8 2a 20 00 00       	call   80103719 <log_write>
801016ef:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
801016f2:	83 ec 0c             	sub    $0xc,%esp
801016f5:	ff 75 f0             	pushl  -0x10(%ebp)
801016f8:	e8 2e eb ff ff       	call   8010022b <brelse>
801016fd:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
80101700:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101703:	83 ec 08             	sub    $0x8,%esp
80101706:	50                   	push   %eax
80101707:	ff 75 08             	pushl  0x8(%ebp)
8010170a:	e8 f6 00 00 00       	call   80101805 <iget>
8010170f:	83 c4 10             	add    $0x10,%esp
80101712:	eb 2f                	jmp    80101743 <ialloc+0xd4>
    }
    brelse(bp);
80101714:	83 ec 0c             	sub    $0xc,%esp
80101717:	ff 75 f0             	pushl  -0x10(%ebp)
8010171a:	e8 0c eb ff ff       	call   8010022b <brelse>
8010171f:	83 c4 10             	add    $0x10,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101722:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101726:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101729:	a1 c8 12 11 80       	mov    0x801112c8,%eax
8010172e:	39 c2                	cmp    %eax,%edx
80101730:	0f 82 52 ff ff ff    	jb     80101688 <ialloc+0x19>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101736:	83 ec 0c             	sub    $0xc,%esp
80101739:	68 a3 85 10 80       	push   $0x801085a3
8010173e:	e8 19 ee ff ff       	call   8010055c <panic>
}
80101743:	c9                   	leave  
80101744:	c3                   	ret    

80101745 <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
80101745:	55                   	push   %ebp
80101746:	89 e5                	mov    %esp,%ebp
80101748:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010174b:	8b 45 08             	mov    0x8(%ebp),%eax
8010174e:	8b 40 04             	mov    0x4(%eax),%eax
80101751:	c1 e8 03             	shr    $0x3,%eax
80101754:	89 c2                	mov    %eax,%edx
80101756:	a1 d4 12 11 80       	mov    0x801112d4,%eax
8010175b:	01 c2                	add    %eax,%edx
8010175d:	8b 45 08             	mov    0x8(%ebp),%eax
80101760:	8b 00                	mov    (%eax),%eax
80101762:	83 ec 08             	sub    $0x8,%esp
80101765:	52                   	push   %edx
80101766:	50                   	push   %eax
80101767:	e8 48 ea ff ff       	call   801001b4 <bread>
8010176c:	83 c4 10             	add    $0x10,%esp
8010176f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101772:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101775:	8d 50 18             	lea    0x18(%eax),%edx
80101778:	8b 45 08             	mov    0x8(%ebp),%eax
8010177b:	8b 40 04             	mov    0x4(%eax),%eax
8010177e:	83 e0 07             	and    $0x7,%eax
80101781:	c1 e0 06             	shl    $0x6,%eax
80101784:	01 d0                	add    %edx,%eax
80101786:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
80101789:	8b 45 08             	mov    0x8(%ebp),%eax
8010178c:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101790:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101793:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101796:	8b 45 08             	mov    0x8(%ebp),%eax
80101799:	0f b7 50 12          	movzwl 0x12(%eax),%edx
8010179d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017a0:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
801017a4:	8b 45 08             	mov    0x8(%ebp),%eax
801017a7:	0f b7 50 14          	movzwl 0x14(%eax),%edx
801017ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017ae:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
801017b2:	8b 45 08             	mov    0x8(%ebp),%eax
801017b5:	0f b7 50 16          	movzwl 0x16(%eax),%edx
801017b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017bc:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
801017c0:	8b 45 08             	mov    0x8(%ebp),%eax
801017c3:	8b 50 18             	mov    0x18(%eax),%edx
801017c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017c9:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017cc:	8b 45 08             	mov    0x8(%ebp),%eax
801017cf:	8d 50 1c             	lea    0x1c(%eax),%edx
801017d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017d5:	83 c0 0c             	add    $0xc,%eax
801017d8:	83 ec 04             	sub    $0x4,%esp
801017db:	6a 34                	push   $0x34
801017dd:	52                   	push   %edx
801017de:	50                   	push   %eax
801017df:	e8 b2 3a 00 00       	call   80105296 <memmove>
801017e4:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801017e7:	83 ec 0c             	sub    $0xc,%esp
801017ea:	ff 75 f4             	pushl  -0xc(%ebp)
801017ed:	e8 27 1f 00 00       	call   80103719 <log_write>
801017f2:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801017f5:	83 ec 0c             	sub    $0xc,%esp
801017f8:	ff 75 f4             	pushl  -0xc(%ebp)
801017fb:	e8 2b ea ff ff       	call   8010022b <brelse>
80101800:	83 c4 10             	add    $0x10,%esp
}
80101803:	c9                   	leave  
80101804:	c3                   	ret    

80101805 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101805:	55                   	push   %ebp
80101806:	89 e5                	mov    %esp,%ebp
80101808:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
8010180b:	83 ec 0c             	sub    $0xc,%esp
8010180e:	68 00 13 11 80       	push   $0x80111300
80101813:	e8 63 37 00 00       	call   80104f7b <acquire>
80101818:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
8010181b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101822:	c7 45 f4 34 13 11 80 	movl   $0x80111334,-0xc(%ebp)
80101829:	eb 5d                	jmp    80101888 <iget+0x83>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010182b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010182e:	8b 40 08             	mov    0x8(%eax),%eax
80101831:	85 c0                	test   %eax,%eax
80101833:	7e 39                	jle    8010186e <iget+0x69>
80101835:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101838:	8b 00                	mov    (%eax),%eax
8010183a:	3b 45 08             	cmp    0x8(%ebp),%eax
8010183d:	75 2f                	jne    8010186e <iget+0x69>
8010183f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101842:	8b 40 04             	mov    0x4(%eax),%eax
80101845:	3b 45 0c             	cmp    0xc(%ebp),%eax
80101848:	75 24                	jne    8010186e <iget+0x69>
      ip->ref++;
8010184a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010184d:	8b 40 08             	mov    0x8(%eax),%eax
80101850:	8d 50 01             	lea    0x1(%eax),%edx
80101853:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101856:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101859:	83 ec 0c             	sub    $0xc,%esp
8010185c:	68 00 13 11 80       	push   $0x80111300
80101861:	e8 7b 37 00 00       	call   80104fe1 <release>
80101866:	83 c4 10             	add    $0x10,%esp
      return ip;
80101869:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010186c:	eb 74                	jmp    801018e2 <iget+0xdd>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
8010186e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101872:	75 10                	jne    80101884 <iget+0x7f>
80101874:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101877:	8b 40 08             	mov    0x8(%eax),%eax
8010187a:	85 c0                	test   %eax,%eax
8010187c:	75 06                	jne    80101884 <iget+0x7f>
      empty = ip;
8010187e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101881:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101884:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
80101888:	81 7d f4 d4 22 11 80 	cmpl   $0x801122d4,-0xc(%ebp)
8010188f:	72 9a                	jb     8010182b <iget+0x26>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101891:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101895:	75 0d                	jne    801018a4 <iget+0x9f>
    panic("iget: no inodes");
80101897:	83 ec 0c             	sub    $0xc,%esp
8010189a:	68 b5 85 10 80       	push   $0x801085b5
8010189f:	e8 b8 ec ff ff       	call   8010055c <panic>

  ip = empty;
801018a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
801018aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018ad:	8b 55 08             	mov    0x8(%ebp),%edx
801018b0:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
801018b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018b5:	8b 55 0c             	mov    0xc(%ebp),%edx
801018b8:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
801018bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018be:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
801018c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018c8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
801018cf:	83 ec 0c             	sub    $0xc,%esp
801018d2:	68 00 13 11 80       	push   $0x80111300
801018d7:	e8 05 37 00 00       	call   80104fe1 <release>
801018dc:	83 c4 10             	add    $0x10,%esp

  return ip;
801018df:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801018e2:	c9                   	leave  
801018e3:	c3                   	ret    

801018e4 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801018e4:	55                   	push   %ebp
801018e5:	89 e5                	mov    %esp,%ebp
801018e7:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
801018ea:	83 ec 0c             	sub    $0xc,%esp
801018ed:	68 00 13 11 80       	push   $0x80111300
801018f2:	e8 84 36 00 00       	call   80104f7b <acquire>
801018f7:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
801018fa:	8b 45 08             	mov    0x8(%ebp),%eax
801018fd:	8b 40 08             	mov    0x8(%eax),%eax
80101900:	8d 50 01             	lea    0x1(%eax),%edx
80101903:	8b 45 08             	mov    0x8(%ebp),%eax
80101906:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101909:	83 ec 0c             	sub    $0xc,%esp
8010190c:	68 00 13 11 80       	push   $0x80111300
80101911:	e8 cb 36 00 00       	call   80104fe1 <release>
80101916:	83 c4 10             	add    $0x10,%esp
  return ip;
80101919:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010191c:	c9                   	leave  
8010191d:	c3                   	ret    

8010191e <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
8010191e:	55                   	push   %ebp
8010191f:	89 e5                	mov    %esp,%ebp
80101921:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101924:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101928:	74 0a                	je     80101934 <ilock+0x16>
8010192a:	8b 45 08             	mov    0x8(%ebp),%eax
8010192d:	8b 40 08             	mov    0x8(%eax),%eax
80101930:	85 c0                	test   %eax,%eax
80101932:	7f 0d                	jg     80101941 <ilock+0x23>
    panic("ilock");
80101934:	83 ec 0c             	sub    $0xc,%esp
80101937:	68 c5 85 10 80       	push   $0x801085c5
8010193c:	e8 1b ec ff ff       	call   8010055c <panic>

  acquire(&icache.lock);
80101941:	83 ec 0c             	sub    $0xc,%esp
80101944:	68 00 13 11 80       	push   $0x80111300
80101949:	e8 2d 36 00 00       	call   80104f7b <acquire>
8010194e:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
80101951:	eb 13                	jmp    80101966 <ilock+0x48>
    sleep(ip, &icache.lock);
80101953:	83 ec 08             	sub    $0x8,%esp
80101956:	68 00 13 11 80       	push   $0x80111300
8010195b:	ff 75 08             	pushl  0x8(%ebp)
8010195e:	e8 28 33 00 00       	call   80104c8b <sleep>
80101963:	83 c4 10             	add    $0x10,%esp

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
80101966:	8b 45 08             	mov    0x8(%ebp),%eax
80101969:	8b 40 0c             	mov    0xc(%eax),%eax
8010196c:	83 e0 01             	and    $0x1,%eax
8010196f:	85 c0                	test   %eax,%eax
80101971:	75 e0                	jne    80101953 <ilock+0x35>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
80101973:	8b 45 08             	mov    0x8(%ebp),%eax
80101976:	8b 40 0c             	mov    0xc(%eax),%eax
80101979:	83 c8 01             	or     $0x1,%eax
8010197c:	89 c2                	mov    %eax,%edx
8010197e:	8b 45 08             	mov    0x8(%ebp),%eax
80101981:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
80101984:	83 ec 0c             	sub    $0xc,%esp
80101987:	68 00 13 11 80       	push   $0x80111300
8010198c:	e8 50 36 00 00       	call   80104fe1 <release>
80101991:	83 c4 10             	add    $0x10,%esp

  if(!(ip->flags & I_VALID)){
80101994:	8b 45 08             	mov    0x8(%ebp),%eax
80101997:	8b 40 0c             	mov    0xc(%eax),%eax
8010199a:	83 e0 02             	and    $0x2,%eax
8010199d:	85 c0                	test   %eax,%eax
8010199f:	0f 85 d4 00 00 00    	jne    80101a79 <ilock+0x15b>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801019a5:	8b 45 08             	mov    0x8(%ebp),%eax
801019a8:	8b 40 04             	mov    0x4(%eax),%eax
801019ab:	c1 e8 03             	shr    $0x3,%eax
801019ae:	89 c2                	mov    %eax,%edx
801019b0:	a1 d4 12 11 80       	mov    0x801112d4,%eax
801019b5:	01 c2                	add    %eax,%edx
801019b7:	8b 45 08             	mov    0x8(%ebp),%eax
801019ba:	8b 00                	mov    (%eax),%eax
801019bc:	83 ec 08             	sub    $0x8,%esp
801019bf:	52                   	push   %edx
801019c0:	50                   	push   %eax
801019c1:	e8 ee e7 ff ff       	call   801001b4 <bread>
801019c6:	83 c4 10             	add    $0x10,%esp
801019c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801019cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019cf:	8d 50 18             	lea    0x18(%eax),%edx
801019d2:	8b 45 08             	mov    0x8(%ebp),%eax
801019d5:	8b 40 04             	mov    0x4(%eax),%eax
801019d8:	83 e0 07             	and    $0x7,%eax
801019db:	c1 e0 06             	shl    $0x6,%eax
801019de:	01 d0                	add    %edx,%eax
801019e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
801019e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019e6:	0f b7 10             	movzwl (%eax),%edx
801019e9:	8b 45 08             	mov    0x8(%ebp),%eax
801019ec:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
801019f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019f3:	0f b7 50 02          	movzwl 0x2(%eax),%edx
801019f7:	8b 45 08             	mov    0x8(%ebp),%eax
801019fa:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
801019fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a01:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101a05:	8b 45 08             	mov    0x8(%ebp),%eax
80101a08:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
80101a0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a0f:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101a13:	8b 45 08             	mov    0x8(%ebp),%eax
80101a16:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
80101a1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a1d:	8b 50 08             	mov    0x8(%eax),%edx
80101a20:	8b 45 08             	mov    0x8(%ebp),%eax
80101a23:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a26:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a29:	8d 50 0c             	lea    0xc(%eax),%edx
80101a2c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a2f:	83 c0 1c             	add    $0x1c,%eax
80101a32:	83 ec 04             	sub    $0x4,%esp
80101a35:	6a 34                	push   $0x34
80101a37:	52                   	push   %edx
80101a38:	50                   	push   %eax
80101a39:	e8 58 38 00 00       	call   80105296 <memmove>
80101a3e:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101a41:	83 ec 0c             	sub    $0xc,%esp
80101a44:	ff 75 f4             	pushl  -0xc(%ebp)
80101a47:	e8 df e7 ff ff       	call   8010022b <brelse>
80101a4c:	83 c4 10             	add    $0x10,%esp
    ip->flags |= I_VALID;
80101a4f:	8b 45 08             	mov    0x8(%ebp),%eax
80101a52:	8b 40 0c             	mov    0xc(%eax),%eax
80101a55:	83 c8 02             	or     $0x2,%eax
80101a58:	89 c2                	mov    %eax,%edx
80101a5a:	8b 45 08             	mov    0x8(%ebp),%eax
80101a5d:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
80101a60:	8b 45 08             	mov    0x8(%ebp),%eax
80101a63:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101a67:	66 85 c0             	test   %ax,%ax
80101a6a:	75 0d                	jne    80101a79 <ilock+0x15b>
      panic("ilock: no type");
80101a6c:	83 ec 0c             	sub    $0xc,%esp
80101a6f:	68 cb 85 10 80       	push   $0x801085cb
80101a74:	e8 e3 ea ff ff       	call   8010055c <panic>
  }
}
80101a79:	c9                   	leave  
80101a7a:	c3                   	ret    

80101a7b <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101a7b:	55                   	push   %ebp
80101a7c:	89 e5                	mov    %esp,%ebp
80101a7e:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101a81:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101a85:	74 17                	je     80101a9e <iunlock+0x23>
80101a87:	8b 45 08             	mov    0x8(%ebp),%eax
80101a8a:	8b 40 0c             	mov    0xc(%eax),%eax
80101a8d:	83 e0 01             	and    $0x1,%eax
80101a90:	85 c0                	test   %eax,%eax
80101a92:	74 0a                	je     80101a9e <iunlock+0x23>
80101a94:	8b 45 08             	mov    0x8(%ebp),%eax
80101a97:	8b 40 08             	mov    0x8(%eax),%eax
80101a9a:	85 c0                	test   %eax,%eax
80101a9c:	7f 0d                	jg     80101aab <iunlock+0x30>
    panic("iunlock");
80101a9e:	83 ec 0c             	sub    $0xc,%esp
80101aa1:	68 da 85 10 80       	push   $0x801085da
80101aa6:	e8 b1 ea ff ff       	call   8010055c <panic>

  acquire(&icache.lock);
80101aab:	83 ec 0c             	sub    $0xc,%esp
80101aae:	68 00 13 11 80       	push   $0x80111300
80101ab3:	e8 c3 34 00 00       	call   80104f7b <acquire>
80101ab8:	83 c4 10             	add    $0x10,%esp
  ip->flags &= ~I_BUSY;
80101abb:	8b 45 08             	mov    0x8(%ebp),%eax
80101abe:	8b 40 0c             	mov    0xc(%eax),%eax
80101ac1:	83 e0 fe             	and    $0xfffffffe,%eax
80101ac4:	89 c2                	mov    %eax,%edx
80101ac6:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac9:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101acc:	83 ec 0c             	sub    $0xc,%esp
80101acf:	ff 75 08             	pushl  0x8(%ebp)
80101ad2:	e8 9d 32 00 00       	call   80104d74 <wakeup>
80101ad7:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101ada:	83 ec 0c             	sub    $0xc,%esp
80101add:	68 00 13 11 80       	push   $0x80111300
80101ae2:	e8 fa 34 00 00       	call   80104fe1 <release>
80101ae7:	83 c4 10             	add    $0x10,%esp
}
80101aea:	c9                   	leave  
80101aeb:	c3                   	ret    

80101aec <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101aec:	55                   	push   %ebp
80101aed:	89 e5                	mov    %esp,%ebp
80101aef:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101af2:	83 ec 0c             	sub    $0xc,%esp
80101af5:	68 00 13 11 80       	push   $0x80111300
80101afa:	e8 7c 34 00 00       	call   80104f7b <acquire>
80101aff:	83 c4 10             	add    $0x10,%esp
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101b02:	8b 45 08             	mov    0x8(%ebp),%eax
80101b05:	8b 40 08             	mov    0x8(%eax),%eax
80101b08:	83 f8 01             	cmp    $0x1,%eax
80101b0b:	0f 85 a9 00 00 00    	jne    80101bba <iput+0xce>
80101b11:	8b 45 08             	mov    0x8(%ebp),%eax
80101b14:	8b 40 0c             	mov    0xc(%eax),%eax
80101b17:	83 e0 02             	and    $0x2,%eax
80101b1a:	85 c0                	test   %eax,%eax
80101b1c:	0f 84 98 00 00 00    	je     80101bba <iput+0xce>
80101b22:	8b 45 08             	mov    0x8(%ebp),%eax
80101b25:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101b29:	66 85 c0             	test   %ax,%ax
80101b2c:	0f 85 88 00 00 00    	jne    80101bba <iput+0xce>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
80101b32:	8b 45 08             	mov    0x8(%ebp),%eax
80101b35:	8b 40 0c             	mov    0xc(%eax),%eax
80101b38:	83 e0 01             	and    $0x1,%eax
80101b3b:	85 c0                	test   %eax,%eax
80101b3d:	74 0d                	je     80101b4c <iput+0x60>
      panic("iput busy");
80101b3f:	83 ec 0c             	sub    $0xc,%esp
80101b42:	68 e2 85 10 80       	push   $0x801085e2
80101b47:	e8 10 ea ff ff       	call   8010055c <panic>
    ip->flags |= I_BUSY;
80101b4c:	8b 45 08             	mov    0x8(%ebp),%eax
80101b4f:	8b 40 0c             	mov    0xc(%eax),%eax
80101b52:	83 c8 01             	or     $0x1,%eax
80101b55:	89 c2                	mov    %eax,%edx
80101b57:	8b 45 08             	mov    0x8(%ebp),%eax
80101b5a:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101b5d:	83 ec 0c             	sub    $0xc,%esp
80101b60:	68 00 13 11 80       	push   $0x80111300
80101b65:	e8 77 34 00 00       	call   80104fe1 <release>
80101b6a:	83 c4 10             	add    $0x10,%esp
    itrunc(ip);
80101b6d:	83 ec 0c             	sub    $0xc,%esp
80101b70:	ff 75 08             	pushl  0x8(%ebp)
80101b73:	e8 a6 01 00 00       	call   80101d1e <itrunc>
80101b78:	83 c4 10             	add    $0x10,%esp
    ip->type = 0;
80101b7b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b7e:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101b84:	83 ec 0c             	sub    $0xc,%esp
80101b87:	ff 75 08             	pushl  0x8(%ebp)
80101b8a:	e8 b6 fb ff ff       	call   80101745 <iupdate>
80101b8f:	83 c4 10             	add    $0x10,%esp
    acquire(&icache.lock);
80101b92:	83 ec 0c             	sub    $0xc,%esp
80101b95:	68 00 13 11 80       	push   $0x80111300
80101b9a:	e8 dc 33 00 00       	call   80104f7b <acquire>
80101b9f:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101ba2:	8b 45 08             	mov    0x8(%ebp),%eax
80101ba5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101bac:	83 ec 0c             	sub    $0xc,%esp
80101baf:	ff 75 08             	pushl  0x8(%ebp)
80101bb2:	e8 bd 31 00 00       	call   80104d74 <wakeup>
80101bb7:	83 c4 10             	add    $0x10,%esp
  }
  ip->ref--;
80101bba:	8b 45 08             	mov    0x8(%ebp),%eax
80101bbd:	8b 40 08             	mov    0x8(%eax),%eax
80101bc0:	8d 50 ff             	lea    -0x1(%eax),%edx
80101bc3:	8b 45 08             	mov    0x8(%ebp),%eax
80101bc6:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101bc9:	83 ec 0c             	sub    $0xc,%esp
80101bcc:	68 00 13 11 80       	push   $0x80111300
80101bd1:	e8 0b 34 00 00       	call   80104fe1 <release>
80101bd6:	83 c4 10             	add    $0x10,%esp
}
80101bd9:	c9                   	leave  
80101bda:	c3                   	ret    

80101bdb <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101bdb:	55                   	push   %ebp
80101bdc:	89 e5                	mov    %esp,%ebp
80101bde:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101be1:	83 ec 0c             	sub    $0xc,%esp
80101be4:	ff 75 08             	pushl  0x8(%ebp)
80101be7:	e8 8f fe ff ff       	call   80101a7b <iunlock>
80101bec:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101bef:	83 ec 0c             	sub    $0xc,%esp
80101bf2:	ff 75 08             	pushl  0x8(%ebp)
80101bf5:	e8 f2 fe ff ff       	call   80101aec <iput>
80101bfa:	83 c4 10             	add    $0x10,%esp
}
80101bfd:	c9                   	leave  
80101bfe:	c3                   	ret    

80101bff <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101bff:	55                   	push   %ebp
80101c00:	89 e5                	mov    %esp,%ebp
80101c02:	53                   	push   %ebx
80101c03:	83 ec 14             	sub    $0x14,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101c06:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101c0a:	77 42                	ja     80101c4e <bmap+0x4f>
    if((addr = ip->addrs[bn]) == 0)
80101c0c:	8b 45 08             	mov    0x8(%ebp),%eax
80101c0f:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c12:	83 c2 04             	add    $0x4,%edx
80101c15:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c19:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c20:	75 24                	jne    80101c46 <bmap+0x47>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101c22:	8b 45 08             	mov    0x8(%ebp),%eax
80101c25:	8b 00                	mov    (%eax),%eax
80101c27:	83 ec 0c             	sub    $0xc,%esp
80101c2a:	50                   	push   %eax
80101c2b:	e8 a3 f7 ff ff       	call   801013d3 <balloc>
80101c30:	83 c4 10             	add    $0x10,%esp
80101c33:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c36:	8b 45 08             	mov    0x8(%ebp),%eax
80101c39:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c3c:	8d 4a 04             	lea    0x4(%edx),%ecx
80101c3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c42:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101c46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c49:	e9 cb 00 00 00       	jmp    80101d19 <bmap+0x11a>
  }
  bn -= NDIRECT;
80101c4e:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101c52:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101c56:	0f 87 b0 00 00 00    	ja     80101d0c <bmap+0x10d>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101c5c:	8b 45 08             	mov    0x8(%ebp),%eax
80101c5f:	8b 40 4c             	mov    0x4c(%eax),%eax
80101c62:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c65:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c69:	75 1d                	jne    80101c88 <bmap+0x89>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101c6b:	8b 45 08             	mov    0x8(%ebp),%eax
80101c6e:	8b 00                	mov    (%eax),%eax
80101c70:	83 ec 0c             	sub    $0xc,%esp
80101c73:	50                   	push   %eax
80101c74:	e8 5a f7 ff ff       	call   801013d3 <balloc>
80101c79:	83 c4 10             	add    $0x10,%esp
80101c7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c7f:	8b 45 08             	mov    0x8(%ebp),%eax
80101c82:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c85:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101c88:	8b 45 08             	mov    0x8(%ebp),%eax
80101c8b:	8b 00                	mov    (%eax),%eax
80101c8d:	83 ec 08             	sub    $0x8,%esp
80101c90:	ff 75 f4             	pushl  -0xc(%ebp)
80101c93:	50                   	push   %eax
80101c94:	e8 1b e5 ff ff       	call   801001b4 <bread>
80101c99:	83 c4 10             	add    $0x10,%esp
80101c9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101c9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ca2:	83 c0 18             	add    $0x18,%eax
80101ca5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101ca8:	8b 45 0c             	mov    0xc(%ebp),%eax
80101cab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101cb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101cb5:	01 d0                	add    %edx,%eax
80101cb7:	8b 00                	mov    (%eax),%eax
80101cb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cbc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101cc0:	75 37                	jne    80101cf9 <bmap+0xfa>
      a[bn] = addr = balloc(ip->dev);
80101cc2:	8b 45 0c             	mov    0xc(%ebp),%eax
80101cc5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101ccc:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ccf:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101cd2:	8b 45 08             	mov    0x8(%ebp),%eax
80101cd5:	8b 00                	mov    (%eax),%eax
80101cd7:	83 ec 0c             	sub    $0xc,%esp
80101cda:	50                   	push   %eax
80101cdb:	e8 f3 f6 ff ff       	call   801013d3 <balloc>
80101ce0:	83 c4 10             	add    $0x10,%esp
80101ce3:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101ce6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ce9:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101ceb:	83 ec 0c             	sub    $0xc,%esp
80101cee:	ff 75 f0             	pushl  -0x10(%ebp)
80101cf1:	e8 23 1a 00 00       	call   80103719 <log_write>
80101cf6:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101cf9:	83 ec 0c             	sub    $0xc,%esp
80101cfc:	ff 75 f0             	pushl  -0x10(%ebp)
80101cff:	e8 27 e5 ff ff       	call   8010022b <brelse>
80101d04:	83 c4 10             	add    $0x10,%esp
    return addr;
80101d07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d0a:	eb 0d                	jmp    80101d19 <bmap+0x11a>
  }

  panic("bmap: out of range");
80101d0c:	83 ec 0c             	sub    $0xc,%esp
80101d0f:	68 ec 85 10 80       	push   $0x801085ec
80101d14:	e8 43 e8 ff ff       	call   8010055c <panic>
}
80101d19:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101d1c:	c9                   	leave  
80101d1d:	c3                   	ret    

80101d1e <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101d1e:	55                   	push   %ebp
80101d1f:	89 e5                	mov    %esp,%ebp
80101d21:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101d24:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101d2b:	eb 45                	jmp    80101d72 <itrunc+0x54>
    if(ip->addrs[i]){
80101d2d:	8b 45 08             	mov    0x8(%ebp),%eax
80101d30:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d33:	83 c2 04             	add    $0x4,%edx
80101d36:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d3a:	85 c0                	test   %eax,%eax
80101d3c:	74 30                	je     80101d6e <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
80101d3e:	8b 45 08             	mov    0x8(%ebp),%eax
80101d41:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d44:	83 c2 04             	add    $0x4,%edx
80101d47:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d4b:	8b 55 08             	mov    0x8(%ebp),%edx
80101d4e:	8b 12                	mov    (%edx),%edx
80101d50:	83 ec 08             	sub    $0x8,%esp
80101d53:	50                   	push   %eax
80101d54:	52                   	push   %edx
80101d55:	e8 c4 f7 ff ff       	call   8010151e <bfree>
80101d5a:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101d5d:	8b 45 08             	mov    0x8(%ebp),%eax
80101d60:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d63:	83 c2 04             	add    $0x4,%edx
80101d66:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101d6d:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101d6e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101d72:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101d76:	7e b5                	jle    80101d2d <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101d78:	8b 45 08             	mov    0x8(%ebp),%eax
80101d7b:	8b 40 4c             	mov    0x4c(%eax),%eax
80101d7e:	85 c0                	test   %eax,%eax
80101d80:	0f 84 a1 00 00 00    	je     80101e27 <itrunc+0x109>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101d86:	8b 45 08             	mov    0x8(%ebp),%eax
80101d89:	8b 50 4c             	mov    0x4c(%eax),%edx
80101d8c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d8f:	8b 00                	mov    (%eax),%eax
80101d91:	83 ec 08             	sub    $0x8,%esp
80101d94:	52                   	push   %edx
80101d95:	50                   	push   %eax
80101d96:	e8 19 e4 ff ff       	call   801001b4 <bread>
80101d9b:	83 c4 10             	add    $0x10,%esp
80101d9e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101da1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101da4:	83 c0 18             	add    $0x18,%eax
80101da7:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101daa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101db1:	eb 3c                	jmp    80101def <itrunc+0xd1>
      if(a[j])
80101db3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101db6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101dbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101dc0:	01 d0                	add    %edx,%eax
80101dc2:	8b 00                	mov    (%eax),%eax
80101dc4:	85 c0                	test   %eax,%eax
80101dc6:	74 23                	je     80101deb <itrunc+0xcd>
        bfree(ip->dev, a[j]);
80101dc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101dcb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101dd2:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101dd5:	01 d0                	add    %edx,%eax
80101dd7:	8b 00                	mov    (%eax),%eax
80101dd9:	8b 55 08             	mov    0x8(%ebp),%edx
80101ddc:	8b 12                	mov    (%edx),%edx
80101dde:	83 ec 08             	sub    $0x8,%esp
80101de1:	50                   	push   %eax
80101de2:	52                   	push   %edx
80101de3:	e8 36 f7 ff ff       	call   8010151e <bfree>
80101de8:	83 c4 10             	add    $0x10,%esp
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101deb:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101def:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101df2:	83 f8 7f             	cmp    $0x7f,%eax
80101df5:	76 bc                	jbe    80101db3 <itrunc+0x95>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101df7:	83 ec 0c             	sub    $0xc,%esp
80101dfa:	ff 75 ec             	pushl  -0x14(%ebp)
80101dfd:	e8 29 e4 ff ff       	call   8010022b <brelse>
80101e02:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101e05:	8b 45 08             	mov    0x8(%ebp),%eax
80101e08:	8b 40 4c             	mov    0x4c(%eax),%eax
80101e0b:	8b 55 08             	mov    0x8(%ebp),%edx
80101e0e:	8b 12                	mov    (%edx),%edx
80101e10:	83 ec 08             	sub    $0x8,%esp
80101e13:	50                   	push   %eax
80101e14:	52                   	push   %edx
80101e15:	e8 04 f7 ff ff       	call   8010151e <bfree>
80101e1a:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80101e1d:	8b 45 08             	mov    0x8(%ebp),%eax
80101e20:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101e27:	8b 45 08             	mov    0x8(%ebp),%eax
80101e2a:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101e31:	83 ec 0c             	sub    $0xc,%esp
80101e34:	ff 75 08             	pushl  0x8(%ebp)
80101e37:	e8 09 f9 ff ff       	call   80101745 <iupdate>
80101e3c:	83 c4 10             	add    $0x10,%esp
}
80101e3f:	c9                   	leave  
80101e40:	c3                   	ret    

80101e41 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101e41:	55                   	push   %ebp
80101e42:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101e44:	8b 45 08             	mov    0x8(%ebp),%eax
80101e47:	8b 00                	mov    (%eax),%eax
80101e49:	89 c2                	mov    %eax,%edx
80101e4b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e4e:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101e51:	8b 45 08             	mov    0x8(%ebp),%eax
80101e54:	8b 50 04             	mov    0x4(%eax),%edx
80101e57:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e5a:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101e5d:	8b 45 08             	mov    0x8(%ebp),%eax
80101e60:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101e64:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e67:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101e6a:	8b 45 08             	mov    0x8(%ebp),%eax
80101e6d:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101e71:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e74:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101e78:	8b 45 08             	mov    0x8(%ebp),%eax
80101e7b:	8b 50 18             	mov    0x18(%eax),%edx
80101e7e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e81:	89 50 10             	mov    %edx,0x10(%eax)
}
80101e84:	5d                   	pop    %ebp
80101e85:	c3                   	ret    

80101e86 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101e86:	55                   	push   %ebp
80101e87:	89 e5                	mov    %esp,%ebp
80101e89:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101e8c:	8b 45 08             	mov    0x8(%ebp),%eax
80101e8f:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101e93:	66 83 f8 03          	cmp    $0x3,%ax
80101e97:	75 5c                	jne    80101ef5 <readi+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101e99:	8b 45 08             	mov    0x8(%ebp),%eax
80101e9c:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101ea0:	66 85 c0             	test   %ax,%ax
80101ea3:	78 20                	js     80101ec5 <readi+0x3f>
80101ea5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ea8:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101eac:	66 83 f8 09          	cmp    $0x9,%ax
80101eb0:	7f 13                	jg     80101ec5 <readi+0x3f>
80101eb2:	8b 45 08             	mov    0x8(%ebp),%eax
80101eb5:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101eb9:	98                   	cwtl   
80101eba:	8b 04 c5 40 12 11 80 	mov    -0x7feeedc0(,%eax,8),%eax
80101ec1:	85 c0                	test   %eax,%eax
80101ec3:	75 0a                	jne    80101ecf <readi+0x49>
      return -1;
80101ec5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101eca:	e9 0f 01 00 00       	jmp    80101fde <readi+0x158>
    return devsw[ip->major].read(ip, dst, n);
80101ecf:	8b 45 08             	mov    0x8(%ebp),%eax
80101ed2:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101ed6:	98                   	cwtl   
80101ed7:	8b 04 c5 40 12 11 80 	mov    -0x7feeedc0(,%eax,8),%eax
80101ede:	8b 55 14             	mov    0x14(%ebp),%edx
80101ee1:	83 ec 04             	sub    $0x4,%esp
80101ee4:	52                   	push   %edx
80101ee5:	ff 75 0c             	pushl  0xc(%ebp)
80101ee8:	ff 75 08             	pushl  0x8(%ebp)
80101eeb:	ff d0                	call   *%eax
80101eed:	83 c4 10             	add    $0x10,%esp
80101ef0:	e9 e9 00 00 00       	jmp    80101fde <readi+0x158>
  }

  if(off > ip->size || off + n < off)
80101ef5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ef8:	8b 40 18             	mov    0x18(%eax),%eax
80101efb:	3b 45 10             	cmp    0x10(%ebp),%eax
80101efe:	72 0d                	jb     80101f0d <readi+0x87>
80101f00:	8b 55 10             	mov    0x10(%ebp),%edx
80101f03:	8b 45 14             	mov    0x14(%ebp),%eax
80101f06:	01 d0                	add    %edx,%eax
80101f08:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f0b:	73 0a                	jae    80101f17 <readi+0x91>
    return -1;
80101f0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f12:	e9 c7 00 00 00       	jmp    80101fde <readi+0x158>
  if(off + n > ip->size)
80101f17:	8b 55 10             	mov    0x10(%ebp),%edx
80101f1a:	8b 45 14             	mov    0x14(%ebp),%eax
80101f1d:	01 c2                	add    %eax,%edx
80101f1f:	8b 45 08             	mov    0x8(%ebp),%eax
80101f22:	8b 40 18             	mov    0x18(%eax),%eax
80101f25:	39 c2                	cmp    %eax,%edx
80101f27:	76 0c                	jbe    80101f35 <readi+0xaf>
    n = ip->size - off;
80101f29:	8b 45 08             	mov    0x8(%ebp),%eax
80101f2c:	8b 40 18             	mov    0x18(%eax),%eax
80101f2f:	2b 45 10             	sub    0x10(%ebp),%eax
80101f32:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101f35:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101f3c:	e9 8e 00 00 00       	jmp    80101fcf <readi+0x149>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f41:	8b 45 10             	mov    0x10(%ebp),%eax
80101f44:	c1 e8 09             	shr    $0x9,%eax
80101f47:	83 ec 08             	sub    $0x8,%esp
80101f4a:	50                   	push   %eax
80101f4b:	ff 75 08             	pushl  0x8(%ebp)
80101f4e:	e8 ac fc ff ff       	call   80101bff <bmap>
80101f53:	83 c4 10             	add    $0x10,%esp
80101f56:	89 c2                	mov    %eax,%edx
80101f58:	8b 45 08             	mov    0x8(%ebp),%eax
80101f5b:	8b 00                	mov    (%eax),%eax
80101f5d:	83 ec 08             	sub    $0x8,%esp
80101f60:	52                   	push   %edx
80101f61:	50                   	push   %eax
80101f62:	e8 4d e2 ff ff       	call   801001b4 <bread>
80101f67:	83 c4 10             	add    $0x10,%esp
80101f6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101f6d:	8b 45 10             	mov    0x10(%ebp),%eax
80101f70:	25 ff 01 00 00       	and    $0x1ff,%eax
80101f75:	ba 00 02 00 00       	mov    $0x200,%edx
80101f7a:	29 c2                	sub    %eax,%edx
80101f7c:	8b 45 14             	mov    0x14(%ebp),%eax
80101f7f:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101f82:	39 c2                	cmp    %eax,%edx
80101f84:	0f 46 c2             	cmovbe %edx,%eax
80101f87:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101f8a:	8b 45 10             	mov    0x10(%ebp),%eax
80101f8d:	25 ff 01 00 00       	and    $0x1ff,%eax
80101f92:	8d 50 10             	lea    0x10(%eax),%edx
80101f95:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f98:	01 d0                	add    %edx,%eax
80101f9a:	83 c0 08             	add    $0x8,%eax
80101f9d:	83 ec 04             	sub    $0x4,%esp
80101fa0:	ff 75 ec             	pushl  -0x14(%ebp)
80101fa3:	50                   	push   %eax
80101fa4:	ff 75 0c             	pushl  0xc(%ebp)
80101fa7:	e8 ea 32 00 00       	call   80105296 <memmove>
80101fac:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101faf:	83 ec 0c             	sub    $0xc,%esp
80101fb2:	ff 75 f0             	pushl  -0x10(%ebp)
80101fb5:	e8 71 e2 ff ff       	call   8010022b <brelse>
80101fba:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101fbd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fc0:	01 45 f4             	add    %eax,-0xc(%ebp)
80101fc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fc6:	01 45 10             	add    %eax,0x10(%ebp)
80101fc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fcc:	01 45 0c             	add    %eax,0xc(%ebp)
80101fcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101fd2:	3b 45 14             	cmp    0x14(%ebp),%eax
80101fd5:	0f 82 66 ff ff ff    	jb     80101f41 <readi+0xbb>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101fdb:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101fde:	c9                   	leave  
80101fdf:	c3                   	ret    

80101fe0 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101fe0:	55                   	push   %ebp
80101fe1:	89 e5                	mov    %esp,%ebp
80101fe3:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101fe6:	8b 45 08             	mov    0x8(%ebp),%eax
80101fe9:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101fed:	66 83 f8 03          	cmp    $0x3,%ax
80101ff1:	75 5c                	jne    8010204f <writei+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101ff3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ff6:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101ffa:	66 85 c0             	test   %ax,%ax
80101ffd:	78 20                	js     8010201f <writei+0x3f>
80101fff:	8b 45 08             	mov    0x8(%ebp),%eax
80102002:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102006:	66 83 f8 09          	cmp    $0x9,%ax
8010200a:	7f 13                	jg     8010201f <writei+0x3f>
8010200c:	8b 45 08             	mov    0x8(%ebp),%eax
8010200f:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102013:	98                   	cwtl   
80102014:	8b 04 c5 44 12 11 80 	mov    -0x7feeedbc(,%eax,8),%eax
8010201b:	85 c0                	test   %eax,%eax
8010201d:	75 0a                	jne    80102029 <writei+0x49>
      return -1;
8010201f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102024:	e9 40 01 00 00       	jmp    80102169 <writei+0x189>
    return devsw[ip->major].write(ip, src, n);
80102029:	8b 45 08             	mov    0x8(%ebp),%eax
8010202c:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102030:	98                   	cwtl   
80102031:	8b 04 c5 44 12 11 80 	mov    -0x7feeedbc(,%eax,8),%eax
80102038:	8b 55 14             	mov    0x14(%ebp),%edx
8010203b:	83 ec 04             	sub    $0x4,%esp
8010203e:	52                   	push   %edx
8010203f:	ff 75 0c             	pushl  0xc(%ebp)
80102042:	ff 75 08             	pushl  0x8(%ebp)
80102045:	ff d0                	call   *%eax
80102047:	83 c4 10             	add    $0x10,%esp
8010204a:	e9 1a 01 00 00       	jmp    80102169 <writei+0x189>
  }

  if(off > ip->size || off + n < off)
8010204f:	8b 45 08             	mov    0x8(%ebp),%eax
80102052:	8b 40 18             	mov    0x18(%eax),%eax
80102055:	3b 45 10             	cmp    0x10(%ebp),%eax
80102058:	72 0d                	jb     80102067 <writei+0x87>
8010205a:	8b 55 10             	mov    0x10(%ebp),%edx
8010205d:	8b 45 14             	mov    0x14(%ebp),%eax
80102060:	01 d0                	add    %edx,%eax
80102062:	3b 45 10             	cmp    0x10(%ebp),%eax
80102065:	73 0a                	jae    80102071 <writei+0x91>
    return -1;
80102067:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010206c:	e9 f8 00 00 00       	jmp    80102169 <writei+0x189>
  if(off + n > MAXFILE*BSIZE)
80102071:	8b 55 10             	mov    0x10(%ebp),%edx
80102074:	8b 45 14             	mov    0x14(%ebp),%eax
80102077:	01 d0                	add    %edx,%eax
80102079:	3d 00 18 01 00       	cmp    $0x11800,%eax
8010207e:	76 0a                	jbe    8010208a <writei+0xaa>
    return -1;
80102080:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102085:	e9 df 00 00 00       	jmp    80102169 <writei+0x189>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010208a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102091:	e9 9c 00 00 00       	jmp    80102132 <writei+0x152>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102096:	8b 45 10             	mov    0x10(%ebp),%eax
80102099:	c1 e8 09             	shr    $0x9,%eax
8010209c:	83 ec 08             	sub    $0x8,%esp
8010209f:	50                   	push   %eax
801020a0:	ff 75 08             	pushl  0x8(%ebp)
801020a3:	e8 57 fb ff ff       	call   80101bff <bmap>
801020a8:	83 c4 10             	add    $0x10,%esp
801020ab:	89 c2                	mov    %eax,%edx
801020ad:	8b 45 08             	mov    0x8(%ebp),%eax
801020b0:	8b 00                	mov    (%eax),%eax
801020b2:	83 ec 08             	sub    $0x8,%esp
801020b5:	52                   	push   %edx
801020b6:	50                   	push   %eax
801020b7:	e8 f8 e0 ff ff       	call   801001b4 <bread>
801020bc:	83 c4 10             	add    $0x10,%esp
801020bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801020c2:	8b 45 10             	mov    0x10(%ebp),%eax
801020c5:	25 ff 01 00 00       	and    $0x1ff,%eax
801020ca:	ba 00 02 00 00       	mov    $0x200,%edx
801020cf:	29 c2                	sub    %eax,%edx
801020d1:	8b 45 14             	mov    0x14(%ebp),%eax
801020d4:	2b 45 f4             	sub    -0xc(%ebp),%eax
801020d7:	39 c2                	cmp    %eax,%edx
801020d9:	0f 46 c2             	cmovbe %edx,%eax
801020dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
801020df:	8b 45 10             	mov    0x10(%ebp),%eax
801020e2:	25 ff 01 00 00       	and    $0x1ff,%eax
801020e7:	8d 50 10             	lea    0x10(%eax),%edx
801020ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801020ed:	01 d0                	add    %edx,%eax
801020ef:	83 c0 08             	add    $0x8,%eax
801020f2:	83 ec 04             	sub    $0x4,%esp
801020f5:	ff 75 ec             	pushl  -0x14(%ebp)
801020f8:	ff 75 0c             	pushl  0xc(%ebp)
801020fb:	50                   	push   %eax
801020fc:	e8 95 31 00 00       	call   80105296 <memmove>
80102101:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
80102104:	83 ec 0c             	sub    $0xc,%esp
80102107:	ff 75 f0             	pushl  -0x10(%ebp)
8010210a:	e8 0a 16 00 00       	call   80103719 <log_write>
8010210f:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80102112:	83 ec 0c             	sub    $0xc,%esp
80102115:	ff 75 f0             	pushl  -0x10(%ebp)
80102118:	e8 0e e1 ff ff       	call   8010022b <brelse>
8010211d:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102120:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102123:	01 45 f4             	add    %eax,-0xc(%ebp)
80102126:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102129:	01 45 10             	add    %eax,0x10(%ebp)
8010212c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010212f:	01 45 0c             	add    %eax,0xc(%ebp)
80102132:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102135:	3b 45 14             	cmp    0x14(%ebp),%eax
80102138:	0f 82 58 ff ff ff    	jb     80102096 <writei+0xb6>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
8010213e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102142:	74 22                	je     80102166 <writei+0x186>
80102144:	8b 45 08             	mov    0x8(%ebp),%eax
80102147:	8b 40 18             	mov    0x18(%eax),%eax
8010214a:	3b 45 10             	cmp    0x10(%ebp),%eax
8010214d:	73 17                	jae    80102166 <writei+0x186>
    ip->size = off;
8010214f:	8b 45 08             	mov    0x8(%ebp),%eax
80102152:	8b 55 10             	mov    0x10(%ebp),%edx
80102155:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
80102158:	83 ec 0c             	sub    $0xc,%esp
8010215b:	ff 75 08             	pushl  0x8(%ebp)
8010215e:	e8 e2 f5 ff ff       	call   80101745 <iupdate>
80102163:	83 c4 10             	add    $0x10,%esp
  }
  return n;
80102166:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102169:	c9                   	leave  
8010216a:	c3                   	ret    

8010216b <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
8010216b:	55                   	push   %ebp
8010216c:	89 e5                	mov    %esp,%ebp
8010216e:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
80102171:	83 ec 04             	sub    $0x4,%esp
80102174:	6a 0e                	push   $0xe
80102176:	ff 75 0c             	pushl  0xc(%ebp)
80102179:	ff 75 08             	pushl  0x8(%ebp)
8010217c:	e8 ad 31 00 00       	call   8010532e <strncmp>
80102181:	83 c4 10             	add    $0x10,%esp
}
80102184:	c9                   	leave  
80102185:	c3                   	ret    

80102186 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102186:	55                   	push   %ebp
80102187:	89 e5                	mov    %esp,%ebp
80102189:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
8010218c:	8b 45 08             	mov    0x8(%ebp),%eax
8010218f:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102193:	66 83 f8 01          	cmp    $0x1,%ax
80102197:	74 0d                	je     801021a6 <dirlookup+0x20>
    panic("dirlookup not DIR");
80102199:	83 ec 0c             	sub    $0xc,%esp
8010219c:	68 ff 85 10 80       	push   $0x801085ff
801021a1:	e8 b6 e3 ff ff       	call   8010055c <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
801021a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801021ad:	eb 7c                	jmp    8010222b <dirlookup+0xa5>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021af:	6a 10                	push   $0x10
801021b1:	ff 75 f4             	pushl  -0xc(%ebp)
801021b4:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021b7:	50                   	push   %eax
801021b8:	ff 75 08             	pushl  0x8(%ebp)
801021bb:	e8 c6 fc ff ff       	call   80101e86 <readi>
801021c0:	83 c4 10             	add    $0x10,%esp
801021c3:	83 f8 10             	cmp    $0x10,%eax
801021c6:	74 0d                	je     801021d5 <dirlookup+0x4f>
      panic("dirlink read");
801021c8:	83 ec 0c             	sub    $0xc,%esp
801021cb:	68 11 86 10 80       	push   $0x80108611
801021d0:	e8 87 e3 ff ff       	call   8010055c <panic>
    if(de.inum == 0)
801021d5:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801021d9:	66 85 c0             	test   %ax,%ax
801021dc:	75 02                	jne    801021e0 <dirlookup+0x5a>
      continue;
801021de:	eb 47                	jmp    80102227 <dirlookup+0xa1>
    if(namecmp(name, de.name) == 0){
801021e0:	83 ec 08             	sub    $0x8,%esp
801021e3:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021e6:	83 c0 02             	add    $0x2,%eax
801021e9:	50                   	push   %eax
801021ea:	ff 75 0c             	pushl  0xc(%ebp)
801021ed:	e8 79 ff ff ff       	call   8010216b <namecmp>
801021f2:	83 c4 10             	add    $0x10,%esp
801021f5:	85 c0                	test   %eax,%eax
801021f7:	75 2e                	jne    80102227 <dirlookup+0xa1>
      // entry matches path element
      if(poff)
801021f9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801021fd:	74 08                	je     80102207 <dirlookup+0x81>
        *poff = off;
801021ff:	8b 45 10             	mov    0x10(%ebp),%eax
80102202:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102205:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
80102207:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010220b:	0f b7 c0             	movzwl %ax,%eax
8010220e:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
80102211:	8b 45 08             	mov    0x8(%ebp),%eax
80102214:	8b 00                	mov    (%eax),%eax
80102216:	83 ec 08             	sub    $0x8,%esp
80102219:	ff 75 f0             	pushl  -0x10(%ebp)
8010221c:	50                   	push   %eax
8010221d:	e8 e3 f5 ff ff       	call   80101805 <iget>
80102222:	83 c4 10             	add    $0x10,%esp
80102225:	eb 18                	jmp    8010223f <dirlookup+0xb9>
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80102227:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010222b:	8b 45 08             	mov    0x8(%ebp),%eax
8010222e:	8b 40 18             	mov    0x18(%eax),%eax
80102231:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80102234:	0f 87 75 ff ff ff    	ja     801021af <dirlookup+0x29>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
8010223a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010223f:	c9                   	leave  
80102240:	c3                   	ret    

80102241 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102241:	55                   	push   %ebp
80102242:	89 e5                	mov    %esp,%ebp
80102244:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80102247:	83 ec 04             	sub    $0x4,%esp
8010224a:	6a 00                	push   $0x0
8010224c:	ff 75 0c             	pushl  0xc(%ebp)
8010224f:	ff 75 08             	pushl  0x8(%ebp)
80102252:	e8 2f ff ff ff       	call   80102186 <dirlookup>
80102257:	83 c4 10             	add    $0x10,%esp
8010225a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010225d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102261:	74 18                	je     8010227b <dirlink+0x3a>
    iput(ip);
80102263:	83 ec 0c             	sub    $0xc,%esp
80102266:	ff 75 f0             	pushl  -0x10(%ebp)
80102269:	e8 7e f8 ff ff       	call   80101aec <iput>
8010226e:	83 c4 10             	add    $0x10,%esp
    return -1;
80102271:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102276:	e9 9b 00 00 00       	jmp    80102316 <dirlink+0xd5>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
8010227b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102282:	eb 3b                	jmp    801022bf <dirlink+0x7e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102284:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102287:	6a 10                	push   $0x10
80102289:	50                   	push   %eax
8010228a:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010228d:	50                   	push   %eax
8010228e:	ff 75 08             	pushl  0x8(%ebp)
80102291:	e8 f0 fb ff ff       	call   80101e86 <readi>
80102296:	83 c4 10             	add    $0x10,%esp
80102299:	83 f8 10             	cmp    $0x10,%eax
8010229c:	74 0d                	je     801022ab <dirlink+0x6a>
      panic("dirlink read");
8010229e:	83 ec 0c             	sub    $0xc,%esp
801022a1:	68 11 86 10 80       	push   $0x80108611
801022a6:	e8 b1 e2 ff ff       	call   8010055c <panic>
    if(de.inum == 0)
801022ab:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801022af:	66 85 c0             	test   %ax,%ax
801022b2:	75 02                	jne    801022b6 <dirlink+0x75>
      break;
801022b4:	eb 16                	jmp    801022cc <dirlink+0x8b>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801022b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022b9:	83 c0 10             	add    $0x10,%eax
801022bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
801022bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
801022c2:	8b 45 08             	mov    0x8(%ebp),%eax
801022c5:	8b 40 18             	mov    0x18(%eax),%eax
801022c8:	39 c2                	cmp    %eax,%edx
801022ca:	72 b8                	jb     80102284 <dirlink+0x43>
      panic("dirlink read");
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
801022cc:	83 ec 04             	sub    $0x4,%esp
801022cf:	6a 0e                	push   $0xe
801022d1:	ff 75 0c             	pushl  0xc(%ebp)
801022d4:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022d7:	83 c0 02             	add    $0x2,%eax
801022da:	50                   	push   %eax
801022db:	e8 a4 30 00 00       	call   80105384 <strncpy>
801022e0:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
801022e3:	8b 45 10             	mov    0x10(%ebp),%eax
801022e6:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801022ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022ed:	6a 10                	push   $0x10
801022ef:	50                   	push   %eax
801022f0:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022f3:	50                   	push   %eax
801022f4:	ff 75 08             	pushl  0x8(%ebp)
801022f7:	e8 e4 fc ff ff       	call   80101fe0 <writei>
801022fc:	83 c4 10             	add    $0x10,%esp
801022ff:	83 f8 10             	cmp    $0x10,%eax
80102302:	74 0d                	je     80102311 <dirlink+0xd0>
    panic("dirlink");
80102304:	83 ec 0c             	sub    $0xc,%esp
80102307:	68 1e 86 10 80       	push   $0x8010861e
8010230c:	e8 4b e2 ff ff       	call   8010055c <panic>
  
  return 0;
80102311:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102316:	c9                   	leave  
80102317:	c3                   	ret    

80102318 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80102318:	55                   	push   %ebp
80102319:	89 e5                	mov    %esp,%ebp
8010231b:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
8010231e:	eb 04                	jmp    80102324 <skipelem+0xc>
    path++;
80102320:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80102324:	8b 45 08             	mov    0x8(%ebp),%eax
80102327:	0f b6 00             	movzbl (%eax),%eax
8010232a:	3c 2f                	cmp    $0x2f,%al
8010232c:	74 f2                	je     80102320 <skipelem+0x8>
    path++;
  if(*path == 0)
8010232e:	8b 45 08             	mov    0x8(%ebp),%eax
80102331:	0f b6 00             	movzbl (%eax),%eax
80102334:	84 c0                	test   %al,%al
80102336:	75 07                	jne    8010233f <skipelem+0x27>
    return 0;
80102338:	b8 00 00 00 00       	mov    $0x0,%eax
8010233d:	eb 7b                	jmp    801023ba <skipelem+0xa2>
  s = path;
8010233f:	8b 45 08             	mov    0x8(%ebp),%eax
80102342:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
80102345:	eb 04                	jmp    8010234b <skipelem+0x33>
    path++;
80102347:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
8010234b:	8b 45 08             	mov    0x8(%ebp),%eax
8010234e:	0f b6 00             	movzbl (%eax),%eax
80102351:	3c 2f                	cmp    $0x2f,%al
80102353:	74 0a                	je     8010235f <skipelem+0x47>
80102355:	8b 45 08             	mov    0x8(%ebp),%eax
80102358:	0f b6 00             	movzbl (%eax),%eax
8010235b:	84 c0                	test   %al,%al
8010235d:	75 e8                	jne    80102347 <skipelem+0x2f>
    path++;
  len = path - s;
8010235f:	8b 55 08             	mov    0x8(%ebp),%edx
80102362:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102365:	29 c2                	sub    %eax,%edx
80102367:	89 d0                	mov    %edx,%eax
80102369:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
8010236c:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
80102370:	7e 15                	jle    80102387 <skipelem+0x6f>
    memmove(name, s, DIRSIZ);
80102372:	83 ec 04             	sub    $0x4,%esp
80102375:	6a 0e                	push   $0xe
80102377:	ff 75 f4             	pushl  -0xc(%ebp)
8010237a:	ff 75 0c             	pushl  0xc(%ebp)
8010237d:	e8 14 2f 00 00       	call   80105296 <memmove>
80102382:	83 c4 10             	add    $0x10,%esp
80102385:	eb 20                	jmp    801023a7 <skipelem+0x8f>
  else {
    memmove(name, s, len);
80102387:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010238a:	83 ec 04             	sub    $0x4,%esp
8010238d:	50                   	push   %eax
8010238e:	ff 75 f4             	pushl  -0xc(%ebp)
80102391:	ff 75 0c             	pushl  0xc(%ebp)
80102394:	e8 fd 2e 00 00       	call   80105296 <memmove>
80102399:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
8010239c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010239f:	8b 45 0c             	mov    0xc(%ebp),%eax
801023a2:	01 d0                	add    %edx,%eax
801023a4:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
801023a7:	eb 04                	jmp    801023ad <skipelem+0x95>
    path++;
801023a9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801023ad:	8b 45 08             	mov    0x8(%ebp),%eax
801023b0:	0f b6 00             	movzbl (%eax),%eax
801023b3:	3c 2f                	cmp    $0x2f,%al
801023b5:	74 f2                	je     801023a9 <skipelem+0x91>
    path++;
  return path;
801023b7:	8b 45 08             	mov    0x8(%ebp),%eax
}
801023ba:	c9                   	leave  
801023bb:	c3                   	ret    

801023bc <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801023bc:	55                   	push   %ebp
801023bd:	89 e5                	mov    %esp,%ebp
801023bf:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
801023c2:	8b 45 08             	mov    0x8(%ebp),%eax
801023c5:	0f b6 00             	movzbl (%eax),%eax
801023c8:	3c 2f                	cmp    $0x2f,%al
801023ca:	75 14                	jne    801023e0 <namex+0x24>
    ip = iget(ROOTDEV, ROOTINO);
801023cc:	83 ec 08             	sub    $0x8,%esp
801023cf:	6a 01                	push   $0x1
801023d1:	6a 01                	push   $0x1
801023d3:	e8 2d f4 ff ff       	call   80101805 <iget>
801023d8:	83 c4 10             	add    $0x10,%esp
801023db:	89 45 f4             	mov    %eax,-0xc(%ebp)
801023de:	eb 18                	jmp    801023f8 <namex+0x3c>
  else
    ip = idup(proc->cwd);
801023e0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801023e6:	8b 40 68             	mov    0x68(%eax),%eax
801023e9:	83 ec 0c             	sub    $0xc,%esp
801023ec:	50                   	push   %eax
801023ed:	e8 f2 f4 ff ff       	call   801018e4 <idup>
801023f2:	83 c4 10             	add    $0x10,%esp
801023f5:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
801023f8:	e9 9e 00 00 00       	jmp    8010249b <namex+0xdf>
    ilock(ip);
801023fd:	83 ec 0c             	sub    $0xc,%esp
80102400:	ff 75 f4             	pushl  -0xc(%ebp)
80102403:	e8 16 f5 ff ff       	call   8010191e <ilock>
80102408:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
8010240b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010240e:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102412:	66 83 f8 01          	cmp    $0x1,%ax
80102416:	74 18                	je     80102430 <namex+0x74>
      iunlockput(ip);
80102418:	83 ec 0c             	sub    $0xc,%esp
8010241b:	ff 75 f4             	pushl  -0xc(%ebp)
8010241e:	e8 b8 f7 ff ff       	call   80101bdb <iunlockput>
80102423:	83 c4 10             	add    $0x10,%esp
      return 0;
80102426:	b8 00 00 00 00       	mov    $0x0,%eax
8010242b:	e9 a7 00 00 00       	jmp    801024d7 <namex+0x11b>
    }
    if(nameiparent && *path == '\0'){
80102430:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102434:	74 20                	je     80102456 <namex+0x9a>
80102436:	8b 45 08             	mov    0x8(%ebp),%eax
80102439:	0f b6 00             	movzbl (%eax),%eax
8010243c:	84 c0                	test   %al,%al
8010243e:	75 16                	jne    80102456 <namex+0x9a>
      // Stop one level early.
      iunlock(ip);
80102440:	83 ec 0c             	sub    $0xc,%esp
80102443:	ff 75 f4             	pushl  -0xc(%ebp)
80102446:	e8 30 f6 ff ff       	call   80101a7b <iunlock>
8010244b:	83 c4 10             	add    $0x10,%esp
      return ip;
8010244e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102451:	e9 81 00 00 00       	jmp    801024d7 <namex+0x11b>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102456:	83 ec 04             	sub    $0x4,%esp
80102459:	6a 00                	push   $0x0
8010245b:	ff 75 10             	pushl  0x10(%ebp)
8010245e:	ff 75 f4             	pushl  -0xc(%ebp)
80102461:	e8 20 fd ff ff       	call   80102186 <dirlookup>
80102466:	83 c4 10             	add    $0x10,%esp
80102469:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010246c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102470:	75 15                	jne    80102487 <namex+0xcb>
      iunlockput(ip);
80102472:	83 ec 0c             	sub    $0xc,%esp
80102475:	ff 75 f4             	pushl  -0xc(%ebp)
80102478:	e8 5e f7 ff ff       	call   80101bdb <iunlockput>
8010247d:	83 c4 10             	add    $0x10,%esp
      return 0;
80102480:	b8 00 00 00 00       	mov    $0x0,%eax
80102485:	eb 50                	jmp    801024d7 <namex+0x11b>
    }
    iunlockput(ip);
80102487:	83 ec 0c             	sub    $0xc,%esp
8010248a:	ff 75 f4             	pushl  -0xc(%ebp)
8010248d:	e8 49 f7 ff ff       	call   80101bdb <iunlockput>
80102492:	83 c4 10             	add    $0x10,%esp
    ip = next;
80102495:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102498:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
8010249b:	83 ec 08             	sub    $0x8,%esp
8010249e:	ff 75 10             	pushl  0x10(%ebp)
801024a1:	ff 75 08             	pushl  0x8(%ebp)
801024a4:	e8 6f fe ff ff       	call   80102318 <skipelem>
801024a9:	83 c4 10             	add    $0x10,%esp
801024ac:	89 45 08             	mov    %eax,0x8(%ebp)
801024af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801024b3:	0f 85 44 ff ff ff    	jne    801023fd <namex+0x41>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801024b9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801024bd:	74 15                	je     801024d4 <namex+0x118>
    iput(ip);
801024bf:	83 ec 0c             	sub    $0xc,%esp
801024c2:	ff 75 f4             	pushl  -0xc(%ebp)
801024c5:	e8 22 f6 ff ff       	call   80101aec <iput>
801024ca:	83 c4 10             	add    $0x10,%esp
    return 0;
801024cd:	b8 00 00 00 00       	mov    $0x0,%eax
801024d2:	eb 03                	jmp    801024d7 <namex+0x11b>
  }
  return ip;
801024d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801024d7:	c9                   	leave  
801024d8:	c3                   	ret    

801024d9 <namei>:

struct inode*
namei(char *path)
{
801024d9:	55                   	push   %ebp
801024da:	89 e5                	mov    %esp,%ebp
801024dc:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
801024df:	83 ec 04             	sub    $0x4,%esp
801024e2:	8d 45 ea             	lea    -0x16(%ebp),%eax
801024e5:	50                   	push   %eax
801024e6:	6a 00                	push   $0x0
801024e8:	ff 75 08             	pushl  0x8(%ebp)
801024eb:	e8 cc fe ff ff       	call   801023bc <namex>
801024f0:	83 c4 10             	add    $0x10,%esp
}
801024f3:	c9                   	leave  
801024f4:	c3                   	ret    

801024f5 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801024f5:	55                   	push   %ebp
801024f6:	89 e5                	mov    %esp,%ebp
801024f8:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
801024fb:	83 ec 04             	sub    $0x4,%esp
801024fe:	ff 75 0c             	pushl  0xc(%ebp)
80102501:	6a 01                	push   $0x1
80102503:	ff 75 08             	pushl  0x8(%ebp)
80102506:	e8 b1 fe ff ff       	call   801023bc <namex>
8010250b:	83 c4 10             	add    $0x10,%esp
}
8010250e:	c9                   	leave  
8010250f:	c3                   	ret    

80102510 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102510:	55                   	push   %ebp
80102511:	89 e5                	mov    %esp,%ebp
80102513:	83 ec 14             	sub    $0x14,%esp
80102516:	8b 45 08             	mov    0x8(%ebp),%eax
80102519:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010251d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102521:	89 c2                	mov    %eax,%edx
80102523:	ec                   	in     (%dx),%al
80102524:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102527:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
8010252b:	c9                   	leave  
8010252c:	c3                   	ret    

8010252d <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
8010252d:	55                   	push   %ebp
8010252e:	89 e5                	mov    %esp,%ebp
80102530:	57                   	push   %edi
80102531:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
80102532:	8b 55 08             	mov    0x8(%ebp),%edx
80102535:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102538:	8b 45 10             	mov    0x10(%ebp),%eax
8010253b:	89 cb                	mov    %ecx,%ebx
8010253d:	89 df                	mov    %ebx,%edi
8010253f:	89 c1                	mov    %eax,%ecx
80102541:	fc                   	cld    
80102542:	f3 6d                	rep insl (%dx),%es:(%edi)
80102544:	89 c8                	mov    %ecx,%eax
80102546:	89 fb                	mov    %edi,%ebx
80102548:	89 5d 0c             	mov    %ebx,0xc(%ebp)
8010254b:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
8010254e:	5b                   	pop    %ebx
8010254f:	5f                   	pop    %edi
80102550:	5d                   	pop    %ebp
80102551:	c3                   	ret    

80102552 <outb>:

static inline void
outb(ushort port, uchar data)
{
80102552:	55                   	push   %ebp
80102553:	89 e5                	mov    %esp,%ebp
80102555:	83 ec 08             	sub    $0x8,%esp
80102558:	8b 55 08             	mov    0x8(%ebp),%edx
8010255b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010255e:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102562:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102565:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102569:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010256d:	ee                   	out    %al,(%dx)
}
8010256e:	c9                   	leave  
8010256f:	c3                   	ret    

80102570 <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
80102570:	55                   	push   %ebp
80102571:	89 e5                	mov    %esp,%ebp
80102573:	56                   	push   %esi
80102574:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
80102575:	8b 55 08             	mov    0x8(%ebp),%edx
80102578:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010257b:	8b 45 10             	mov    0x10(%ebp),%eax
8010257e:	89 cb                	mov    %ecx,%ebx
80102580:	89 de                	mov    %ebx,%esi
80102582:	89 c1                	mov    %eax,%ecx
80102584:	fc                   	cld    
80102585:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80102587:	89 c8                	mov    %ecx,%eax
80102589:	89 f3                	mov    %esi,%ebx
8010258b:	89 5d 0c             	mov    %ebx,0xc(%ebp)
8010258e:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
80102591:	5b                   	pop    %ebx
80102592:	5e                   	pop    %esi
80102593:	5d                   	pop    %ebp
80102594:	c3                   	ret    

80102595 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80102595:	55                   	push   %ebp
80102596:	89 e5                	mov    %esp,%ebp
80102598:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
8010259b:	90                   	nop
8010259c:	68 f7 01 00 00       	push   $0x1f7
801025a1:	e8 6a ff ff ff       	call   80102510 <inb>
801025a6:	83 c4 04             	add    $0x4,%esp
801025a9:	0f b6 c0             	movzbl %al,%eax
801025ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
801025af:	8b 45 fc             	mov    -0x4(%ebp),%eax
801025b2:	25 c0 00 00 00       	and    $0xc0,%eax
801025b7:	83 f8 40             	cmp    $0x40,%eax
801025ba:	75 e0                	jne    8010259c <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801025bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801025c0:	74 11                	je     801025d3 <idewait+0x3e>
801025c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801025c5:	83 e0 21             	and    $0x21,%eax
801025c8:	85 c0                	test   %eax,%eax
801025ca:	74 07                	je     801025d3 <idewait+0x3e>
    return -1;
801025cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025d1:	eb 05                	jmp    801025d8 <idewait+0x43>
  return 0;
801025d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801025d8:	c9                   	leave  
801025d9:	c3                   	ret    

801025da <ideinit>:

void
ideinit(void)
{
801025da:	55                   	push   %ebp
801025db:	89 e5                	mov    %esp,%ebp
801025dd:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  initlock(&idelock, "ide");
801025e0:	83 ec 08             	sub    $0x8,%esp
801025e3:	68 26 86 10 80       	push   $0x80108626
801025e8:	68 20 b6 10 80       	push   $0x8010b620
801025ed:	e8 68 29 00 00       	call   80104f5a <initlock>
801025f2:	83 c4 10             	add    $0x10,%esp
  picenable(IRQ_IDE);
801025f5:	83 ec 0c             	sub    $0xc,%esp
801025f8:	6a 0e                	push   $0xe
801025fa:	e8 b7 18 00 00       	call   80103eb6 <picenable>
801025ff:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
80102602:	a1 60 2a 11 80       	mov    0x80112a60,%eax
80102607:	83 e8 01             	sub    $0x1,%eax
8010260a:	83 ec 08             	sub    $0x8,%esp
8010260d:	50                   	push   %eax
8010260e:	6a 0e                	push   $0xe
80102610:	e8 6d 04 00 00       	call   80102a82 <ioapicenable>
80102615:	83 c4 10             	add    $0x10,%esp
  idewait(0);
80102618:	83 ec 0c             	sub    $0xc,%esp
8010261b:	6a 00                	push   $0x0
8010261d:	e8 73 ff ff ff       	call   80102595 <idewait>
80102622:	83 c4 10             	add    $0x10,%esp
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
80102625:	83 ec 08             	sub    $0x8,%esp
80102628:	68 f0 00 00 00       	push   $0xf0
8010262d:	68 f6 01 00 00       	push   $0x1f6
80102632:	e8 1b ff ff ff       	call   80102552 <outb>
80102637:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
8010263a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102641:	eb 24                	jmp    80102667 <ideinit+0x8d>
    if(inb(0x1f7) != 0){
80102643:	83 ec 0c             	sub    $0xc,%esp
80102646:	68 f7 01 00 00       	push   $0x1f7
8010264b:	e8 c0 fe ff ff       	call   80102510 <inb>
80102650:	83 c4 10             	add    $0x10,%esp
80102653:	84 c0                	test   %al,%al
80102655:	74 0c                	je     80102663 <ideinit+0x89>
      havedisk1 = 1;
80102657:	c7 05 58 b6 10 80 01 	movl   $0x1,0x8010b658
8010265e:	00 00 00 
      break;
80102661:	eb 0d                	jmp    80102670 <ideinit+0x96>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102663:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102667:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
8010266e:	7e d3                	jle    80102643 <ideinit+0x69>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
80102670:	83 ec 08             	sub    $0x8,%esp
80102673:	68 e0 00 00 00       	push   $0xe0
80102678:	68 f6 01 00 00       	push   $0x1f6
8010267d:	e8 d0 fe ff ff       	call   80102552 <outb>
80102682:	83 c4 10             	add    $0x10,%esp
}
80102685:	c9                   	leave  
80102686:	c3                   	ret    

80102687 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102687:	55                   	push   %ebp
80102688:	89 e5                	mov    %esp,%ebp
8010268a:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
8010268d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102691:	75 0d                	jne    801026a0 <idestart+0x19>
    panic("idestart");
80102693:	83 ec 0c             	sub    $0xc,%esp
80102696:	68 2a 86 10 80       	push   $0x8010862a
8010269b:	e8 bc de ff ff       	call   8010055c <panic>
  if(b->blockno >= FSSIZE)
801026a0:	8b 45 08             	mov    0x8(%ebp),%eax
801026a3:	8b 40 08             	mov    0x8(%eax),%eax
801026a6:	3d e7 03 00 00       	cmp    $0x3e7,%eax
801026ab:	76 0d                	jbe    801026ba <idestart+0x33>
    panic("incorrect blockno");
801026ad:	83 ec 0c             	sub    $0xc,%esp
801026b0:	68 33 86 10 80       	push   $0x80108633
801026b5:	e8 a2 de ff ff       	call   8010055c <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
801026ba:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
801026c1:	8b 45 08             	mov    0x8(%ebp),%eax
801026c4:	8b 50 08             	mov    0x8(%eax),%edx
801026c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801026ca:	0f af c2             	imul   %edx,%eax
801026cd:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if (sector_per_block > 7) panic("idestart");
801026d0:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
801026d4:	7e 0d                	jle    801026e3 <idestart+0x5c>
801026d6:	83 ec 0c             	sub    $0xc,%esp
801026d9:	68 2a 86 10 80       	push   $0x8010862a
801026de:	e8 79 de ff ff       	call   8010055c <panic>
  
  idewait(0);
801026e3:	83 ec 0c             	sub    $0xc,%esp
801026e6:	6a 00                	push   $0x0
801026e8:	e8 a8 fe ff ff       	call   80102595 <idewait>
801026ed:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
801026f0:	83 ec 08             	sub    $0x8,%esp
801026f3:	6a 00                	push   $0x0
801026f5:	68 f6 03 00 00       	push   $0x3f6
801026fa:	e8 53 fe ff ff       	call   80102552 <outb>
801026ff:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, sector_per_block);  // number of sectors
80102702:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102705:	0f b6 c0             	movzbl %al,%eax
80102708:	83 ec 08             	sub    $0x8,%esp
8010270b:	50                   	push   %eax
8010270c:	68 f2 01 00 00       	push   $0x1f2
80102711:	e8 3c fe ff ff       	call   80102552 <outb>
80102716:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, sector & 0xff);
80102719:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010271c:	0f b6 c0             	movzbl %al,%eax
8010271f:	83 ec 08             	sub    $0x8,%esp
80102722:	50                   	push   %eax
80102723:	68 f3 01 00 00       	push   $0x1f3
80102728:	e8 25 fe ff ff       	call   80102552 <outb>
8010272d:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (sector >> 8) & 0xff);
80102730:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102733:	c1 f8 08             	sar    $0x8,%eax
80102736:	0f b6 c0             	movzbl %al,%eax
80102739:	83 ec 08             	sub    $0x8,%esp
8010273c:	50                   	push   %eax
8010273d:	68 f4 01 00 00       	push   $0x1f4
80102742:	e8 0b fe ff ff       	call   80102552 <outb>
80102747:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (sector >> 16) & 0xff);
8010274a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010274d:	c1 f8 10             	sar    $0x10,%eax
80102750:	0f b6 c0             	movzbl %al,%eax
80102753:	83 ec 08             	sub    $0x8,%esp
80102756:	50                   	push   %eax
80102757:	68 f5 01 00 00       	push   $0x1f5
8010275c:	e8 f1 fd ff ff       	call   80102552 <outb>
80102761:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102764:	8b 45 08             	mov    0x8(%ebp),%eax
80102767:	8b 40 04             	mov    0x4(%eax),%eax
8010276a:	83 e0 01             	and    $0x1,%eax
8010276d:	c1 e0 04             	shl    $0x4,%eax
80102770:	89 c2                	mov    %eax,%edx
80102772:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102775:	c1 f8 18             	sar    $0x18,%eax
80102778:	83 e0 0f             	and    $0xf,%eax
8010277b:	09 d0                	or     %edx,%eax
8010277d:	83 c8 e0             	or     $0xffffffe0,%eax
80102780:	0f b6 c0             	movzbl %al,%eax
80102783:	83 ec 08             	sub    $0x8,%esp
80102786:	50                   	push   %eax
80102787:	68 f6 01 00 00       	push   $0x1f6
8010278c:	e8 c1 fd ff ff       	call   80102552 <outb>
80102791:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
80102794:	8b 45 08             	mov    0x8(%ebp),%eax
80102797:	8b 00                	mov    (%eax),%eax
80102799:	83 e0 04             	and    $0x4,%eax
8010279c:	85 c0                	test   %eax,%eax
8010279e:	74 30                	je     801027d0 <idestart+0x149>
    outb(0x1f7, IDE_CMD_WRITE);
801027a0:	83 ec 08             	sub    $0x8,%esp
801027a3:	6a 30                	push   $0x30
801027a5:	68 f7 01 00 00       	push   $0x1f7
801027aa:	e8 a3 fd ff ff       	call   80102552 <outb>
801027af:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, BSIZE/4);
801027b2:	8b 45 08             	mov    0x8(%ebp),%eax
801027b5:	83 c0 18             	add    $0x18,%eax
801027b8:	83 ec 04             	sub    $0x4,%esp
801027bb:	68 80 00 00 00       	push   $0x80
801027c0:	50                   	push   %eax
801027c1:	68 f0 01 00 00       	push   $0x1f0
801027c6:	e8 a5 fd ff ff       	call   80102570 <outsl>
801027cb:	83 c4 10             	add    $0x10,%esp
801027ce:	eb 12                	jmp    801027e2 <idestart+0x15b>
  } else {
    outb(0x1f7, IDE_CMD_READ);
801027d0:	83 ec 08             	sub    $0x8,%esp
801027d3:	6a 20                	push   $0x20
801027d5:	68 f7 01 00 00       	push   $0x1f7
801027da:	e8 73 fd ff ff       	call   80102552 <outb>
801027df:	83 c4 10             	add    $0x10,%esp
  }
}
801027e2:	c9                   	leave  
801027e3:	c3                   	ret    

801027e4 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801027e4:	55                   	push   %ebp
801027e5:	89 e5                	mov    %esp,%ebp
801027e7:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801027ea:	83 ec 0c             	sub    $0xc,%esp
801027ed:	68 20 b6 10 80       	push   $0x8010b620
801027f2:	e8 84 27 00 00       	call   80104f7b <acquire>
801027f7:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
801027fa:	a1 54 b6 10 80       	mov    0x8010b654,%eax
801027ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102802:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102806:	75 15                	jne    8010281d <ideintr+0x39>
    release(&idelock);
80102808:	83 ec 0c             	sub    $0xc,%esp
8010280b:	68 20 b6 10 80       	push   $0x8010b620
80102810:	e8 cc 27 00 00       	call   80104fe1 <release>
80102815:	83 c4 10             	add    $0x10,%esp
    // cprintf("spurious IDE interrupt\n");
    return;
80102818:	e9 9a 00 00 00       	jmp    801028b7 <ideintr+0xd3>
  }
  idequeue = b->qnext;
8010281d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102820:	8b 40 14             	mov    0x14(%eax),%eax
80102823:	a3 54 b6 10 80       	mov    %eax,0x8010b654

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102828:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010282b:	8b 00                	mov    (%eax),%eax
8010282d:	83 e0 04             	and    $0x4,%eax
80102830:	85 c0                	test   %eax,%eax
80102832:	75 2d                	jne    80102861 <ideintr+0x7d>
80102834:	83 ec 0c             	sub    $0xc,%esp
80102837:	6a 01                	push   $0x1
80102839:	e8 57 fd ff ff       	call   80102595 <idewait>
8010283e:	83 c4 10             	add    $0x10,%esp
80102841:	85 c0                	test   %eax,%eax
80102843:	78 1c                	js     80102861 <ideintr+0x7d>
    insl(0x1f0, b->data, BSIZE/4);
80102845:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102848:	83 c0 18             	add    $0x18,%eax
8010284b:	83 ec 04             	sub    $0x4,%esp
8010284e:	68 80 00 00 00       	push   $0x80
80102853:	50                   	push   %eax
80102854:	68 f0 01 00 00       	push   $0x1f0
80102859:	e8 cf fc ff ff       	call   8010252d <insl>
8010285e:	83 c4 10             	add    $0x10,%esp
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102861:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102864:	8b 00                	mov    (%eax),%eax
80102866:	83 c8 02             	or     $0x2,%eax
80102869:	89 c2                	mov    %eax,%edx
8010286b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010286e:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102870:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102873:	8b 00                	mov    (%eax),%eax
80102875:	83 e0 fb             	and    $0xfffffffb,%eax
80102878:	89 c2                	mov    %eax,%edx
8010287a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010287d:	89 10                	mov    %edx,(%eax)
  wakeup(b);
8010287f:	83 ec 0c             	sub    $0xc,%esp
80102882:	ff 75 f4             	pushl  -0xc(%ebp)
80102885:	e8 ea 24 00 00       	call   80104d74 <wakeup>
8010288a:	83 c4 10             	add    $0x10,%esp
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
8010288d:	a1 54 b6 10 80       	mov    0x8010b654,%eax
80102892:	85 c0                	test   %eax,%eax
80102894:	74 11                	je     801028a7 <ideintr+0xc3>
    idestart(idequeue);
80102896:	a1 54 b6 10 80       	mov    0x8010b654,%eax
8010289b:	83 ec 0c             	sub    $0xc,%esp
8010289e:	50                   	push   %eax
8010289f:	e8 e3 fd ff ff       	call   80102687 <idestart>
801028a4:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
801028a7:	83 ec 0c             	sub    $0xc,%esp
801028aa:	68 20 b6 10 80       	push   $0x8010b620
801028af:	e8 2d 27 00 00       	call   80104fe1 <release>
801028b4:	83 c4 10             	add    $0x10,%esp
}
801028b7:	c9                   	leave  
801028b8:	c3                   	ret    

801028b9 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801028b9:	55                   	push   %ebp
801028ba:	89 e5                	mov    %esp,%ebp
801028bc:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
801028bf:	8b 45 08             	mov    0x8(%ebp),%eax
801028c2:	8b 00                	mov    (%eax),%eax
801028c4:	83 e0 01             	and    $0x1,%eax
801028c7:	85 c0                	test   %eax,%eax
801028c9:	75 0d                	jne    801028d8 <iderw+0x1f>
    panic("iderw: buf not busy");
801028cb:	83 ec 0c             	sub    $0xc,%esp
801028ce:	68 45 86 10 80       	push   $0x80108645
801028d3:	e8 84 dc ff ff       	call   8010055c <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801028d8:	8b 45 08             	mov    0x8(%ebp),%eax
801028db:	8b 00                	mov    (%eax),%eax
801028dd:	83 e0 06             	and    $0x6,%eax
801028e0:	83 f8 02             	cmp    $0x2,%eax
801028e3:	75 0d                	jne    801028f2 <iderw+0x39>
    panic("iderw: nothing to do");
801028e5:	83 ec 0c             	sub    $0xc,%esp
801028e8:	68 59 86 10 80       	push   $0x80108659
801028ed:	e8 6a dc ff ff       	call   8010055c <panic>
  if(b->dev != 0 && !havedisk1)
801028f2:	8b 45 08             	mov    0x8(%ebp),%eax
801028f5:	8b 40 04             	mov    0x4(%eax),%eax
801028f8:	85 c0                	test   %eax,%eax
801028fa:	74 16                	je     80102912 <iderw+0x59>
801028fc:	a1 58 b6 10 80       	mov    0x8010b658,%eax
80102901:	85 c0                	test   %eax,%eax
80102903:	75 0d                	jne    80102912 <iderw+0x59>
    panic("iderw: ide disk 1 not present");
80102905:	83 ec 0c             	sub    $0xc,%esp
80102908:	68 6e 86 10 80       	push   $0x8010866e
8010290d:	e8 4a dc ff ff       	call   8010055c <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102912:	83 ec 0c             	sub    $0xc,%esp
80102915:	68 20 b6 10 80       	push   $0x8010b620
8010291a:	e8 5c 26 00 00       	call   80104f7b <acquire>
8010291f:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
80102922:	8b 45 08             	mov    0x8(%ebp),%eax
80102925:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010292c:	c7 45 f4 54 b6 10 80 	movl   $0x8010b654,-0xc(%ebp)
80102933:	eb 0b                	jmp    80102940 <iderw+0x87>
80102935:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102938:	8b 00                	mov    (%eax),%eax
8010293a:	83 c0 14             	add    $0x14,%eax
8010293d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102940:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102943:	8b 00                	mov    (%eax),%eax
80102945:	85 c0                	test   %eax,%eax
80102947:	75 ec                	jne    80102935 <iderw+0x7c>
    ;
  *pp = b;
80102949:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010294c:	8b 55 08             	mov    0x8(%ebp),%edx
8010294f:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102951:	a1 54 b6 10 80       	mov    0x8010b654,%eax
80102956:	3b 45 08             	cmp    0x8(%ebp),%eax
80102959:	75 0e                	jne    80102969 <iderw+0xb0>
    idestart(b);
8010295b:	83 ec 0c             	sub    $0xc,%esp
8010295e:	ff 75 08             	pushl  0x8(%ebp)
80102961:	e8 21 fd ff ff       	call   80102687 <idestart>
80102966:	83 c4 10             	add    $0x10,%esp
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102969:	eb 13                	jmp    8010297e <iderw+0xc5>
    sleep(b, &idelock);
8010296b:	83 ec 08             	sub    $0x8,%esp
8010296e:	68 20 b6 10 80       	push   $0x8010b620
80102973:	ff 75 08             	pushl  0x8(%ebp)
80102976:	e8 10 23 00 00       	call   80104c8b <sleep>
8010297b:	83 c4 10             	add    $0x10,%esp
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010297e:	8b 45 08             	mov    0x8(%ebp),%eax
80102981:	8b 00                	mov    (%eax),%eax
80102983:	83 e0 06             	and    $0x6,%eax
80102986:	83 f8 02             	cmp    $0x2,%eax
80102989:	75 e0                	jne    8010296b <iderw+0xb2>
    sleep(b, &idelock);
  }

  release(&idelock);
8010298b:	83 ec 0c             	sub    $0xc,%esp
8010298e:	68 20 b6 10 80       	push   $0x8010b620
80102993:	e8 49 26 00 00       	call   80104fe1 <release>
80102998:	83 c4 10             	add    $0x10,%esp
}
8010299b:	c9                   	leave  
8010299c:	c3                   	ret    

8010299d <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
8010299d:	55                   	push   %ebp
8010299e:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
801029a0:	a1 d4 22 11 80       	mov    0x801122d4,%eax
801029a5:	8b 55 08             	mov    0x8(%ebp),%edx
801029a8:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
801029aa:	a1 d4 22 11 80       	mov    0x801122d4,%eax
801029af:	8b 40 10             	mov    0x10(%eax),%eax
}
801029b2:	5d                   	pop    %ebp
801029b3:	c3                   	ret    

801029b4 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
801029b4:	55                   	push   %ebp
801029b5:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
801029b7:	a1 d4 22 11 80       	mov    0x801122d4,%eax
801029bc:	8b 55 08             	mov    0x8(%ebp),%edx
801029bf:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
801029c1:	a1 d4 22 11 80       	mov    0x801122d4,%eax
801029c6:	8b 55 0c             	mov    0xc(%ebp),%edx
801029c9:	89 50 10             	mov    %edx,0x10(%eax)
}
801029cc:	5d                   	pop    %ebp
801029cd:	c3                   	ret    

801029ce <ioapicinit>:

void
ioapicinit(void)
{
801029ce:	55                   	push   %ebp
801029cf:	89 e5                	mov    %esp,%ebp
801029d1:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  if(!ismp)
801029d4:	a1 44 24 11 80       	mov    0x80112444,%eax
801029d9:	85 c0                	test   %eax,%eax
801029db:	75 05                	jne    801029e2 <ioapicinit+0x14>
    return;
801029dd:	e9 9e 00 00 00       	jmp    80102a80 <ioapicinit+0xb2>

  ioapic = (volatile struct ioapic*)IOAPIC;
801029e2:	c7 05 d4 22 11 80 00 	movl   $0xfec00000,0x801122d4
801029e9:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801029ec:	6a 01                	push   $0x1
801029ee:	e8 aa ff ff ff       	call   8010299d <ioapicread>
801029f3:	83 c4 04             	add    $0x4,%esp
801029f6:	c1 e8 10             	shr    $0x10,%eax
801029f9:	25 ff 00 00 00       	and    $0xff,%eax
801029fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102a01:	6a 00                	push   $0x0
80102a03:	e8 95 ff ff ff       	call   8010299d <ioapicread>
80102a08:	83 c4 04             	add    $0x4,%esp
80102a0b:	c1 e8 18             	shr    $0x18,%eax
80102a0e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102a11:	0f b6 05 40 24 11 80 	movzbl 0x80112440,%eax
80102a18:	0f b6 c0             	movzbl %al,%eax
80102a1b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102a1e:	74 10                	je     80102a30 <ioapicinit+0x62>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102a20:	83 ec 0c             	sub    $0xc,%esp
80102a23:	68 8c 86 10 80       	push   $0x8010868c
80102a28:	e8 92 d9 ff ff       	call   801003bf <cprintf>
80102a2d:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102a30:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102a37:	eb 3f                	jmp    80102a78 <ioapicinit+0xaa>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a3c:	83 c0 20             	add    $0x20,%eax
80102a3f:	0d 00 00 01 00       	or     $0x10000,%eax
80102a44:	89 c2                	mov    %eax,%edx
80102a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a49:	83 c0 08             	add    $0x8,%eax
80102a4c:	01 c0                	add    %eax,%eax
80102a4e:	83 ec 08             	sub    $0x8,%esp
80102a51:	52                   	push   %edx
80102a52:	50                   	push   %eax
80102a53:	e8 5c ff ff ff       	call   801029b4 <ioapicwrite>
80102a58:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a5e:	83 c0 08             	add    $0x8,%eax
80102a61:	01 c0                	add    %eax,%eax
80102a63:	83 c0 01             	add    $0x1,%eax
80102a66:	83 ec 08             	sub    $0x8,%esp
80102a69:	6a 00                	push   $0x0
80102a6b:	50                   	push   %eax
80102a6c:	e8 43 ff ff ff       	call   801029b4 <ioapicwrite>
80102a71:	83 c4 10             	add    $0x10,%esp
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102a74:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a7b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102a7e:	7e b9                	jle    80102a39 <ioapicinit+0x6b>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102a80:	c9                   	leave  
80102a81:	c3                   	ret    

80102a82 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102a82:	55                   	push   %ebp
80102a83:	89 e5                	mov    %esp,%ebp
  if(!ismp)
80102a85:	a1 44 24 11 80       	mov    0x80112444,%eax
80102a8a:	85 c0                	test   %eax,%eax
80102a8c:	75 02                	jne    80102a90 <ioapicenable+0xe>
    return;
80102a8e:	eb 37                	jmp    80102ac7 <ioapicenable+0x45>

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102a90:	8b 45 08             	mov    0x8(%ebp),%eax
80102a93:	83 c0 20             	add    $0x20,%eax
80102a96:	89 c2                	mov    %eax,%edx
80102a98:	8b 45 08             	mov    0x8(%ebp),%eax
80102a9b:	83 c0 08             	add    $0x8,%eax
80102a9e:	01 c0                	add    %eax,%eax
80102aa0:	52                   	push   %edx
80102aa1:	50                   	push   %eax
80102aa2:	e8 0d ff ff ff       	call   801029b4 <ioapicwrite>
80102aa7:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102aaa:	8b 45 0c             	mov    0xc(%ebp),%eax
80102aad:	c1 e0 18             	shl    $0x18,%eax
80102ab0:	89 c2                	mov    %eax,%edx
80102ab2:	8b 45 08             	mov    0x8(%ebp),%eax
80102ab5:	83 c0 08             	add    $0x8,%eax
80102ab8:	01 c0                	add    %eax,%eax
80102aba:	83 c0 01             	add    $0x1,%eax
80102abd:	52                   	push   %edx
80102abe:	50                   	push   %eax
80102abf:	e8 f0 fe ff ff       	call   801029b4 <ioapicwrite>
80102ac4:	83 c4 08             	add    $0x8,%esp
}
80102ac7:	c9                   	leave  
80102ac8:	c3                   	ret    

80102ac9 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102ac9:	55                   	push   %ebp
80102aca:	89 e5                	mov    %esp,%ebp
80102acc:	8b 45 08             	mov    0x8(%ebp),%eax
80102acf:	05 00 00 00 80       	add    $0x80000000,%eax
80102ad4:	5d                   	pop    %ebp
80102ad5:	c3                   	ret    

80102ad6 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102ad6:	55                   	push   %ebp
80102ad7:	89 e5                	mov    %esp,%ebp
80102ad9:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102adc:	83 ec 08             	sub    $0x8,%esp
80102adf:	68 be 86 10 80       	push   $0x801086be
80102ae4:	68 e0 22 11 80       	push   $0x801122e0
80102ae9:	e8 6c 24 00 00       	call   80104f5a <initlock>
80102aee:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102af1:	c7 05 14 23 11 80 00 	movl   $0x0,0x80112314
80102af8:	00 00 00 
  freerange(vstart, vend);
80102afb:	83 ec 08             	sub    $0x8,%esp
80102afe:	ff 75 0c             	pushl  0xc(%ebp)
80102b01:	ff 75 08             	pushl  0x8(%ebp)
80102b04:	e8 28 00 00 00       	call   80102b31 <freerange>
80102b09:	83 c4 10             	add    $0x10,%esp
}
80102b0c:	c9                   	leave  
80102b0d:	c3                   	ret    

80102b0e <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102b0e:	55                   	push   %ebp
80102b0f:	89 e5                	mov    %esp,%ebp
80102b11:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102b14:	83 ec 08             	sub    $0x8,%esp
80102b17:	ff 75 0c             	pushl  0xc(%ebp)
80102b1a:	ff 75 08             	pushl  0x8(%ebp)
80102b1d:	e8 0f 00 00 00       	call   80102b31 <freerange>
80102b22:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102b25:	c7 05 14 23 11 80 01 	movl   $0x1,0x80112314
80102b2c:	00 00 00 
}
80102b2f:	c9                   	leave  
80102b30:	c3                   	ret    

80102b31 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102b31:	55                   	push   %ebp
80102b32:	89 e5                	mov    %esp,%ebp
80102b34:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102b37:	8b 45 08             	mov    0x8(%ebp),%eax
80102b3a:	05 ff 0f 00 00       	add    $0xfff,%eax
80102b3f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102b44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b47:	eb 15                	jmp    80102b5e <freerange+0x2d>
    kfree(p);
80102b49:	83 ec 0c             	sub    $0xc,%esp
80102b4c:	ff 75 f4             	pushl  -0xc(%ebp)
80102b4f:	e8 19 00 00 00       	call   80102b6d <kfree>
80102b54:	83 c4 10             	add    $0x10,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b57:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102b5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b61:	05 00 10 00 00       	add    $0x1000,%eax
80102b66:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102b69:	76 de                	jbe    80102b49 <freerange+0x18>
    kfree(p);
}
80102b6b:	c9                   	leave  
80102b6c:	c3                   	ret    

80102b6d <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102b6d:	55                   	push   %ebp
80102b6e:	89 e5                	mov    %esp,%ebp
80102b70:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102b73:	8b 45 08             	mov    0x8(%ebp),%eax
80102b76:	25 ff 0f 00 00       	and    $0xfff,%eax
80102b7b:	85 c0                	test   %eax,%eax
80102b7d:	75 1b                	jne    80102b9a <kfree+0x2d>
80102b7f:	81 7d 08 5c 52 11 80 	cmpl   $0x8011525c,0x8(%ebp)
80102b86:	72 12                	jb     80102b9a <kfree+0x2d>
80102b88:	ff 75 08             	pushl  0x8(%ebp)
80102b8b:	e8 39 ff ff ff       	call   80102ac9 <v2p>
80102b90:	83 c4 04             	add    $0x4,%esp
80102b93:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102b98:	76 0d                	jbe    80102ba7 <kfree+0x3a>
    panic("kfree");
80102b9a:	83 ec 0c             	sub    $0xc,%esp
80102b9d:	68 c3 86 10 80       	push   $0x801086c3
80102ba2:	e8 b5 d9 ff ff       	call   8010055c <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102ba7:	83 ec 04             	sub    $0x4,%esp
80102baa:	68 00 10 00 00       	push   $0x1000
80102baf:	6a 01                	push   $0x1
80102bb1:	ff 75 08             	pushl  0x8(%ebp)
80102bb4:	e8 1e 26 00 00       	call   801051d7 <memset>
80102bb9:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102bbc:	a1 14 23 11 80       	mov    0x80112314,%eax
80102bc1:	85 c0                	test   %eax,%eax
80102bc3:	74 10                	je     80102bd5 <kfree+0x68>
    acquire(&kmem.lock);
80102bc5:	83 ec 0c             	sub    $0xc,%esp
80102bc8:	68 e0 22 11 80       	push   $0x801122e0
80102bcd:	e8 a9 23 00 00       	call   80104f7b <acquire>
80102bd2:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102bd5:	8b 45 08             	mov    0x8(%ebp),%eax
80102bd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102bdb:	8b 15 18 23 11 80    	mov    0x80112318,%edx
80102be1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102be4:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102be9:	a3 18 23 11 80       	mov    %eax,0x80112318
  if(kmem.use_lock)
80102bee:	a1 14 23 11 80       	mov    0x80112314,%eax
80102bf3:	85 c0                	test   %eax,%eax
80102bf5:	74 10                	je     80102c07 <kfree+0x9a>
    release(&kmem.lock);
80102bf7:	83 ec 0c             	sub    $0xc,%esp
80102bfa:	68 e0 22 11 80       	push   $0x801122e0
80102bff:	e8 dd 23 00 00       	call   80104fe1 <release>
80102c04:	83 c4 10             	add    $0x10,%esp
}
80102c07:	c9                   	leave  
80102c08:	c3                   	ret    

80102c09 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102c09:	55                   	push   %ebp
80102c0a:	89 e5                	mov    %esp,%ebp
80102c0c:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102c0f:	a1 14 23 11 80       	mov    0x80112314,%eax
80102c14:	85 c0                	test   %eax,%eax
80102c16:	74 10                	je     80102c28 <kalloc+0x1f>
    acquire(&kmem.lock);
80102c18:	83 ec 0c             	sub    $0xc,%esp
80102c1b:	68 e0 22 11 80       	push   $0x801122e0
80102c20:	e8 56 23 00 00       	call   80104f7b <acquire>
80102c25:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102c28:	a1 18 23 11 80       	mov    0x80112318,%eax
80102c2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102c30:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102c34:	74 0a                	je     80102c40 <kalloc+0x37>
    kmem.freelist = r->next;
80102c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c39:	8b 00                	mov    (%eax),%eax
80102c3b:	a3 18 23 11 80       	mov    %eax,0x80112318
  if(kmem.use_lock)
80102c40:	a1 14 23 11 80       	mov    0x80112314,%eax
80102c45:	85 c0                	test   %eax,%eax
80102c47:	74 10                	je     80102c59 <kalloc+0x50>
    release(&kmem.lock);
80102c49:	83 ec 0c             	sub    $0xc,%esp
80102c4c:	68 e0 22 11 80       	push   $0x801122e0
80102c51:	e8 8b 23 00 00       	call   80104fe1 <release>
80102c56:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102c59:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102c5c:	c9                   	leave  
80102c5d:	c3                   	ret    

80102c5e <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102c5e:	55                   	push   %ebp
80102c5f:	89 e5                	mov    %esp,%ebp
80102c61:	83 ec 14             	sub    $0x14,%esp
80102c64:	8b 45 08             	mov    0x8(%ebp),%eax
80102c67:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c6b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102c6f:	89 c2                	mov    %eax,%edx
80102c71:	ec                   	in     (%dx),%al
80102c72:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102c75:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102c79:	c9                   	leave  
80102c7a:	c3                   	ret    

80102c7b <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102c7b:	55                   	push   %ebp
80102c7c:	89 e5                	mov    %esp,%ebp
80102c7e:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102c81:	6a 64                	push   $0x64
80102c83:	e8 d6 ff ff ff       	call   80102c5e <inb>
80102c88:	83 c4 04             	add    $0x4,%esp
80102c8b:	0f b6 c0             	movzbl %al,%eax
80102c8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102c91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c94:	83 e0 01             	and    $0x1,%eax
80102c97:	85 c0                	test   %eax,%eax
80102c99:	75 0a                	jne    80102ca5 <kbdgetc+0x2a>
    return -1;
80102c9b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102ca0:	e9 23 01 00 00       	jmp    80102dc8 <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102ca5:	6a 60                	push   $0x60
80102ca7:	e8 b2 ff ff ff       	call   80102c5e <inb>
80102cac:	83 c4 04             	add    $0x4,%esp
80102caf:	0f b6 c0             	movzbl %al,%eax
80102cb2:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102cb5:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102cbc:	75 17                	jne    80102cd5 <kbdgetc+0x5a>
    shift |= E0ESC;
80102cbe:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102cc3:	83 c8 40             	or     $0x40,%eax
80102cc6:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
    return 0;
80102ccb:	b8 00 00 00 00       	mov    $0x0,%eax
80102cd0:	e9 f3 00 00 00       	jmp    80102dc8 <kbdgetc+0x14d>
  } else if(data & 0x80){
80102cd5:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cd8:	25 80 00 00 00       	and    $0x80,%eax
80102cdd:	85 c0                	test   %eax,%eax
80102cdf:	74 45                	je     80102d26 <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102ce1:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102ce6:	83 e0 40             	and    $0x40,%eax
80102ce9:	85 c0                	test   %eax,%eax
80102ceb:	75 08                	jne    80102cf5 <kbdgetc+0x7a>
80102ced:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cf0:	83 e0 7f             	and    $0x7f,%eax
80102cf3:	eb 03                	jmp    80102cf8 <kbdgetc+0x7d>
80102cf5:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cf8:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102cfb:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cfe:	05 40 90 10 80       	add    $0x80109040,%eax
80102d03:	0f b6 00             	movzbl (%eax),%eax
80102d06:	83 c8 40             	or     $0x40,%eax
80102d09:	0f b6 c0             	movzbl %al,%eax
80102d0c:	f7 d0                	not    %eax
80102d0e:	89 c2                	mov    %eax,%edx
80102d10:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102d15:	21 d0                	and    %edx,%eax
80102d17:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
    return 0;
80102d1c:	b8 00 00 00 00       	mov    $0x0,%eax
80102d21:	e9 a2 00 00 00       	jmp    80102dc8 <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102d26:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102d2b:	83 e0 40             	and    $0x40,%eax
80102d2e:	85 c0                	test   %eax,%eax
80102d30:	74 14                	je     80102d46 <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102d32:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102d39:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102d3e:	83 e0 bf             	and    $0xffffffbf,%eax
80102d41:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
  }

  shift |= shiftcode[data];
80102d46:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d49:	05 40 90 10 80       	add    $0x80109040,%eax
80102d4e:	0f b6 00             	movzbl (%eax),%eax
80102d51:	0f b6 d0             	movzbl %al,%edx
80102d54:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102d59:	09 d0                	or     %edx,%eax
80102d5b:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
  shift ^= togglecode[data];
80102d60:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d63:	05 40 91 10 80       	add    $0x80109140,%eax
80102d68:	0f b6 00             	movzbl (%eax),%eax
80102d6b:	0f b6 d0             	movzbl %al,%edx
80102d6e:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102d73:	31 d0                	xor    %edx,%eax
80102d75:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
  c = charcode[shift & (CTL | SHIFT)][data];
80102d7a:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102d7f:	83 e0 03             	and    $0x3,%eax
80102d82:	8b 14 85 40 95 10 80 	mov    -0x7fef6ac0(,%eax,4),%edx
80102d89:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d8c:	01 d0                	add    %edx,%eax
80102d8e:	0f b6 00             	movzbl (%eax),%eax
80102d91:	0f b6 c0             	movzbl %al,%eax
80102d94:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102d97:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102d9c:	83 e0 08             	and    $0x8,%eax
80102d9f:	85 c0                	test   %eax,%eax
80102da1:	74 22                	je     80102dc5 <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80102da3:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102da7:	76 0c                	jbe    80102db5 <kbdgetc+0x13a>
80102da9:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102dad:	77 06                	ja     80102db5 <kbdgetc+0x13a>
      c += 'A' - 'a';
80102daf:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102db3:	eb 10                	jmp    80102dc5 <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80102db5:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102db9:	76 0a                	jbe    80102dc5 <kbdgetc+0x14a>
80102dbb:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102dbf:	77 04                	ja     80102dc5 <kbdgetc+0x14a>
      c += 'a' - 'A';
80102dc1:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102dc5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102dc8:	c9                   	leave  
80102dc9:	c3                   	ret    

80102dca <kbdintr>:

void
kbdintr(void)
{
80102dca:	55                   	push   %ebp
80102dcb:	89 e5                	mov    %esp,%ebp
80102dcd:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80102dd0:	83 ec 0c             	sub    $0xc,%esp
80102dd3:	68 7b 2c 10 80       	push   $0x80102c7b
80102dd8:	e8 f4 d9 ff ff       	call   801007d1 <consoleintr>
80102ddd:	83 c4 10             	add    $0x10,%esp
}
80102de0:	c9                   	leave  
80102de1:	c3                   	ret    

80102de2 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102de2:	55                   	push   %ebp
80102de3:	89 e5                	mov    %esp,%ebp
80102de5:	83 ec 14             	sub    $0x14,%esp
80102de8:	8b 45 08             	mov    0x8(%ebp),%eax
80102deb:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102def:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102df3:	89 c2                	mov    %eax,%edx
80102df5:	ec                   	in     (%dx),%al
80102df6:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102df9:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102dfd:	c9                   	leave  
80102dfe:	c3                   	ret    

80102dff <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102dff:	55                   	push   %ebp
80102e00:	89 e5                	mov    %esp,%ebp
80102e02:	83 ec 08             	sub    $0x8,%esp
80102e05:	8b 55 08             	mov    0x8(%ebp),%edx
80102e08:	8b 45 0c             	mov    0xc(%ebp),%eax
80102e0b:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102e0f:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e12:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102e16:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102e1a:	ee                   	out    %al,(%dx)
}
80102e1b:	c9                   	leave  
80102e1c:	c3                   	ret    

80102e1d <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102e1d:	55                   	push   %ebp
80102e1e:	89 e5                	mov    %esp,%ebp
80102e20:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102e23:	9c                   	pushf  
80102e24:	58                   	pop    %eax
80102e25:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102e28:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102e2b:	c9                   	leave  
80102e2c:	c3                   	ret    

80102e2d <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102e2d:	55                   	push   %ebp
80102e2e:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102e30:	a1 1c 23 11 80       	mov    0x8011231c,%eax
80102e35:	8b 55 08             	mov    0x8(%ebp),%edx
80102e38:	c1 e2 02             	shl    $0x2,%edx
80102e3b:	01 c2                	add    %eax,%edx
80102e3d:	8b 45 0c             	mov    0xc(%ebp),%eax
80102e40:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102e42:	a1 1c 23 11 80       	mov    0x8011231c,%eax
80102e47:	83 c0 20             	add    $0x20,%eax
80102e4a:	8b 00                	mov    (%eax),%eax
}
80102e4c:	5d                   	pop    %ebp
80102e4d:	c3                   	ret    

80102e4e <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80102e4e:	55                   	push   %ebp
80102e4f:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
80102e51:	a1 1c 23 11 80       	mov    0x8011231c,%eax
80102e56:	85 c0                	test   %eax,%eax
80102e58:	75 05                	jne    80102e5f <lapicinit+0x11>
    return;
80102e5a:	e9 09 01 00 00       	jmp    80102f68 <lapicinit+0x11a>

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102e5f:	68 3f 01 00 00       	push   $0x13f
80102e64:	6a 3c                	push   $0x3c
80102e66:	e8 c2 ff ff ff       	call   80102e2d <lapicw>
80102e6b:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102e6e:	6a 0b                	push   $0xb
80102e70:	68 f8 00 00 00       	push   $0xf8
80102e75:	e8 b3 ff ff ff       	call   80102e2d <lapicw>
80102e7a:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102e7d:	68 20 00 02 00       	push   $0x20020
80102e82:	68 c8 00 00 00       	push   $0xc8
80102e87:	e8 a1 ff ff ff       	call   80102e2d <lapicw>
80102e8c:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000); 
80102e8f:	68 80 96 98 00       	push   $0x989680
80102e94:	68 e0 00 00 00       	push   $0xe0
80102e99:	e8 8f ff ff ff       	call   80102e2d <lapicw>
80102e9e:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102ea1:	68 00 00 01 00       	push   $0x10000
80102ea6:	68 d4 00 00 00       	push   $0xd4
80102eab:	e8 7d ff ff ff       	call   80102e2d <lapicw>
80102eb0:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
80102eb3:	68 00 00 01 00       	push   $0x10000
80102eb8:	68 d8 00 00 00       	push   $0xd8
80102ebd:	e8 6b ff ff ff       	call   80102e2d <lapicw>
80102ec2:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102ec5:	a1 1c 23 11 80       	mov    0x8011231c,%eax
80102eca:	83 c0 30             	add    $0x30,%eax
80102ecd:	8b 00                	mov    (%eax),%eax
80102ecf:	c1 e8 10             	shr    $0x10,%eax
80102ed2:	0f b6 c0             	movzbl %al,%eax
80102ed5:	83 f8 03             	cmp    $0x3,%eax
80102ed8:	76 12                	jbe    80102eec <lapicinit+0x9e>
    lapicw(PCINT, MASKED);
80102eda:	68 00 00 01 00       	push   $0x10000
80102edf:	68 d0 00 00 00       	push   $0xd0
80102ee4:	e8 44 ff ff ff       	call   80102e2d <lapicw>
80102ee9:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102eec:	6a 33                	push   $0x33
80102eee:	68 dc 00 00 00       	push   $0xdc
80102ef3:	e8 35 ff ff ff       	call   80102e2d <lapicw>
80102ef8:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102efb:	6a 00                	push   $0x0
80102efd:	68 a0 00 00 00       	push   $0xa0
80102f02:	e8 26 ff ff ff       	call   80102e2d <lapicw>
80102f07:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
80102f0a:	6a 00                	push   $0x0
80102f0c:	68 a0 00 00 00       	push   $0xa0
80102f11:	e8 17 ff ff ff       	call   80102e2d <lapicw>
80102f16:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102f19:	6a 00                	push   $0x0
80102f1b:	6a 2c                	push   $0x2c
80102f1d:	e8 0b ff ff ff       	call   80102e2d <lapicw>
80102f22:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102f25:	6a 00                	push   $0x0
80102f27:	68 c4 00 00 00       	push   $0xc4
80102f2c:	e8 fc fe ff ff       	call   80102e2d <lapicw>
80102f31:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102f34:	68 00 85 08 00       	push   $0x88500
80102f39:	68 c0 00 00 00       	push   $0xc0
80102f3e:	e8 ea fe ff ff       	call   80102e2d <lapicw>
80102f43:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
80102f46:	90                   	nop
80102f47:	a1 1c 23 11 80       	mov    0x8011231c,%eax
80102f4c:	05 00 03 00 00       	add    $0x300,%eax
80102f51:	8b 00                	mov    (%eax),%eax
80102f53:	25 00 10 00 00       	and    $0x1000,%eax
80102f58:	85 c0                	test   %eax,%eax
80102f5a:	75 eb                	jne    80102f47 <lapicinit+0xf9>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102f5c:	6a 00                	push   $0x0
80102f5e:	6a 20                	push   $0x20
80102f60:	e8 c8 fe ff ff       	call   80102e2d <lapicw>
80102f65:	83 c4 08             	add    $0x8,%esp
}
80102f68:	c9                   	leave  
80102f69:	c3                   	ret    

80102f6a <cpunum>:

int
cpunum(void)
{
80102f6a:	55                   	push   %ebp
80102f6b:	89 e5                	mov    %esp,%ebp
80102f6d:	83 ec 08             	sub    $0x8,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102f70:	e8 a8 fe ff ff       	call   80102e1d <readeflags>
80102f75:	25 00 02 00 00       	and    $0x200,%eax
80102f7a:	85 c0                	test   %eax,%eax
80102f7c:	74 26                	je     80102fa4 <cpunum+0x3a>
    static int n;
    if(n++ == 0)
80102f7e:	a1 60 b6 10 80       	mov    0x8010b660,%eax
80102f83:	8d 50 01             	lea    0x1(%eax),%edx
80102f86:	89 15 60 b6 10 80    	mov    %edx,0x8010b660
80102f8c:	85 c0                	test   %eax,%eax
80102f8e:	75 14                	jne    80102fa4 <cpunum+0x3a>
      cprintf("cpu called from %x with interrupts enabled\n",
80102f90:	8b 45 04             	mov    0x4(%ebp),%eax
80102f93:	83 ec 08             	sub    $0x8,%esp
80102f96:	50                   	push   %eax
80102f97:	68 cc 86 10 80       	push   $0x801086cc
80102f9c:	e8 1e d4 ff ff       	call   801003bf <cprintf>
80102fa1:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if(lapic)
80102fa4:	a1 1c 23 11 80       	mov    0x8011231c,%eax
80102fa9:	85 c0                	test   %eax,%eax
80102fab:	74 0f                	je     80102fbc <cpunum+0x52>
    return lapic[ID]>>24;
80102fad:	a1 1c 23 11 80       	mov    0x8011231c,%eax
80102fb2:	83 c0 20             	add    $0x20,%eax
80102fb5:	8b 00                	mov    (%eax),%eax
80102fb7:	c1 e8 18             	shr    $0x18,%eax
80102fba:	eb 05                	jmp    80102fc1 <cpunum+0x57>
  return 0;
80102fbc:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102fc1:	c9                   	leave  
80102fc2:	c3                   	ret    

80102fc3 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102fc3:	55                   	push   %ebp
80102fc4:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102fc6:	a1 1c 23 11 80       	mov    0x8011231c,%eax
80102fcb:	85 c0                	test   %eax,%eax
80102fcd:	74 0c                	je     80102fdb <lapiceoi+0x18>
    lapicw(EOI, 0);
80102fcf:	6a 00                	push   $0x0
80102fd1:	6a 2c                	push   $0x2c
80102fd3:	e8 55 fe ff ff       	call   80102e2d <lapicw>
80102fd8:	83 c4 08             	add    $0x8,%esp
}
80102fdb:	c9                   	leave  
80102fdc:	c3                   	ret    

80102fdd <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102fdd:	55                   	push   %ebp
80102fde:	89 e5                	mov    %esp,%ebp
}
80102fe0:	5d                   	pop    %ebp
80102fe1:	c3                   	ret    

80102fe2 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102fe2:	55                   	push   %ebp
80102fe3:	89 e5                	mov    %esp,%ebp
80102fe5:	83 ec 14             	sub    $0x14,%esp
80102fe8:	8b 45 08             	mov    0x8(%ebp),%eax
80102feb:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80102fee:	6a 0f                	push   $0xf
80102ff0:	6a 70                	push   $0x70
80102ff2:	e8 08 fe ff ff       	call   80102dff <outb>
80102ff7:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
80102ffa:	6a 0a                	push   $0xa
80102ffc:	6a 71                	push   $0x71
80102ffe:	e8 fc fd ff ff       	call   80102dff <outb>
80103003:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80103006:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
8010300d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103010:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80103015:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103018:	83 c0 02             	add    $0x2,%eax
8010301b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010301e:	c1 ea 04             	shr    $0x4,%edx
80103021:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103024:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103028:	c1 e0 18             	shl    $0x18,%eax
8010302b:	50                   	push   %eax
8010302c:	68 c4 00 00 00       	push   $0xc4
80103031:	e8 f7 fd ff ff       	call   80102e2d <lapicw>
80103036:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80103039:	68 00 c5 00 00       	push   $0xc500
8010303e:	68 c0 00 00 00       	push   $0xc0
80103043:	e8 e5 fd ff ff       	call   80102e2d <lapicw>
80103048:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
8010304b:	68 c8 00 00 00       	push   $0xc8
80103050:	e8 88 ff ff ff       	call   80102fdd <microdelay>
80103055:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
80103058:	68 00 85 00 00       	push   $0x8500
8010305d:	68 c0 00 00 00       	push   $0xc0
80103062:	e8 c6 fd ff ff       	call   80102e2d <lapicw>
80103067:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
8010306a:	6a 64                	push   $0x64
8010306c:	e8 6c ff ff ff       	call   80102fdd <microdelay>
80103071:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103074:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010307b:	eb 3d                	jmp    801030ba <lapicstartap+0xd8>
    lapicw(ICRHI, apicid<<24);
8010307d:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103081:	c1 e0 18             	shl    $0x18,%eax
80103084:	50                   	push   %eax
80103085:	68 c4 00 00 00       	push   $0xc4
8010308a:	e8 9e fd ff ff       	call   80102e2d <lapicw>
8010308f:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
80103092:	8b 45 0c             	mov    0xc(%ebp),%eax
80103095:	c1 e8 0c             	shr    $0xc,%eax
80103098:	80 cc 06             	or     $0x6,%ah
8010309b:	50                   	push   %eax
8010309c:	68 c0 00 00 00       	push   $0xc0
801030a1:	e8 87 fd ff ff       	call   80102e2d <lapicw>
801030a6:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
801030a9:	68 c8 00 00 00       	push   $0xc8
801030ae:	e8 2a ff ff ff       	call   80102fdd <microdelay>
801030b3:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
801030b6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801030ba:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
801030be:	7e bd                	jle    8010307d <lapicstartap+0x9b>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
801030c0:	c9                   	leave  
801030c1:	c3                   	ret    

801030c2 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
801030c2:	55                   	push   %ebp
801030c3:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
801030c5:	8b 45 08             	mov    0x8(%ebp),%eax
801030c8:	0f b6 c0             	movzbl %al,%eax
801030cb:	50                   	push   %eax
801030cc:	6a 70                	push   $0x70
801030ce:	e8 2c fd ff ff       	call   80102dff <outb>
801030d3:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
801030d6:	68 c8 00 00 00       	push   $0xc8
801030db:	e8 fd fe ff ff       	call   80102fdd <microdelay>
801030e0:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
801030e3:	6a 71                	push   $0x71
801030e5:	e8 f8 fc ff ff       	call   80102de2 <inb>
801030ea:	83 c4 04             	add    $0x4,%esp
801030ed:	0f b6 c0             	movzbl %al,%eax
}
801030f0:	c9                   	leave  
801030f1:	c3                   	ret    

801030f2 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
801030f2:	55                   	push   %ebp
801030f3:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
801030f5:	6a 00                	push   $0x0
801030f7:	e8 c6 ff ff ff       	call   801030c2 <cmos_read>
801030fc:	83 c4 04             	add    $0x4,%esp
801030ff:	89 c2                	mov    %eax,%edx
80103101:	8b 45 08             	mov    0x8(%ebp),%eax
80103104:	89 10                	mov    %edx,(%eax)
  r->minute = cmos_read(MINS);
80103106:	6a 02                	push   $0x2
80103108:	e8 b5 ff ff ff       	call   801030c2 <cmos_read>
8010310d:	83 c4 04             	add    $0x4,%esp
80103110:	89 c2                	mov    %eax,%edx
80103112:	8b 45 08             	mov    0x8(%ebp),%eax
80103115:	89 50 04             	mov    %edx,0x4(%eax)
  r->hour   = cmos_read(HOURS);
80103118:	6a 04                	push   $0x4
8010311a:	e8 a3 ff ff ff       	call   801030c2 <cmos_read>
8010311f:	83 c4 04             	add    $0x4,%esp
80103122:	89 c2                	mov    %eax,%edx
80103124:	8b 45 08             	mov    0x8(%ebp),%eax
80103127:	89 50 08             	mov    %edx,0x8(%eax)
  r->day    = cmos_read(DAY);
8010312a:	6a 07                	push   $0x7
8010312c:	e8 91 ff ff ff       	call   801030c2 <cmos_read>
80103131:	83 c4 04             	add    $0x4,%esp
80103134:	89 c2                	mov    %eax,%edx
80103136:	8b 45 08             	mov    0x8(%ebp),%eax
80103139:	89 50 0c             	mov    %edx,0xc(%eax)
  r->month  = cmos_read(MONTH);
8010313c:	6a 08                	push   $0x8
8010313e:	e8 7f ff ff ff       	call   801030c2 <cmos_read>
80103143:	83 c4 04             	add    $0x4,%esp
80103146:	89 c2                	mov    %eax,%edx
80103148:	8b 45 08             	mov    0x8(%ebp),%eax
8010314b:	89 50 10             	mov    %edx,0x10(%eax)
  r->year   = cmos_read(YEAR);
8010314e:	6a 09                	push   $0x9
80103150:	e8 6d ff ff ff       	call   801030c2 <cmos_read>
80103155:	83 c4 04             	add    $0x4,%esp
80103158:	89 c2                	mov    %eax,%edx
8010315a:	8b 45 08             	mov    0x8(%ebp),%eax
8010315d:	89 50 14             	mov    %edx,0x14(%eax)
}
80103160:	c9                   	leave  
80103161:	c3                   	ret    

80103162 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80103162:	55                   	push   %ebp
80103163:	89 e5                	mov    %esp,%ebp
80103165:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
80103168:	6a 0b                	push   $0xb
8010316a:	e8 53 ff ff ff       	call   801030c2 <cmos_read>
8010316f:	83 c4 04             	add    $0x4,%esp
80103172:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
80103175:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103178:	83 e0 04             	and    $0x4,%eax
8010317b:	85 c0                	test   %eax,%eax
8010317d:	0f 94 c0             	sete   %al
80103180:	0f b6 c0             	movzbl %al,%eax
80103183:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
80103186:	8d 45 d8             	lea    -0x28(%ebp),%eax
80103189:	50                   	push   %eax
8010318a:	e8 63 ff ff ff       	call   801030f2 <fill_rtcdate>
8010318f:	83 c4 04             	add    $0x4,%esp
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
80103192:	6a 0a                	push   $0xa
80103194:	e8 29 ff ff ff       	call   801030c2 <cmos_read>
80103199:	83 c4 04             	add    $0x4,%esp
8010319c:	25 80 00 00 00       	and    $0x80,%eax
801031a1:	85 c0                	test   %eax,%eax
801031a3:	74 02                	je     801031a7 <cmostime+0x45>
        continue;
801031a5:	eb 32                	jmp    801031d9 <cmostime+0x77>
    fill_rtcdate(&t2);
801031a7:	8d 45 c0             	lea    -0x40(%ebp),%eax
801031aa:	50                   	push   %eax
801031ab:	e8 42 ff ff ff       	call   801030f2 <fill_rtcdate>
801031b0:	83 c4 04             	add    $0x4,%esp
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
801031b3:	83 ec 04             	sub    $0x4,%esp
801031b6:	6a 18                	push   $0x18
801031b8:	8d 45 c0             	lea    -0x40(%ebp),%eax
801031bb:	50                   	push   %eax
801031bc:	8d 45 d8             	lea    -0x28(%ebp),%eax
801031bf:	50                   	push   %eax
801031c0:	e8 79 20 00 00       	call   8010523e <memcmp>
801031c5:	83 c4 10             	add    $0x10,%esp
801031c8:	85 c0                	test   %eax,%eax
801031ca:	75 0d                	jne    801031d9 <cmostime+0x77>
      break;
801031cc:	90                   	nop
  }

  // convert
  if (bcd) {
801031cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801031d1:	0f 84 b8 00 00 00    	je     8010328f <cmostime+0x12d>
801031d7:	eb 02                	jmp    801031db <cmostime+0x79>
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
801031d9:	eb ab                	jmp    80103186 <cmostime+0x24>

  // convert
  if (bcd) {
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801031db:	8b 45 d8             	mov    -0x28(%ebp),%eax
801031de:	c1 e8 04             	shr    $0x4,%eax
801031e1:	89 c2                	mov    %eax,%edx
801031e3:	89 d0                	mov    %edx,%eax
801031e5:	c1 e0 02             	shl    $0x2,%eax
801031e8:	01 d0                	add    %edx,%eax
801031ea:	01 c0                	add    %eax,%eax
801031ec:	89 c2                	mov    %eax,%edx
801031ee:	8b 45 d8             	mov    -0x28(%ebp),%eax
801031f1:	83 e0 0f             	and    $0xf,%eax
801031f4:	01 d0                	add    %edx,%eax
801031f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
801031f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801031fc:	c1 e8 04             	shr    $0x4,%eax
801031ff:	89 c2                	mov    %eax,%edx
80103201:	89 d0                	mov    %edx,%eax
80103203:	c1 e0 02             	shl    $0x2,%eax
80103206:	01 d0                	add    %edx,%eax
80103208:	01 c0                	add    %eax,%eax
8010320a:	89 c2                	mov    %eax,%edx
8010320c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010320f:	83 e0 0f             	and    $0xf,%eax
80103212:	01 d0                	add    %edx,%eax
80103214:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
80103217:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010321a:	c1 e8 04             	shr    $0x4,%eax
8010321d:	89 c2                	mov    %eax,%edx
8010321f:	89 d0                	mov    %edx,%eax
80103221:	c1 e0 02             	shl    $0x2,%eax
80103224:	01 d0                	add    %edx,%eax
80103226:	01 c0                	add    %eax,%eax
80103228:	89 c2                	mov    %eax,%edx
8010322a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010322d:	83 e0 0f             	and    $0xf,%eax
80103230:	01 d0                	add    %edx,%eax
80103232:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
80103235:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103238:	c1 e8 04             	shr    $0x4,%eax
8010323b:	89 c2                	mov    %eax,%edx
8010323d:	89 d0                	mov    %edx,%eax
8010323f:	c1 e0 02             	shl    $0x2,%eax
80103242:	01 d0                	add    %edx,%eax
80103244:	01 c0                	add    %eax,%eax
80103246:	89 c2                	mov    %eax,%edx
80103248:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010324b:	83 e0 0f             	and    $0xf,%eax
8010324e:	01 d0                	add    %edx,%eax
80103250:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
80103253:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103256:	c1 e8 04             	shr    $0x4,%eax
80103259:	89 c2                	mov    %eax,%edx
8010325b:	89 d0                	mov    %edx,%eax
8010325d:	c1 e0 02             	shl    $0x2,%eax
80103260:	01 d0                	add    %edx,%eax
80103262:	01 c0                	add    %eax,%eax
80103264:	89 c2                	mov    %eax,%edx
80103266:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103269:	83 e0 0f             	and    $0xf,%eax
8010326c:	01 d0                	add    %edx,%eax
8010326e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
80103271:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103274:	c1 e8 04             	shr    $0x4,%eax
80103277:	89 c2                	mov    %eax,%edx
80103279:	89 d0                	mov    %edx,%eax
8010327b:	c1 e0 02             	shl    $0x2,%eax
8010327e:	01 d0                	add    %edx,%eax
80103280:	01 c0                	add    %eax,%eax
80103282:	89 c2                	mov    %eax,%edx
80103284:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103287:	83 e0 0f             	and    $0xf,%eax
8010328a:	01 d0                	add    %edx,%eax
8010328c:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
8010328f:	8b 45 08             	mov    0x8(%ebp),%eax
80103292:	8b 55 d8             	mov    -0x28(%ebp),%edx
80103295:	89 10                	mov    %edx,(%eax)
80103297:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010329a:	89 50 04             	mov    %edx,0x4(%eax)
8010329d:	8b 55 e0             	mov    -0x20(%ebp),%edx
801032a0:	89 50 08             	mov    %edx,0x8(%eax)
801032a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801032a6:	89 50 0c             	mov    %edx,0xc(%eax)
801032a9:	8b 55 e8             	mov    -0x18(%ebp),%edx
801032ac:	89 50 10             	mov    %edx,0x10(%eax)
801032af:	8b 55 ec             	mov    -0x14(%ebp),%edx
801032b2:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
801032b5:	8b 45 08             	mov    0x8(%ebp),%eax
801032b8:	8b 40 14             	mov    0x14(%eax),%eax
801032bb:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
801032c1:	8b 45 08             	mov    0x8(%ebp),%eax
801032c4:	89 50 14             	mov    %edx,0x14(%eax)
}
801032c7:	c9                   	leave  
801032c8:	c3                   	ret    

801032c9 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
801032c9:	55                   	push   %ebp
801032ca:	89 e5                	mov    %esp,%ebp
801032cc:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
801032cf:	83 ec 08             	sub    $0x8,%esp
801032d2:	68 f8 86 10 80       	push   $0x801086f8
801032d7:	68 40 23 11 80       	push   $0x80112340
801032dc:	e8 79 1c 00 00       	call   80104f5a <initlock>
801032e1:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
801032e4:	83 ec 08             	sub    $0x8,%esp
801032e7:	8d 45 dc             	lea    -0x24(%ebp),%eax
801032ea:	50                   	push   %eax
801032eb:	ff 75 08             	pushl  0x8(%ebp)
801032ee:	e8 4c e0 ff ff       	call   8010133f <readsb>
801032f3:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
801032f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801032f9:	a3 74 23 11 80       	mov    %eax,0x80112374
  log.size = sb.nlog;
801032fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103301:	a3 78 23 11 80       	mov    %eax,0x80112378
  log.dev = dev;
80103306:	8b 45 08             	mov    0x8(%ebp),%eax
80103309:	a3 84 23 11 80       	mov    %eax,0x80112384
  recover_from_log();
8010330e:	e8 ae 01 00 00       	call   801034c1 <recover_from_log>
}
80103313:	c9                   	leave  
80103314:	c3                   	ret    

80103315 <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
80103315:	55                   	push   %ebp
80103316:	89 e5                	mov    %esp,%ebp
80103318:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010331b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103322:	e9 95 00 00 00       	jmp    801033bc <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103327:	8b 15 74 23 11 80    	mov    0x80112374,%edx
8010332d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103330:	01 d0                	add    %edx,%eax
80103332:	83 c0 01             	add    $0x1,%eax
80103335:	89 c2                	mov    %eax,%edx
80103337:	a1 84 23 11 80       	mov    0x80112384,%eax
8010333c:	83 ec 08             	sub    $0x8,%esp
8010333f:	52                   	push   %edx
80103340:	50                   	push   %eax
80103341:	e8 6e ce ff ff       	call   801001b4 <bread>
80103346:	83 c4 10             	add    $0x10,%esp
80103349:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010334c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010334f:	83 c0 10             	add    $0x10,%eax
80103352:	8b 04 85 4c 23 11 80 	mov    -0x7feedcb4(,%eax,4),%eax
80103359:	89 c2                	mov    %eax,%edx
8010335b:	a1 84 23 11 80       	mov    0x80112384,%eax
80103360:	83 ec 08             	sub    $0x8,%esp
80103363:	52                   	push   %edx
80103364:	50                   	push   %eax
80103365:	e8 4a ce ff ff       	call   801001b4 <bread>
8010336a:	83 c4 10             	add    $0x10,%esp
8010336d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103370:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103373:	8d 50 18             	lea    0x18(%eax),%edx
80103376:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103379:	83 c0 18             	add    $0x18,%eax
8010337c:	83 ec 04             	sub    $0x4,%esp
8010337f:	68 00 02 00 00       	push   $0x200
80103384:	52                   	push   %edx
80103385:	50                   	push   %eax
80103386:	e8 0b 1f 00 00       	call   80105296 <memmove>
8010338b:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
8010338e:	83 ec 0c             	sub    $0xc,%esp
80103391:	ff 75 ec             	pushl  -0x14(%ebp)
80103394:	e8 54 ce ff ff       	call   801001ed <bwrite>
80103399:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf); 
8010339c:	83 ec 0c             	sub    $0xc,%esp
8010339f:	ff 75 f0             	pushl  -0x10(%ebp)
801033a2:	e8 84 ce ff ff       	call   8010022b <brelse>
801033a7:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
801033aa:	83 ec 0c             	sub    $0xc,%esp
801033ad:	ff 75 ec             	pushl  -0x14(%ebp)
801033b0:	e8 76 ce ff ff       	call   8010022b <brelse>
801033b5:	83 c4 10             	add    $0x10,%esp
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801033b8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801033bc:	a1 88 23 11 80       	mov    0x80112388,%eax
801033c1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801033c4:	0f 8f 5d ff ff ff    	jg     80103327 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
801033ca:	c9                   	leave  
801033cb:	c3                   	ret    

801033cc <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
801033cc:	55                   	push   %ebp
801033cd:	89 e5                	mov    %esp,%ebp
801033cf:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
801033d2:	a1 74 23 11 80       	mov    0x80112374,%eax
801033d7:	89 c2                	mov    %eax,%edx
801033d9:	a1 84 23 11 80       	mov    0x80112384,%eax
801033de:	83 ec 08             	sub    $0x8,%esp
801033e1:	52                   	push   %edx
801033e2:	50                   	push   %eax
801033e3:	e8 cc cd ff ff       	call   801001b4 <bread>
801033e8:	83 c4 10             	add    $0x10,%esp
801033eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
801033ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033f1:	83 c0 18             	add    $0x18,%eax
801033f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
801033f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033fa:	8b 00                	mov    (%eax),%eax
801033fc:	a3 88 23 11 80       	mov    %eax,0x80112388
  for (i = 0; i < log.lh.n; i++) {
80103401:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103408:	eb 1b                	jmp    80103425 <read_head+0x59>
    log.lh.block[i] = lh->block[i];
8010340a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010340d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103410:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103414:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103417:	83 c2 10             	add    $0x10,%edx
8010341a:	89 04 95 4c 23 11 80 	mov    %eax,-0x7feedcb4(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80103421:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103425:	a1 88 23 11 80       	mov    0x80112388,%eax
8010342a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010342d:	7f db                	jg     8010340a <read_head+0x3e>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
8010342f:	83 ec 0c             	sub    $0xc,%esp
80103432:	ff 75 f0             	pushl  -0x10(%ebp)
80103435:	e8 f1 cd ff ff       	call   8010022b <brelse>
8010343a:	83 c4 10             	add    $0x10,%esp
}
8010343d:	c9                   	leave  
8010343e:	c3                   	ret    

8010343f <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
8010343f:	55                   	push   %ebp
80103440:	89 e5                	mov    %esp,%ebp
80103442:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80103445:	a1 74 23 11 80       	mov    0x80112374,%eax
8010344a:	89 c2                	mov    %eax,%edx
8010344c:	a1 84 23 11 80       	mov    0x80112384,%eax
80103451:	83 ec 08             	sub    $0x8,%esp
80103454:	52                   	push   %edx
80103455:	50                   	push   %eax
80103456:	e8 59 cd ff ff       	call   801001b4 <bread>
8010345b:	83 c4 10             	add    $0x10,%esp
8010345e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
80103461:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103464:	83 c0 18             	add    $0x18,%eax
80103467:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
8010346a:	8b 15 88 23 11 80    	mov    0x80112388,%edx
80103470:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103473:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103475:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010347c:	eb 1b                	jmp    80103499 <write_head+0x5a>
    hb->block[i] = log.lh.block[i];
8010347e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103481:	83 c0 10             	add    $0x10,%eax
80103484:	8b 0c 85 4c 23 11 80 	mov    -0x7feedcb4(,%eax,4),%ecx
8010348b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010348e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103491:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103495:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103499:	a1 88 23 11 80       	mov    0x80112388,%eax
8010349e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801034a1:	7f db                	jg     8010347e <write_head+0x3f>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
801034a3:	83 ec 0c             	sub    $0xc,%esp
801034a6:	ff 75 f0             	pushl  -0x10(%ebp)
801034a9:	e8 3f cd ff ff       	call   801001ed <bwrite>
801034ae:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
801034b1:	83 ec 0c             	sub    $0xc,%esp
801034b4:	ff 75 f0             	pushl  -0x10(%ebp)
801034b7:	e8 6f cd ff ff       	call   8010022b <brelse>
801034bc:	83 c4 10             	add    $0x10,%esp
}
801034bf:	c9                   	leave  
801034c0:	c3                   	ret    

801034c1 <recover_from_log>:

static void
recover_from_log(void)
{
801034c1:	55                   	push   %ebp
801034c2:	89 e5                	mov    %esp,%ebp
801034c4:	83 ec 08             	sub    $0x8,%esp
  read_head();      
801034c7:	e8 00 ff ff ff       	call   801033cc <read_head>
  install_trans(); // if committed, copy from log to disk
801034cc:	e8 44 fe ff ff       	call   80103315 <install_trans>
  log.lh.n = 0;
801034d1:	c7 05 88 23 11 80 00 	movl   $0x0,0x80112388
801034d8:	00 00 00 
  write_head(); // clear the log
801034db:	e8 5f ff ff ff       	call   8010343f <write_head>
}
801034e0:	c9                   	leave  
801034e1:	c3                   	ret    

801034e2 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
801034e2:	55                   	push   %ebp
801034e3:	89 e5                	mov    %esp,%ebp
801034e5:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
801034e8:	83 ec 0c             	sub    $0xc,%esp
801034eb:	68 40 23 11 80       	push   $0x80112340
801034f0:	e8 86 1a 00 00       	call   80104f7b <acquire>
801034f5:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
801034f8:	a1 80 23 11 80       	mov    0x80112380,%eax
801034fd:	85 c0                	test   %eax,%eax
801034ff:	74 17                	je     80103518 <begin_op+0x36>
      sleep(&log, &log.lock);
80103501:	83 ec 08             	sub    $0x8,%esp
80103504:	68 40 23 11 80       	push   $0x80112340
80103509:	68 40 23 11 80       	push   $0x80112340
8010350e:	e8 78 17 00 00       	call   80104c8b <sleep>
80103513:	83 c4 10             	add    $0x10,%esp
80103516:	eb 54                	jmp    8010356c <begin_op+0x8a>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103518:	8b 0d 88 23 11 80    	mov    0x80112388,%ecx
8010351e:	a1 7c 23 11 80       	mov    0x8011237c,%eax
80103523:	8d 50 01             	lea    0x1(%eax),%edx
80103526:	89 d0                	mov    %edx,%eax
80103528:	c1 e0 02             	shl    $0x2,%eax
8010352b:	01 d0                	add    %edx,%eax
8010352d:	01 c0                	add    %eax,%eax
8010352f:	01 c8                	add    %ecx,%eax
80103531:	83 f8 1e             	cmp    $0x1e,%eax
80103534:	7e 17                	jle    8010354d <begin_op+0x6b>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
80103536:	83 ec 08             	sub    $0x8,%esp
80103539:	68 40 23 11 80       	push   $0x80112340
8010353e:	68 40 23 11 80       	push   $0x80112340
80103543:	e8 43 17 00 00       	call   80104c8b <sleep>
80103548:	83 c4 10             	add    $0x10,%esp
8010354b:	eb 1f                	jmp    8010356c <begin_op+0x8a>
    } else {
      log.outstanding += 1;
8010354d:	a1 7c 23 11 80       	mov    0x8011237c,%eax
80103552:	83 c0 01             	add    $0x1,%eax
80103555:	a3 7c 23 11 80       	mov    %eax,0x8011237c
      release(&log.lock);
8010355a:	83 ec 0c             	sub    $0xc,%esp
8010355d:	68 40 23 11 80       	push   $0x80112340
80103562:	e8 7a 1a 00 00       	call   80104fe1 <release>
80103567:	83 c4 10             	add    $0x10,%esp
      break;
8010356a:	eb 02                	jmp    8010356e <begin_op+0x8c>
    }
  }
8010356c:	eb 8a                	jmp    801034f8 <begin_op+0x16>
}
8010356e:	c9                   	leave  
8010356f:	c3                   	ret    

80103570 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103570:	55                   	push   %ebp
80103571:	89 e5                	mov    %esp,%ebp
80103573:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
80103576:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
8010357d:	83 ec 0c             	sub    $0xc,%esp
80103580:	68 40 23 11 80       	push   $0x80112340
80103585:	e8 f1 19 00 00       	call   80104f7b <acquire>
8010358a:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
8010358d:	a1 7c 23 11 80       	mov    0x8011237c,%eax
80103592:	83 e8 01             	sub    $0x1,%eax
80103595:	a3 7c 23 11 80       	mov    %eax,0x8011237c
  if(log.committing)
8010359a:	a1 80 23 11 80       	mov    0x80112380,%eax
8010359f:	85 c0                	test   %eax,%eax
801035a1:	74 0d                	je     801035b0 <end_op+0x40>
    panic("log.committing");
801035a3:	83 ec 0c             	sub    $0xc,%esp
801035a6:	68 fc 86 10 80       	push   $0x801086fc
801035ab:	e8 ac cf ff ff       	call   8010055c <panic>
  if(log.outstanding == 0){
801035b0:	a1 7c 23 11 80       	mov    0x8011237c,%eax
801035b5:	85 c0                	test   %eax,%eax
801035b7:	75 13                	jne    801035cc <end_op+0x5c>
    do_commit = 1;
801035b9:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
801035c0:	c7 05 80 23 11 80 01 	movl   $0x1,0x80112380
801035c7:	00 00 00 
801035ca:	eb 10                	jmp    801035dc <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
801035cc:	83 ec 0c             	sub    $0xc,%esp
801035cf:	68 40 23 11 80       	push   $0x80112340
801035d4:	e8 9b 17 00 00       	call   80104d74 <wakeup>
801035d9:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
801035dc:	83 ec 0c             	sub    $0xc,%esp
801035df:	68 40 23 11 80       	push   $0x80112340
801035e4:	e8 f8 19 00 00       	call   80104fe1 <release>
801035e9:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
801035ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801035f0:	74 3f                	je     80103631 <end_op+0xc1>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
801035f2:	e8 f3 00 00 00       	call   801036ea <commit>
    acquire(&log.lock);
801035f7:	83 ec 0c             	sub    $0xc,%esp
801035fa:	68 40 23 11 80       	push   $0x80112340
801035ff:	e8 77 19 00 00       	call   80104f7b <acquire>
80103604:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
80103607:	c7 05 80 23 11 80 00 	movl   $0x0,0x80112380
8010360e:	00 00 00 
    wakeup(&log);
80103611:	83 ec 0c             	sub    $0xc,%esp
80103614:	68 40 23 11 80       	push   $0x80112340
80103619:	e8 56 17 00 00       	call   80104d74 <wakeup>
8010361e:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
80103621:	83 ec 0c             	sub    $0xc,%esp
80103624:	68 40 23 11 80       	push   $0x80112340
80103629:	e8 b3 19 00 00       	call   80104fe1 <release>
8010362e:	83 c4 10             	add    $0x10,%esp
  }
}
80103631:	c9                   	leave  
80103632:	c3                   	ret    

80103633 <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
80103633:	55                   	push   %ebp
80103634:	89 e5                	mov    %esp,%ebp
80103636:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103639:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103640:	e9 95 00 00 00       	jmp    801036da <write_log+0xa7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103645:	8b 15 74 23 11 80    	mov    0x80112374,%edx
8010364b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010364e:	01 d0                	add    %edx,%eax
80103650:	83 c0 01             	add    $0x1,%eax
80103653:	89 c2                	mov    %eax,%edx
80103655:	a1 84 23 11 80       	mov    0x80112384,%eax
8010365a:	83 ec 08             	sub    $0x8,%esp
8010365d:	52                   	push   %edx
8010365e:	50                   	push   %eax
8010365f:	e8 50 cb ff ff       	call   801001b4 <bread>
80103664:	83 c4 10             	add    $0x10,%esp
80103667:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010366a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010366d:	83 c0 10             	add    $0x10,%eax
80103670:	8b 04 85 4c 23 11 80 	mov    -0x7feedcb4(,%eax,4),%eax
80103677:	89 c2                	mov    %eax,%edx
80103679:	a1 84 23 11 80       	mov    0x80112384,%eax
8010367e:	83 ec 08             	sub    $0x8,%esp
80103681:	52                   	push   %edx
80103682:	50                   	push   %eax
80103683:	e8 2c cb ff ff       	call   801001b4 <bread>
80103688:	83 c4 10             	add    $0x10,%esp
8010368b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
8010368e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103691:	8d 50 18             	lea    0x18(%eax),%edx
80103694:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103697:	83 c0 18             	add    $0x18,%eax
8010369a:	83 ec 04             	sub    $0x4,%esp
8010369d:	68 00 02 00 00       	push   $0x200
801036a2:	52                   	push   %edx
801036a3:	50                   	push   %eax
801036a4:	e8 ed 1b 00 00       	call   80105296 <memmove>
801036a9:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
801036ac:	83 ec 0c             	sub    $0xc,%esp
801036af:	ff 75 f0             	pushl  -0x10(%ebp)
801036b2:	e8 36 cb ff ff       	call   801001ed <bwrite>
801036b7:	83 c4 10             	add    $0x10,%esp
    brelse(from); 
801036ba:	83 ec 0c             	sub    $0xc,%esp
801036bd:	ff 75 ec             	pushl  -0x14(%ebp)
801036c0:	e8 66 cb ff ff       	call   8010022b <brelse>
801036c5:	83 c4 10             	add    $0x10,%esp
    brelse(to);
801036c8:	83 ec 0c             	sub    $0xc,%esp
801036cb:	ff 75 f0             	pushl  -0x10(%ebp)
801036ce:	e8 58 cb ff ff       	call   8010022b <brelse>
801036d3:	83 c4 10             	add    $0x10,%esp
static void 
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801036d6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801036da:	a1 88 23 11 80       	mov    0x80112388,%eax
801036df:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801036e2:	0f 8f 5d ff ff ff    	jg     80103645 <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from); 
    brelse(to);
  }
}
801036e8:	c9                   	leave  
801036e9:	c3                   	ret    

801036ea <commit>:

static void
commit()
{
801036ea:	55                   	push   %ebp
801036eb:	89 e5                	mov    %esp,%ebp
801036ed:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
801036f0:	a1 88 23 11 80       	mov    0x80112388,%eax
801036f5:	85 c0                	test   %eax,%eax
801036f7:	7e 1e                	jle    80103717 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
801036f9:	e8 35 ff ff ff       	call   80103633 <write_log>
    write_head();    // Write header to disk -- the real commit
801036fe:	e8 3c fd ff ff       	call   8010343f <write_head>
    install_trans(); // Now install writes to home locations
80103703:	e8 0d fc ff ff       	call   80103315 <install_trans>
    log.lh.n = 0; 
80103708:	c7 05 88 23 11 80 00 	movl   $0x0,0x80112388
8010370f:	00 00 00 
    write_head();    // Erase the transaction from the log
80103712:	e8 28 fd ff ff       	call   8010343f <write_head>
  }
}
80103717:	c9                   	leave  
80103718:	c3                   	ret    

80103719 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103719:	55                   	push   %ebp
8010371a:	89 e5                	mov    %esp,%ebp
8010371c:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
8010371f:	a1 88 23 11 80       	mov    0x80112388,%eax
80103724:	83 f8 1d             	cmp    $0x1d,%eax
80103727:	7f 12                	jg     8010373b <log_write+0x22>
80103729:	a1 88 23 11 80       	mov    0x80112388,%eax
8010372e:	8b 15 78 23 11 80    	mov    0x80112378,%edx
80103734:	83 ea 01             	sub    $0x1,%edx
80103737:	39 d0                	cmp    %edx,%eax
80103739:	7c 0d                	jl     80103748 <log_write+0x2f>
    panic("too big a transaction");
8010373b:	83 ec 0c             	sub    $0xc,%esp
8010373e:	68 0b 87 10 80       	push   $0x8010870b
80103743:	e8 14 ce ff ff       	call   8010055c <panic>
  if (log.outstanding < 1)
80103748:	a1 7c 23 11 80       	mov    0x8011237c,%eax
8010374d:	85 c0                	test   %eax,%eax
8010374f:	7f 0d                	jg     8010375e <log_write+0x45>
    panic("log_write outside of trans");
80103751:	83 ec 0c             	sub    $0xc,%esp
80103754:	68 21 87 10 80       	push   $0x80108721
80103759:	e8 fe cd ff ff       	call   8010055c <panic>

  acquire(&log.lock);
8010375e:	83 ec 0c             	sub    $0xc,%esp
80103761:	68 40 23 11 80       	push   $0x80112340
80103766:	e8 10 18 00 00       	call   80104f7b <acquire>
8010376b:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
8010376e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103775:	eb 1f                	jmp    80103796 <log_write+0x7d>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103777:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010377a:	83 c0 10             	add    $0x10,%eax
8010377d:	8b 04 85 4c 23 11 80 	mov    -0x7feedcb4(,%eax,4),%eax
80103784:	89 c2                	mov    %eax,%edx
80103786:	8b 45 08             	mov    0x8(%ebp),%eax
80103789:	8b 40 08             	mov    0x8(%eax),%eax
8010378c:	39 c2                	cmp    %eax,%edx
8010378e:	75 02                	jne    80103792 <log_write+0x79>
      break;
80103790:	eb 0e                	jmp    801037a0 <log_write+0x87>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80103792:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103796:	a1 88 23 11 80       	mov    0x80112388,%eax
8010379b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010379e:	7f d7                	jg     80103777 <log_write+0x5e>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
801037a0:	8b 45 08             	mov    0x8(%ebp),%eax
801037a3:	8b 40 08             	mov    0x8(%eax),%eax
801037a6:	89 c2                	mov    %eax,%edx
801037a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037ab:	83 c0 10             	add    $0x10,%eax
801037ae:	89 14 85 4c 23 11 80 	mov    %edx,-0x7feedcb4(,%eax,4)
  if (i == log.lh.n)
801037b5:	a1 88 23 11 80       	mov    0x80112388,%eax
801037ba:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801037bd:	75 0d                	jne    801037cc <log_write+0xb3>
    log.lh.n++;
801037bf:	a1 88 23 11 80       	mov    0x80112388,%eax
801037c4:	83 c0 01             	add    $0x1,%eax
801037c7:	a3 88 23 11 80       	mov    %eax,0x80112388
  b->flags |= B_DIRTY; // prevent eviction
801037cc:	8b 45 08             	mov    0x8(%ebp),%eax
801037cf:	8b 00                	mov    (%eax),%eax
801037d1:	83 c8 04             	or     $0x4,%eax
801037d4:	89 c2                	mov    %eax,%edx
801037d6:	8b 45 08             	mov    0x8(%ebp),%eax
801037d9:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
801037db:	83 ec 0c             	sub    $0xc,%esp
801037de:	68 40 23 11 80       	push   $0x80112340
801037e3:	e8 f9 17 00 00       	call   80104fe1 <release>
801037e8:	83 c4 10             	add    $0x10,%esp
}
801037eb:	c9                   	leave  
801037ec:	c3                   	ret    

801037ed <v2p>:
801037ed:	55                   	push   %ebp
801037ee:	89 e5                	mov    %esp,%ebp
801037f0:	8b 45 08             	mov    0x8(%ebp),%eax
801037f3:	05 00 00 00 80       	add    $0x80000000,%eax
801037f8:	5d                   	pop    %ebp
801037f9:	c3                   	ret    

801037fa <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
801037fa:	55                   	push   %ebp
801037fb:	89 e5                	mov    %esp,%ebp
801037fd:	8b 45 08             	mov    0x8(%ebp),%eax
80103800:	05 00 00 00 80       	add    $0x80000000,%eax
80103805:	5d                   	pop    %ebp
80103806:	c3                   	ret    

80103807 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103807:	55                   	push   %ebp
80103808:	89 e5                	mov    %esp,%ebp
8010380a:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010380d:	8b 55 08             	mov    0x8(%ebp),%edx
80103810:	8b 45 0c             	mov    0xc(%ebp),%eax
80103813:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103816:	f0 87 02             	lock xchg %eax,(%edx)
80103819:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
8010381c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010381f:	c9                   	leave  
80103820:	c3                   	ret    

80103821 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103821:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103825:	83 e4 f0             	and    $0xfffffff0,%esp
80103828:	ff 71 fc             	pushl  -0x4(%ecx)
8010382b:	55                   	push   %ebp
8010382c:	89 e5                	mov    %esp,%ebp
8010382e:	51                   	push   %ecx
8010382f:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103832:	83 ec 08             	sub    $0x8,%esp
80103835:	68 00 00 40 80       	push   $0x80400000
8010383a:	68 5c 52 11 80       	push   $0x8011525c
8010383f:	e8 92 f2 ff ff       	call   80102ad6 <kinit1>
80103844:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
80103847:	e8 d2 44 00 00       	call   80107d1e <kvmalloc>
  mpinit();        // collect info about this machine
8010384c:	e8 40 04 00 00       	call   80103c91 <mpinit>
  lapicinit();
80103851:	e8 f8 f5 ff ff       	call   80102e4e <lapicinit>
  seginit();       // set up segments
80103856:	e8 6b 3e 00 00       	call   801076c6 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
8010385b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103861:	0f b6 00             	movzbl (%eax),%eax
80103864:	0f b6 c0             	movzbl %al,%eax
80103867:	83 ec 08             	sub    $0x8,%esp
8010386a:	50                   	push   %eax
8010386b:	68 3c 87 10 80       	push   $0x8010873c
80103870:	e8 4a cb ff ff       	call   801003bf <cprintf>
80103875:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
80103878:	e8 65 06 00 00       	call   80103ee2 <picinit>
  ioapicinit();    // another interrupt controller
8010387d:	e8 4c f1 ff ff       	call   801029ce <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103882:	e8 51 d2 ff ff       	call   80100ad8 <consoleinit>
  uartinit();      // serial port
80103887:	e8 9d 31 00 00       	call   80106a29 <uartinit>
  pinit();         // process table
8010388c:	e8 50 0b 00 00       	call   801043e1 <pinit>
  tvinit();        // trap vectors
80103891:	e8 62 2d 00 00       	call   801065f8 <tvinit>
  binit();         // buffer cache
80103896:	e8 99 c7 ff ff       	call   80100034 <binit>
  fileinit();      // file table
8010389b:	e8 93 d6 ff ff       	call   80100f33 <fileinit>
  ideinit();       // disk
801038a0:	e8 35 ed ff ff       	call   801025da <ideinit>
  if(!ismp)
801038a5:	a1 44 24 11 80       	mov    0x80112444,%eax
801038aa:	85 c0                	test   %eax,%eax
801038ac:	75 05                	jne    801038b3 <main+0x92>
    timerinit();   // uniprocessor timer
801038ae:	e8 a4 2c 00 00       	call   80106557 <timerinit>
  startothers();   // start other processors
801038b3:	e8 7f 00 00 00       	call   80103937 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801038b8:	83 ec 08             	sub    $0x8,%esp
801038bb:	68 00 00 00 8e       	push   $0x8e000000
801038c0:	68 00 00 40 80       	push   $0x80400000
801038c5:	e8 44 f2 ff ff       	call   80102b0e <kinit2>
801038ca:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
801038cd:	e8 31 0c 00 00       	call   80104503 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
801038d2:	e8 1a 00 00 00       	call   801038f1 <mpmain>

801038d7 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
801038d7:	55                   	push   %ebp
801038d8:	89 e5                	mov    %esp,%ebp
801038da:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
801038dd:	e8 53 44 00 00       	call   80107d35 <switchkvm>
  seginit();
801038e2:	e8 df 3d 00 00       	call   801076c6 <seginit>
  lapicinit();
801038e7:	e8 62 f5 ff ff       	call   80102e4e <lapicinit>
  mpmain();
801038ec:	e8 00 00 00 00       	call   801038f1 <mpmain>

801038f1 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801038f1:	55                   	push   %ebp
801038f2:	89 e5                	mov    %esp,%ebp
801038f4:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpu->id);
801038f7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801038fd:	0f b6 00             	movzbl (%eax),%eax
80103900:	0f b6 c0             	movzbl %al,%eax
80103903:	83 ec 08             	sub    $0x8,%esp
80103906:	50                   	push   %eax
80103907:	68 53 87 10 80       	push   $0x80108753
8010390c:	e8 ae ca ff ff       	call   801003bf <cprintf>
80103911:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103914:	e8 54 2e 00 00       	call   8010676d <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103919:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010391f:	05 a8 00 00 00       	add    $0xa8,%eax
80103924:	83 ec 08             	sub    $0x8,%esp
80103927:	6a 01                	push   $0x1
80103929:	50                   	push   %eax
8010392a:	e8 d8 fe ff ff       	call   80103807 <xchg>
8010392f:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
80103932:	e8 76 11 00 00       	call   80104aad <scheduler>

80103937 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103937:	55                   	push   %ebp
80103938:	89 e5                	mov    %esp,%ebp
8010393a:	53                   	push   %ebx
8010393b:	83 ec 14             	sub    $0x14,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
8010393e:	68 00 70 00 00       	push   $0x7000
80103943:	e8 b2 fe ff ff       	call   801037fa <p2v>
80103948:	83 c4 04             	add    $0x4,%esp
8010394b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
8010394e:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103953:	83 ec 04             	sub    $0x4,%esp
80103956:	50                   	push   %eax
80103957:	68 2c b5 10 80       	push   $0x8010b52c
8010395c:	ff 75 f0             	pushl  -0x10(%ebp)
8010395f:	e8 32 19 00 00       	call   80105296 <memmove>
80103964:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103967:	c7 45 f4 80 24 11 80 	movl   $0x80112480,-0xc(%ebp)
8010396e:	e9 8f 00 00 00       	jmp    80103a02 <startothers+0xcb>
    if(c == cpus+cpunum())  // We've started already.
80103973:	e8 f2 f5 ff ff       	call   80102f6a <cpunum>
80103978:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
8010397e:	05 80 24 11 80       	add    $0x80112480,%eax
80103983:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103986:	75 02                	jne    8010398a <startothers+0x53>
      continue;
80103988:	eb 71                	jmp    801039fb <startothers+0xc4>

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
8010398a:	e8 7a f2 ff ff       	call   80102c09 <kalloc>
8010398f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103992:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103995:	83 e8 04             	sub    $0x4,%eax
80103998:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010399b:	81 c2 00 10 00 00    	add    $0x1000,%edx
801039a1:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
801039a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039a6:	83 e8 08             	sub    $0x8,%eax
801039a9:	c7 00 d7 38 10 80    	movl   $0x801038d7,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
801039af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039b2:	8d 58 f4             	lea    -0xc(%eax),%ebx
801039b5:	83 ec 0c             	sub    $0xc,%esp
801039b8:	68 00 a0 10 80       	push   $0x8010a000
801039bd:	e8 2b fe ff ff       	call   801037ed <v2p>
801039c2:	83 c4 10             	add    $0x10,%esp
801039c5:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
801039c7:	83 ec 0c             	sub    $0xc,%esp
801039ca:	ff 75 f0             	pushl  -0x10(%ebp)
801039cd:	e8 1b fe ff ff       	call   801037ed <v2p>
801039d2:	83 c4 10             	add    $0x10,%esp
801039d5:	89 c2                	mov    %eax,%edx
801039d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039da:	0f b6 00             	movzbl (%eax),%eax
801039dd:	0f b6 c0             	movzbl %al,%eax
801039e0:	83 ec 08             	sub    $0x8,%esp
801039e3:	52                   	push   %edx
801039e4:	50                   	push   %eax
801039e5:	e8 f8 f5 ff ff       	call   80102fe2 <lapicstartap>
801039ea:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801039ed:	90                   	nop
801039ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039f1:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801039f7:	85 c0                	test   %eax,%eax
801039f9:	74 f3                	je     801039ee <startothers+0xb7>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
801039fb:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103a02:	a1 60 2a 11 80       	mov    0x80112a60,%eax
80103a07:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103a0d:	05 80 24 11 80       	add    $0x80112480,%eax
80103a12:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103a15:	0f 87 58 ff ff ff    	ja     80103973 <startothers+0x3c>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103a1b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a1e:	c9                   	leave  
80103a1f:	c3                   	ret    

80103a20 <p2v>:
80103a20:	55                   	push   %ebp
80103a21:	89 e5                	mov    %esp,%ebp
80103a23:	8b 45 08             	mov    0x8(%ebp),%eax
80103a26:	05 00 00 00 80       	add    $0x80000000,%eax
80103a2b:	5d                   	pop    %ebp
80103a2c:	c3                   	ret    

80103a2d <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80103a2d:	55                   	push   %ebp
80103a2e:	89 e5                	mov    %esp,%ebp
80103a30:	83 ec 14             	sub    $0x14,%esp
80103a33:	8b 45 08             	mov    0x8(%ebp),%eax
80103a36:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103a3a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103a3e:	89 c2                	mov    %eax,%edx
80103a40:	ec                   	in     (%dx),%al
80103a41:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103a44:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103a48:	c9                   	leave  
80103a49:	c3                   	ret    

80103a4a <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103a4a:	55                   	push   %ebp
80103a4b:	89 e5                	mov    %esp,%ebp
80103a4d:	83 ec 08             	sub    $0x8,%esp
80103a50:	8b 55 08             	mov    0x8(%ebp),%edx
80103a53:	8b 45 0c             	mov    0xc(%ebp),%eax
80103a56:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103a5a:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103a5d:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103a61:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103a65:	ee                   	out    %al,(%dx)
}
80103a66:	c9                   	leave  
80103a67:	c3                   	ret    

80103a68 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103a68:	55                   	push   %ebp
80103a69:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103a6b:	a1 64 b6 10 80       	mov    0x8010b664,%eax
80103a70:	89 c2                	mov    %eax,%edx
80103a72:	b8 80 24 11 80       	mov    $0x80112480,%eax
80103a77:	29 c2                	sub    %eax,%edx
80103a79:	89 d0                	mov    %edx,%eax
80103a7b:	c1 f8 02             	sar    $0x2,%eax
80103a7e:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103a84:	5d                   	pop    %ebp
80103a85:	c3                   	ret    

80103a86 <sum>:

static uchar
sum(uchar *addr, int len)
{
80103a86:	55                   	push   %ebp
80103a87:	89 e5                	mov    %esp,%ebp
80103a89:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103a8c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103a93:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103a9a:	eb 15                	jmp    80103ab1 <sum+0x2b>
    sum += addr[i];
80103a9c:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103a9f:	8b 45 08             	mov    0x8(%ebp),%eax
80103aa2:	01 d0                	add    %edx,%eax
80103aa4:	0f b6 00             	movzbl (%eax),%eax
80103aa7:	0f b6 c0             	movzbl %al,%eax
80103aaa:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80103aad:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103ab1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103ab4:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103ab7:	7c e3                	jl     80103a9c <sum+0x16>
    sum += addr[i];
  return sum;
80103ab9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103abc:	c9                   	leave  
80103abd:	c3                   	ret    

80103abe <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103abe:	55                   	push   %ebp
80103abf:	89 e5                	mov    %esp,%ebp
80103ac1:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103ac4:	ff 75 08             	pushl  0x8(%ebp)
80103ac7:	e8 54 ff ff ff       	call   80103a20 <p2v>
80103acc:	83 c4 04             	add    $0x4,%esp
80103acf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103ad2:	8b 55 0c             	mov    0xc(%ebp),%edx
80103ad5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ad8:	01 d0                	add    %edx,%eax
80103ada:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103add:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ae0:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103ae3:	eb 36                	jmp    80103b1b <mpsearch1+0x5d>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103ae5:	83 ec 04             	sub    $0x4,%esp
80103ae8:	6a 04                	push   $0x4
80103aea:	68 64 87 10 80       	push   $0x80108764
80103aef:	ff 75 f4             	pushl  -0xc(%ebp)
80103af2:	e8 47 17 00 00       	call   8010523e <memcmp>
80103af7:	83 c4 10             	add    $0x10,%esp
80103afa:	85 c0                	test   %eax,%eax
80103afc:	75 19                	jne    80103b17 <mpsearch1+0x59>
80103afe:	83 ec 08             	sub    $0x8,%esp
80103b01:	6a 10                	push   $0x10
80103b03:	ff 75 f4             	pushl  -0xc(%ebp)
80103b06:	e8 7b ff ff ff       	call   80103a86 <sum>
80103b0b:	83 c4 10             	add    $0x10,%esp
80103b0e:	84 c0                	test   %al,%al
80103b10:	75 05                	jne    80103b17 <mpsearch1+0x59>
      return (struct mp*)p;
80103b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b15:	eb 11                	jmp    80103b28 <mpsearch1+0x6a>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103b17:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b1e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103b21:	72 c2                	jb     80103ae5 <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103b23:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103b28:	c9                   	leave  
80103b29:	c3                   	ret    

80103b2a <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103b2a:	55                   	push   %ebp
80103b2b:	89 e5                	mov    %esp,%ebp
80103b2d:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103b30:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b3a:	83 c0 0f             	add    $0xf,%eax
80103b3d:	0f b6 00             	movzbl (%eax),%eax
80103b40:	0f b6 c0             	movzbl %al,%eax
80103b43:	c1 e0 08             	shl    $0x8,%eax
80103b46:	89 c2                	mov    %eax,%edx
80103b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b4b:	83 c0 0e             	add    $0xe,%eax
80103b4e:	0f b6 00             	movzbl (%eax),%eax
80103b51:	0f b6 c0             	movzbl %al,%eax
80103b54:	09 d0                	or     %edx,%eax
80103b56:	c1 e0 04             	shl    $0x4,%eax
80103b59:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103b5c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103b60:	74 21                	je     80103b83 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103b62:	83 ec 08             	sub    $0x8,%esp
80103b65:	68 00 04 00 00       	push   $0x400
80103b6a:	ff 75 f0             	pushl  -0x10(%ebp)
80103b6d:	e8 4c ff ff ff       	call   80103abe <mpsearch1>
80103b72:	83 c4 10             	add    $0x10,%esp
80103b75:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103b78:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103b7c:	74 51                	je     80103bcf <mpsearch+0xa5>
      return mp;
80103b7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b81:	eb 61                	jmp    80103be4 <mpsearch+0xba>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b86:	83 c0 14             	add    $0x14,%eax
80103b89:	0f b6 00             	movzbl (%eax),%eax
80103b8c:	0f b6 c0             	movzbl %al,%eax
80103b8f:	c1 e0 08             	shl    $0x8,%eax
80103b92:	89 c2                	mov    %eax,%edx
80103b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b97:	83 c0 13             	add    $0x13,%eax
80103b9a:	0f b6 00             	movzbl (%eax),%eax
80103b9d:	0f b6 c0             	movzbl %al,%eax
80103ba0:	09 d0                	or     %edx,%eax
80103ba2:	c1 e0 0a             	shl    $0xa,%eax
80103ba5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103ba8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bab:	2d 00 04 00 00       	sub    $0x400,%eax
80103bb0:	83 ec 08             	sub    $0x8,%esp
80103bb3:	68 00 04 00 00       	push   $0x400
80103bb8:	50                   	push   %eax
80103bb9:	e8 00 ff ff ff       	call   80103abe <mpsearch1>
80103bbe:	83 c4 10             	add    $0x10,%esp
80103bc1:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103bc4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103bc8:	74 05                	je     80103bcf <mpsearch+0xa5>
      return mp;
80103bca:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103bcd:	eb 15                	jmp    80103be4 <mpsearch+0xba>
  }
  return mpsearch1(0xF0000, 0x10000);
80103bcf:	83 ec 08             	sub    $0x8,%esp
80103bd2:	68 00 00 01 00       	push   $0x10000
80103bd7:	68 00 00 0f 00       	push   $0xf0000
80103bdc:	e8 dd fe ff ff       	call   80103abe <mpsearch1>
80103be1:	83 c4 10             	add    $0x10,%esp
}
80103be4:	c9                   	leave  
80103be5:	c3                   	ret    

80103be6 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103be6:	55                   	push   %ebp
80103be7:	89 e5                	mov    %esp,%ebp
80103be9:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103bec:	e8 39 ff ff ff       	call   80103b2a <mpsearch>
80103bf1:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103bf4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103bf8:	74 0a                	je     80103c04 <mpconfig+0x1e>
80103bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bfd:	8b 40 04             	mov    0x4(%eax),%eax
80103c00:	85 c0                	test   %eax,%eax
80103c02:	75 0a                	jne    80103c0e <mpconfig+0x28>
    return 0;
80103c04:	b8 00 00 00 00       	mov    $0x0,%eax
80103c09:	e9 81 00 00 00       	jmp    80103c8f <mpconfig+0xa9>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103c0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c11:	8b 40 04             	mov    0x4(%eax),%eax
80103c14:	83 ec 0c             	sub    $0xc,%esp
80103c17:	50                   	push   %eax
80103c18:	e8 03 fe ff ff       	call   80103a20 <p2v>
80103c1d:	83 c4 10             	add    $0x10,%esp
80103c20:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103c23:	83 ec 04             	sub    $0x4,%esp
80103c26:	6a 04                	push   $0x4
80103c28:	68 69 87 10 80       	push   $0x80108769
80103c2d:	ff 75 f0             	pushl  -0x10(%ebp)
80103c30:	e8 09 16 00 00       	call   8010523e <memcmp>
80103c35:	83 c4 10             	add    $0x10,%esp
80103c38:	85 c0                	test   %eax,%eax
80103c3a:	74 07                	je     80103c43 <mpconfig+0x5d>
    return 0;
80103c3c:	b8 00 00 00 00       	mov    $0x0,%eax
80103c41:	eb 4c                	jmp    80103c8f <mpconfig+0xa9>
  if(conf->version != 1 && conf->version != 4)
80103c43:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c46:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103c4a:	3c 01                	cmp    $0x1,%al
80103c4c:	74 12                	je     80103c60 <mpconfig+0x7a>
80103c4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c51:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103c55:	3c 04                	cmp    $0x4,%al
80103c57:	74 07                	je     80103c60 <mpconfig+0x7a>
    return 0;
80103c59:	b8 00 00 00 00       	mov    $0x0,%eax
80103c5e:	eb 2f                	jmp    80103c8f <mpconfig+0xa9>
  if(sum((uchar*)conf, conf->length) != 0)
80103c60:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c63:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103c67:	0f b7 c0             	movzwl %ax,%eax
80103c6a:	83 ec 08             	sub    $0x8,%esp
80103c6d:	50                   	push   %eax
80103c6e:	ff 75 f0             	pushl  -0x10(%ebp)
80103c71:	e8 10 fe ff ff       	call   80103a86 <sum>
80103c76:	83 c4 10             	add    $0x10,%esp
80103c79:	84 c0                	test   %al,%al
80103c7b:	74 07                	je     80103c84 <mpconfig+0x9e>
    return 0;
80103c7d:	b8 00 00 00 00       	mov    $0x0,%eax
80103c82:	eb 0b                	jmp    80103c8f <mpconfig+0xa9>
  *pmp = mp;
80103c84:	8b 45 08             	mov    0x8(%ebp),%eax
80103c87:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103c8a:	89 10                	mov    %edx,(%eax)
  return conf;
80103c8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103c8f:	c9                   	leave  
80103c90:	c3                   	ret    

80103c91 <mpinit>:

void
mpinit(void)
{
80103c91:	55                   	push   %ebp
80103c92:	89 e5                	mov    %esp,%ebp
80103c94:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103c97:	c7 05 64 b6 10 80 80 	movl   $0x80112480,0x8010b664
80103c9e:	24 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103ca1:	83 ec 0c             	sub    $0xc,%esp
80103ca4:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103ca7:	50                   	push   %eax
80103ca8:	e8 39 ff ff ff       	call   80103be6 <mpconfig>
80103cad:	83 c4 10             	add    $0x10,%esp
80103cb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103cb3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103cb7:	75 05                	jne    80103cbe <mpinit+0x2d>
    return;
80103cb9:	e9 94 01 00 00       	jmp    80103e52 <mpinit+0x1c1>
  ismp = 1;
80103cbe:	c7 05 44 24 11 80 01 	movl   $0x1,0x80112444
80103cc5:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103cc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ccb:	8b 40 24             	mov    0x24(%eax),%eax
80103cce:	a3 1c 23 11 80       	mov    %eax,0x8011231c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103cd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cd6:	83 c0 2c             	add    $0x2c,%eax
80103cd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103cdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cdf:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103ce3:	0f b7 d0             	movzwl %ax,%edx
80103ce6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ce9:	01 d0                	add    %edx,%eax
80103ceb:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103cee:	e9 f2 00 00 00       	jmp    80103de5 <mpinit+0x154>
    switch(*p){
80103cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cf6:	0f b6 00             	movzbl (%eax),%eax
80103cf9:	0f b6 c0             	movzbl %al,%eax
80103cfc:	83 f8 04             	cmp    $0x4,%eax
80103cff:	0f 87 bc 00 00 00    	ja     80103dc1 <mpinit+0x130>
80103d05:	8b 04 85 ac 87 10 80 	mov    -0x7fef7854(,%eax,4),%eax
80103d0c:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103d0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d11:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103d14:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103d17:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103d1b:	0f b6 d0             	movzbl %al,%edx
80103d1e:	a1 60 2a 11 80       	mov    0x80112a60,%eax
80103d23:	39 c2                	cmp    %eax,%edx
80103d25:	74 2b                	je     80103d52 <mpinit+0xc1>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103d27:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103d2a:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103d2e:	0f b6 d0             	movzbl %al,%edx
80103d31:	a1 60 2a 11 80       	mov    0x80112a60,%eax
80103d36:	83 ec 04             	sub    $0x4,%esp
80103d39:	52                   	push   %edx
80103d3a:	50                   	push   %eax
80103d3b:	68 6e 87 10 80       	push   $0x8010876e
80103d40:	e8 7a c6 ff ff       	call   801003bf <cprintf>
80103d45:	83 c4 10             	add    $0x10,%esp
        ismp = 0;
80103d48:	c7 05 44 24 11 80 00 	movl   $0x0,0x80112444
80103d4f:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103d52:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103d55:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103d59:	0f b6 c0             	movzbl %al,%eax
80103d5c:	83 e0 02             	and    $0x2,%eax
80103d5f:	85 c0                	test   %eax,%eax
80103d61:	74 15                	je     80103d78 <mpinit+0xe7>
        bcpu = &cpus[ncpu];
80103d63:	a1 60 2a 11 80       	mov    0x80112a60,%eax
80103d68:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103d6e:	05 80 24 11 80       	add    $0x80112480,%eax
80103d73:	a3 64 b6 10 80       	mov    %eax,0x8010b664
      cpus[ncpu].id = ncpu;
80103d78:	a1 60 2a 11 80       	mov    0x80112a60,%eax
80103d7d:	8b 15 60 2a 11 80    	mov    0x80112a60,%edx
80103d83:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103d89:	05 80 24 11 80       	add    $0x80112480,%eax
80103d8e:	88 10                	mov    %dl,(%eax)
      ncpu++;
80103d90:	a1 60 2a 11 80       	mov    0x80112a60,%eax
80103d95:	83 c0 01             	add    $0x1,%eax
80103d98:	a3 60 2a 11 80       	mov    %eax,0x80112a60
      p += sizeof(struct mpproc);
80103d9d:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103da1:	eb 42                	jmp    80103de5 <mpinit+0x154>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103da3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103da6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103da9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103dac:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103db0:	a2 40 24 11 80       	mov    %al,0x80112440
      p += sizeof(struct mpioapic);
80103db5:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103db9:	eb 2a                	jmp    80103de5 <mpinit+0x154>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103dbb:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103dbf:	eb 24                	jmp    80103de5 <mpinit+0x154>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103dc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103dc4:	0f b6 00             	movzbl (%eax),%eax
80103dc7:	0f b6 c0             	movzbl %al,%eax
80103dca:	83 ec 08             	sub    $0x8,%esp
80103dcd:	50                   	push   %eax
80103dce:	68 8c 87 10 80       	push   $0x8010878c
80103dd3:	e8 e7 c5 ff ff       	call   801003bf <cprintf>
80103dd8:	83 c4 10             	add    $0x10,%esp
      ismp = 0;
80103ddb:	c7 05 44 24 11 80 00 	movl   $0x0,0x80112444
80103de2:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103de5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103de8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103deb:	0f 82 02 ff ff ff    	jb     80103cf3 <mpinit+0x62>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80103df1:	a1 44 24 11 80       	mov    0x80112444,%eax
80103df6:	85 c0                	test   %eax,%eax
80103df8:	75 1d                	jne    80103e17 <mpinit+0x186>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103dfa:	c7 05 60 2a 11 80 01 	movl   $0x1,0x80112a60
80103e01:	00 00 00 
    lapic = 0;
80103e04:	c7 05 1c 23 11 80 00 	movl   $0x0,0x8011231c
80103e0b:	00 00 00 
    ioapicid = 0;
80103e0e:	c6 05 40 24 11 80 00 	movb   $0x0,0x80112440
    return;
80103e15:	eb 3b                	jmp    80103e52 <mpinit+0x1c1>
  }

  if(mp->imcrp){
80103e17:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103e1a:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103e1e:	84 c0                	test   %al,%al
80103e20:	74 30                	je     80103e52 <mpinit+0x1c1>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103e22:	83 ec 08             	sub    $0x8,%esp
80103e25:	6a 70                	push   $0x70
80103e27:	6a 22                	push   $0x22
80103e29:	e8 1c fc ff ff       	call   80103a4a <outb>
80103e2e:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103e31:	83 ec 0c             	sub    $0xc,%esp
80103e34:	6a 23                	push   $0x23
80103e36:	e8 f2 fb ff ff       	call   80103a2d <inb>
80103e3b:	83 c4 10             	add    $0x10,%esp
80103e3e:	83 c8 01             	or     $0x1,%eax
80103e41:	0f b6 c0             	movzbl %al,%eax
80103e44:	83 ec 08             	sub    $0x8,%esp
80103e47:	50                   	push   %eax
80103e48:	6a 23                	push   $0x23
80103e4a:	e8 fb fb ff ff       	call   80103a4a <outb>
80103e4f:	83 c4 10             	add    $0x10,%esp
  }
}
80103e52:	c9                   	leave  
80103e53:	c3                   	ret    

80103e54 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103e54:	55                   	push   %ebp
80103e55:	89 e5                	mov    %esp,%ebp
80103e57:	83 ec 08             	sub    $0x8,%esp
80103e5a:	8b 55 08             	mov    0x8(%ebp),%edx
80103e5d:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e60:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103e64:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103e67:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103e6b:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103e6f:	ee                   	out    %al,(%dx)
}
80103e70:	c9                   	leave  
80103e71:	c3                   	ret    

80103e72 <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103e72:	55                   	push   %ebp
80103e73:	89 e5                	mov    %esp,%ebp
80103e75:	83 ec 04             	sub    $0x4,%esp
80103e78:	8b 45 08             	mov    0x8(%ebp),%eax
80103e7b:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103e7f:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103e83:	66 a3 00 b0 10 80    	mov    %ax,0x8010b000
  outb(IO_PIC1+1, mask);
80103e89:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103e8d:	0f b6 c0             	movzbl %al,%eax
80103e90:	50                   	push   %eax
80103e91:	6a 21                	push   $0x21
80103e93:	e8 bc ff ff ff       	call   80103e54 <outb>
80103e98:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, mask >> 8);
80103e9b:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103e9f:	66 c1 e8 08          	shr    $0x8,%ax
80103ea3:	0f b6 c0             	movzbl %al,%eax
80103ea6:	50                   	push   %eax
80103ea7:	68 a1 00 00 00       	push   $0xa1
80103eac:	e8 a3 ff ff ff       	call   80103e54 <outb>
80103eb1:	83 c4 08             	add    $0x8,%esp
}
80103eb4:	c9                   	leave  
80103eb5:	c3                   	ret    

80103eb6 <picenable>:

void
picenable(int irq)
{
80103eb6:	55                   	push   %ebp
80103eb7:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
80103eb9:	8b 45 08             	mov    0x8(%ebp),%eax
80103ebc:	ba 01 00 00 00       	mov    $0x1,%edx
80103ec1:	89 c1                	mov    %eax,%ecx
80103ec3:	d3 e2                	shl    %cl,%edx
80103ec5:	89 d0                	mov    %edx,%eax
80103ec7:	f7 d0                	not    %eax
80103ec9:	89 c2                	mov    %eax,%edx
80103ecb:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103ed2:	21 d0                	and    %edx,%eax
80103ed4:	0f b7 c0             	movzwl %ax,%eax
80103ed7:	50                   	push   %eax
80103ed8:	e8 95 ff ff ff       	call   80103e72 <picsetmask>
80103edd:	83 c4 04             	add    $0x4,%esp
}
80103ee0:	c9                   	leave  
80103ee1:	c3                   	ret    

80103ee2 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103ee2:	55                   	push   %ebp
80103ee3:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103ee5:	68 ff 00 00 00       	push   $0xff
80103eea:	6a 21                	push   $0x21
80103eec:	e8 63 ff ff ff       	call   80103e54 <outb>
80103ef1:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
80103ef4:	68 ff 00 00 00       	push   $0xff
80103ef9:	68 a1 00 00 00       	push   $0xa1
80103efe:	e8 51 ff ff ff       	call   80103e54 <outb>
80103f03:	83 c4 08             	add    $0x8,%esp

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103f06:	6a 11                	push   $0x11
80103f08:	6a 20                	push   $0x20
80103f0a:	e8 45 ff ff ff       	call   80103e54 <outb>
80103f0f:	83 c4 08             	add    $0x8,%esp

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103f12:	6a 20                	push   $0x20
80103f14:	6a 21                	push   $0x21
80103f16:	e8 39 ff ff ff       	call   80103e54 <outb>
80103f1b:	83 c4 08             	add    $0x8,%esp

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103f1e:	6a 04                	push   $0x4
80103f20:	6a 21                	push   $0x21
80103f22:	e8 2d ff ff ff       	call   80103e54 <outb>
80103f27:	83 c4 08             	add    $0x8,%esp
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103f2a:	6a 03                	push   $0x3
80103f2c:	6a 21                	push   $0x21
80103f2e:	e8 21 ff ff ff       	call   80103e54 <outb>
80103f33:	83 c4 08             	add    $0x8,%esp

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103f36:	6a 11                	push   $0x11
80103f38:	68 a0 00 00 00       	push   $0xa0
80103f3d:	e8 12 ff ff ff       	call   80103e54 <outb>
80103f42:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103f45:	6a 28                	push   $0x28
80103f47:	68 a1 00 00 00       	push   $0xa1
80103f4c:	e8 03 ff ff ff       	call   80103e54 <outb>
80103f51:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103f54:	6a 02                	push   $0x2
80103f56:	68 a1 00 00 00       	push   $0xa1
80103f5b:	e8 f4 fe ff ff       	call   80103e54 <outb>
80103f60:	83 c4 08             	add    $0x8,%esp
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103f63:	6a 03                	push   $0x3
80103f65:	68 a1 00 00 00       	push   $0xa1
80103f6a:	e8 e5 fe ff ff       	call   80103e54 <outb>
80103f6f:	83 c4 08             	add    $0x8,%esp

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103f72:	6a 68                	push   $0x68
80103f74:	6a 20                	push   $0x20
80103f76:	e8 d9 fe ff ff       	call   80103e54 <outb>
80103f7b:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC1, 0x0a);             // read IRR by default
80103f7e:	6a 0a                	push   $0xa
80103f80:	6a 20                	push   $0x20
80103f82:	e8 cd fe ff ff       	call   80103e54 <outb>
80103f87:	83 c4 08             	add    $0x8,%esp

  outb(IO_PIC2, 0x68);             // OCW3
80103f8a:	6a 68                	push   $0x68
80103f8c:	68 a0 00 00 00       	push   $0xa0
80103f91:	e8 be fe ff ff       	call   80103e54 <outb>
80103f96:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2, 0x0a);             // OCW3
80103f99:	6a 0a                	push   $0xa
80103f9b:	68 a0 00 00 00       	push   $0xa0
80103fa0:	e8 af fe ff ff       	call   80103e54 <outb>
80103fa5:	83 c4 08             	add    $0x8,%esp

  if(irqmask != 0xFFFF)
80103fa8:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103faf:	66 83 f8 ff          	cmp    $0xffff,%ax
80103fb3:	74 13                	je     80103fc8 <picinit+0xe6>
    picsetmask(irqmask);
80103fb5:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103fbc:	0f b7 c0             	movzwl %ax,%eax
80103fbf:	50                   	push   %eax
80103fc0:	e8 ad fe ff ff       	call   80103e72 <picsetmask>
80103fc5:	83 c4 04             	add    $0x4,%esp
}
80103fc8:	c9                   	leave  
80103fc9:	c3                   	ret    

80103fca <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103fca:	55                   	push   %ebp
80103fcb:	89 e5                	mov    %esp,%ebp
80103fcd:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
80103fd0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103fd7:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fda:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103fe0:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fe3:	8b 10                	mov    (%eax),%edx
80103fe5:	8b 45 08             	mov    0x8(%ebp),%eax
80103fe8:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103fea:	e8 61 cf ff ff       	call   80100f50 <filealloc>
80103fef:	89 c2                	mov    %eax,%edx
80103ff1:	8b 45 08             	mov    0x8(%ebp),%eax
80103ff4:	89 10                	mov    %edx,(%eax)
80103ff6:	8b 45 08             	mov    0x8(%ebp),%eax
80103ff9:	8b 00                	mov    (%eax),%eax
80103ffb:	85 c0                	test   %eax,%eax
80103ffd:	0f 84 cb 00 00 00    	je     801040ce <pipealloc+0x104>
80104003:	e8 48 cf ff ff       	call   80100f50 <filealloc>
80104008:	89 c2                	mov    %eax,%edx
8010400a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010400d:	89 10                	mov    %edx,(%eax)
8010400f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104012:	8b 00                	mov    (%eax),%eax
80104014:	85 c0                	test   %eax,%eax
80104016:	0f 84 b2 00 00 00    	je     801040ce <pipealloc+0x104>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010401c:	e8 e8 eb ff ff       	call   80102c09 <kalloc>
80104021:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104024:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104028:	75 05                	jne    8010402f <pipealloc+0x65>
    goto bad;
8010402a:	e9 9f 00 00 00       	jmp    801040ce <pipealloc+0x104>
  p->readopen = 1;
8010402f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104032:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80104039:	00 00 00 
  p->writeopen = 1;
8010403c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010403f:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80104046:	00 00 00 
  p->nwrite = 0;
80104049:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010404c:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80104053:	00 00 00 
  p->nread = 0;
80104056:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104059:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80104060:	00 00 00 
  initlock(&p->lock, "pipe");
80104063:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104066:	83 ec 08             	sub    $0x8,%esp
80104069:	68 c0 87 10 80       	push   $0x801087c0
8010406e:	50                   	push   %eax
8010406f:	e8 e6 0e 00 00       	call   80104f5a <initlock>
80104074:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80104077:	8b 45 08             	mov    0x8(%ebp),%eax
8010407a:	8b 00                	mov    (%eax),%eax
8010407c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80104082:	8b 45 08             	mov    0x8(%ebp),%eax
80104085:	8b 00                	mov    (%eax),%eax
80104087:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010408b:	8b 45 08             	mov    0x8(%ebp),%eax
8010408e:	8b 00                	mov    (%eax),%eax
80104090:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80104094:	8b 45 08             	mov    0x8(%ebp),%eax
80104097:	8b 00                	mov    (%eax),%eax
80104099:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010409c:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010409f:	8b 45 0c             	mov    0xc(%ebp),%eax
801040a2:	8b 00                	mov    (%eax),%eax
801040a4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801040aa:	8b 45 0c             	mov    0xc(%ebp),%eax
801040ad:	8b 00                	mov    (%eax),%eax
801040af:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801040b3:	8b 45 0c             	mov    0xc(%ebp),%eax
801040b6:	8b 00                	mov    (%eax),%eax
801040b8:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801040bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801040bf:	8b 00                	mov    (%eax),%eax
801040c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801040c4:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
801040c7:	b8 00 00 00 00       	mov    $0x0,%eax
801040cc:	eb 4d                	jmp    8010411b <pipealloc+0x151>

//PAGEBREAK: 20
 bad:
  if(p)
801040ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801040d2:	74 0e                	je     801040e2 <pipealloc+0x118>
    kfree((char*)p);
801040d4:	83 ec 0c             	sub    $0xc,%esp
801040d7:	ff 75 f4             	pushl  -0xc(%ebp)
801040da:	e8 8e ea ff ff       	call   80102b6d <kfree>
801040df:	83 c4 10             	add    $0x10,%esp
  if(*f0)
801040e2:	8b 45 08             	mov    0x8(%ebp),%eax
801040e5:	8b 00                	mov    (%eax),%eax
801040e7:	85 c0                	test   %eax,%eax
801040e9:	74 11                	je     801040fc <pipealloc+0x132>
    fileclose(*f0);
801040eb:	8b 45 08             	mov    0x8(%ebp),%eax
801040ee:	8b 00                	mov    (%eax),%eax
801040f0:	83 ec 0c             	sub    $0xc,%esp
801040f3:	50                   	push   %eax
801040f4:	e8 14 cf ff ff       	call   8010100d <fileclose>
801040f9:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801040fc:	8b 45 0c             	mov    0xc(%ebp),%eax
801040ff:	8b 00                	mov    (%eax),%eax
80104101:	85 c0                	test   %eax,%eax
80104103:	74 11                	je     80104116 <pipealloc+0x14c>
    fileclose(*f1);
80104105:	8b 45 0c             	mov    0xc(%ebp),%eax
80104108:	8b 00                	mov    (%eax),%eax
8010410a:	83 ec 0c             	sub    $0xc,%esp
8010410d:	50                   	push   %eax
8010410e:	e8 fa ce ff ff       	call   8010100d <fileclose>
80104113:	83 c4 10             	add    $0x10,%esp
  return -1;
80104116:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010411b:	c9                   	leave  
8010411c:	c3                   	ret    

8010411d <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
8010411d:	55                   	push   %ebp
8010411e:	89 e5                	mov    %esp,%ebp
80104120:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
80104123:	8b 45 08             	mov    0x8(%ebp),%eax
80104126:	83 ec 0c             	sub    $0xc,%esp
80104129:	50                   	push   %eax
8010412a:	e8 4c 0e 00 00       	call   80104f7b <acquire>
8010412f:	83 c4 10             	add    $0x10,%esp
  if(writable){
80104132:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104136:	74 23                	je     8010415b <pipeclose+0x3e>
    p->writeopen = 0;
80104138:	8b 45 08             	mov    0x8(%ebp),%eax
8010413b:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80104142:	00 00 00 
    wakeup(&p->nread);
80104145:	8b 45 08             	mov    0x8(%ebp),%eax
80104148:	05 34 02 00 00       	add    $0x234,%eax
8010414d:	83 ec 0c             	sub    $0xc,%esp
80104150:	50                   	push   %eax
80104151:	e8 1e 0c 00 00       	call   80104d74 <wakeup>
80104156:	83 c4 10             	add    $0x10,%esp
80104159:	eb 21                	jmp    8010417c <pipeclose+0x5f>
  } else {
    p->readopen = 0;
8010415b:	8b 45 08             	mov    0x8(%ebp),%eax
8010415e:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80104165:	00 00 00 
    wakeup(&p->nwrite);
80104168:	8b 45 08             	mov    0x8(%ebp),%eax
8010416b:	05 38 02 00 00       	add    $0x238,%eax
80104170:	83 ec 0c             	sub    $0xc,%esp
80104173:	50                   	push   %eax
80104174:	e8 fb 0b 00 00       	call   80104d74 <wakeup>
80104179:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010417c:	8b 45 08             	mov    0x8(%ebp),%eax
8010417f:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104185:	85 c0                	test   %eax,%eax
80104187:	75 2c                	jne    801041b5 <pipeclose+0x98>
80104189:	8b 45 08             	mov    0x8(%ebp),%eax
8010418c:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104192:	85 c0                	test   %eax,%eax
80104194:	75 1f                	jne    801041b5 <pipeclose+0x98>
    release(&p->lock);
80104196:	8b 45 08             	mov    0x8(%ebp),%eax
80104199:	83 ec 0c             	sub    $0xc,%esp
8010419c:	50                   	push   %eax
8010419d:	e8 3f 0e 00 00       	call   80104fe1 <release>
801041a2:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
801041a5:	83 ec 0c             	sub    $0xc,%esp
801041a8:	ff 75 08             	pushl  0x8(%ebp)
801041ab:	e8 bd e9 ff ff       	call   80102b6d <kfree>
801041b0:	83 c4 10             	add    $0x10,%esp
801041b3:	eb 0f                	jmp    801041c4 <pipeclose+0xa7>
  } else
    release(&p->lock);
801041b5:	8b 45 08             	mov    0x8(%ebp),%eax
801041b8:	83 ec 0c             	sub    $0xc,%esp
801041bb:	50                   	push   %eax
801041bc:	e8 20 0e 00 00       	call   80104fe1 <release>
801041c1:	83 c4 10             	add    $0x10,%esp
}
801041c4:	c9                   	leave  
801041c5:	c3                   	ret    

801041c6 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801041c6:	55                   	push   %ebp
801041c7:	89 e5                	mov    %esp,%ebp
801041c9:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
801041cc:	8b 45 08             	mov    0x8(%ebp),%eax
801041cf:	83 ec 0c             	sub    $0xc,%esp
801041d2:	50                   	push   %eax
801041d3:	e8 a3 0d 00 00       	call   80104f7b <acquire>
801041d8:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
801041db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801041e2:	e9 af 00 00 00       	jmp    80104296 <pipewrite+0xd0>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801041e7:	eb 60                	jmp    80104249 <pipewrite+0x83>
      if(p->readopen == 0 || proc->killed){
801041e9:	8b 45 08             	mov    0x8(%ebp),%eax
801041ec:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801041f2:	85 c0                	test   %eax,%eax
801041f4:	74 0d                	je     80104203 <pipewrite+0x3d>
801041f6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801041fc:	8b 40 24             	mov    0x24(%eax),%eax
801041ff:	85 c0                	test   %eax,%eax
80104201:	74 19                	je     8010421c <pipewrite+0x56>
        release(&p->lock);
80104203:	8b 45 08             	mov    0x8(%ebp),%eax
80104206:	83 ec 0c             	sub    $0xc,%esp
80104209:	50                   	push   %eax
8010420a:	e8 d2 0d 00 00       	call   80104fe1 <release>
8010420f:	83 c4 10             	add    $0x10,%esp
        return -1;
80104212:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104217:	e9 ac 00 00 00       	jmp    801042c8 <pipewrite+0x102>
      }
      wakeup(&p->nread);
8010421c:	8b 45 08             	mov    0x8(%ebp),%eax
8010421f:	05 34 02 00 00       	add    $0x234,%eax
80104224:	83 ec 0c             	sub    $0xc,%esp
80104227:	50                   	push   %eax
80104228:	e8 47 0b 00 00       	call   80104d74 <wakeup>
8010422d:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80104230:	8b 45 08             	mov    0x8(%ebp),%eax
80104233:	8b 55 08             	mov    0x8(%ebp),%edx
80104236:	81 c2 38 02 00 00    	add    $0x238,%edx
8010423c:	83 ec 08             	sub    $0x8,%esp
8010423f:	50                   	push   %eax
80104240:	52                   	push   %edx
80104241:	e8 45 0a 00 00       	call   80104c8b <sleep>
80104246:	83 c4 10             	add    $0x10,%esp
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104249:	8b 45 08             	mov    0x8(%ebp),%eax
8010424c:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80104252:	8b 45 08             	mov    0x8(%ebp),%eax
80104255:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
8010425b:	05 00 02 00 00       	add    $0x200,%eax
80104260:	39 c2                	cmp    %eax,%edx
80104262:	74 85                	je     801041e9 <pipewrite+0x23>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80104264:	8b 45 08             	mov    0x8(%ebp),%eax
80104267:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010426d:	8d 48 01             	lea    0x1(%eax),%ecx
80104270:	8b 55 08             	mov    0x8(%ebp),%edx
80104273:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80104279:	25 ff 01 00 00       	and    $0x1ff,%eax
8010427e:	89 c1                	mov    %eax,%ecx
80104280:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104283:	8b 45 0c             	mov    0xc(%ebp),%eax
80104286:	01 d0                	add    %edx,%eax
80104288:	0f b6 10             	movzbl (%eax),%edx
8010428b:	8b 45 08             	mov    0x8(%ebp),%eax
8010428e:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80104292:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104296:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104299:	3b 45 10             	cmp    0x10(%ebp),%eax
8010429c:	0f 8c 45 ff ff ff    	jl     801041e7 <pipewrite+0x21>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801042a2:	8b 45 08             	mov    0x8(%ebp),%eax
801042a5:	05 34 02 00 00       	add    $0x234,%eax
801042aa:	83 ec 0c             	sub    $0xc,%esp
801042ad:	50                   	push   %eax
801042ae:	e8 c1 0a 00 00       	call   80104d74 <wakeup>
801042b3:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801042b6:	8b 45 08             	mov    0x8(%ebp),%eax
801042b9:	83 ec 0c             	sub    $0xc,%esp
801042bc:	50                   	push   %eax
801042bd:	e8 1f 0d 00 00       	call   80104fe1 <release>
801042c2:	83 c4 10             	add    $0x10,%esp
  return n;
801042c5:	8b 45 10             	mov    0x10(%ebp),%eax
}
801042c8:	c9                   	leave  
801042c9:	c3                   	ret    

801042ca <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801042ca:	55                   	push   %ebp
801042cb:	89 e5                	mov    %esp,%ebp
801042cd:	53                   	push   %ebx
801042ce:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
801042d1:	8b 45 08             	mov    0x8(%ebp),%eax
801042d4:	83 ec 0c             	sub    $0xc,%esp
801042d7:	50                   	push   %eax
801042d8:	e8 9e 0c 00 00       	call   80104f7b <acquire>
801042dd:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801042e0:	eb 3f                	jmp    80104321 <piperead+0x57>
    if(proc->killed){
801042e2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042e8:	8b 40 24             	mov    0x24(%eax),%eax
801042eb:	85 c0                	test   %eax,%eax
801042ed:	74 19                	je     80104308 <piperead+0x3e>
      release(&p->lock);
801042ef:	8b 45 08             	mov    0x8(%ebp),%eax
801042f2:	83 ec 0c             	sub    $0xc,%esp
801042f5:	50                   	push   %eax
801042f6:	e8 e6 0c 00 00       	call   80104fe1 <release>
801042fb:	83 c4 10             	add    $0x10,%esp
      return -1;
801042fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104303:	e9 be 00 00 00       	jmp    801043c6 <piperead+0xfc>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80104308:	8b 45 08             	mov    0x8(%ebp),%eax
8010430b:	8b 55 08             	mov    0x8(%ebp),%edx
8010430e:	81 c2 34 02 00 00    	add    $0x234,%edx
80104314:	83 ec 08             	sub    $0x8,%esp
80104317:	50                   	push   %eax
80104318:	52                   	push   %edx
80104319:	e8 6d 09 00 00       	call   80104c8b <sleep>
8010431e:	83 c4 10             	add    $0x10,%esp
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104321:	8b 45 08             	mov    0x8(%ebp),%eax
80104324:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
8010432a:	8b 45 08             	mov    0x8(%ebp),%eax
8010432d:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104333:	39 c2                	cmp    %eax,%edx
80104335:	75 0d                	jne    80104344 <piperead+0x7a>
80104337:	8b 45 08             	mov    0x8(%ebp),%eax
8010433a:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104340:	85 c0                	test   %eax,%eax
80104342:	75 9e                	jne    801042e2 <piperead+0x18>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104344:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010434b:	eb 4b                	jmp    80104398 <piperead+0xce>
    if(p->nread == p->nwrite)
8010434d:	8b 45 08             	mov    0x8(%ebp),%eax
80104350:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104356:	8b 45 08             	mov    0x8(%ebp),%eax
80104359:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010435f:	39 c2                	cmp    %eax,%edx
80104361:	75 02                	jne    80104365 <piperead+0x9b>
      break;
80104363:	eb 3b                	jmp    801043a0 <piperead+0xd6>
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104365:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104368:	8b 45 0c             	mov    0xc(%ebp),%eax
8010436b:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
8010436e:	8b 45 08             	mov    0x8(%ebp),%eax
80104371:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104377:	8d 48 01             	lea    0x1(%eax),%ecx
8010437a:	8b 55 08             	mov    0x8(%ebp),%edx
8010437d:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
80104383:	25 ff 01 00 00       	and    $0x1ff,%eax
80104388:	89 c2                	mov    %eax,%edx
8010438a:	8b 45 08             	mov    0x8(%ebp),%eax
8010438d:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
80104392:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104394:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104398:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010439b:	3b 45 10             	cmp    0x10(%ebp),%eax
8010439e:	7c ad                	jl     8010434d <piperead+0x83>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801043a0:	8b 45 08             	mov    0x8(%ebp),%eax
801043a3:	05 38 02 00 00       	add    $0x238,%eax
801043a8:	83 ec 0c             	sub    $0xc,%esp
801043ab:	50                   	push   %eax
801043ac:	e8 c3 09 00 00       	call   80104d74 <wakeup>
801043b1:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801043b4:	8b 45 08             	mov    0x8(%ebp),%eax
801043b7:	83 ec 0c             	sub    $0xc,%esp
801043ba:	50                   	push   %eax
801043bb:	e8 21 0c 00 00       	call   80104fe1 <release>
801043c0:	83 c4 10             	add    $0x10,%esp
  return i;
801043c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801043c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043c9:	c9                   	leave  
801043ca:	c3                   	ret    

801043cb <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801043cb:	55                   	push   %ebp
801043cc:	89 e5                	mov    %esp,%ebp
801043ce:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801043d1:	9c                   	pushf  
801043d2:	58                   	pop    %eax
801043d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801043d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801043d9:	c9                   	leave  
801043da:	c3                   	ret    

801043db <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
801043db:	55                   	push   %ebp
801043dc:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801043de:	fb                   	sti    
}
801043df:	5d                   	pop    %ebp
801043e0:	c3                   	ret    

801043e1 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
801043e1:	55                   	push   %ebp
801043e2:	89 e5                	mov    %esp,%ebp
801043e4:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
801043e7:	83 ec 08             	sub    $0x8,%esp
801043ea:	68 c5 87 10 80       	push   $0x801087c5
801043ef:	68 80 2a 11 80       	push   $0x80112a80
801043f4:	e8 61 0b 00 00       	call   80104f5a <initlock>
801043f9:	83 c4 10             	add    $0x10,%esp
}
801043fc:	c9                   	leave  
801043fd:	c3                   	ret    

801043fe <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801043fe:	55                   	push   %ebp
801043ff:	89 e5                	mov    %esp,%ebp
80104401:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80104404:	83 ec 0c             	sub    $0xc,%esp
80104407:	68 80 2a 11 80       	push   $0x80112a80
8010440c:	e8 6a 0b 00 00       	call   80104f7b <acquire>
80104411:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104414:	c7 45 f4 b4 2a 11 80 	movl   $0x80112ab4,-0xc(%ebp)
8010441b:	eb 56                	jmp    80104473 <allocproc+0x75>
    if(p->state == UNUSED)
8010441d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104420:	8b 40 0c             	mov    0xc(%eax),%eax
80104423:	85 c0                	test   %eax,%eax
80104425:	75 48                	jne    8010446f <allocproc+0x71>
      goto found;
80104427:	90                   	nop
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80104428:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010442b:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
80104432:	a1 04 b0 10 80       	mov    0x8010b004,%eax
80104437:	8d 50 01             	lea    0x1(%eax),%edx
8010443a:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
80104440:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104443:	89 42 10             	mov    %eax,0x10(%edx)
  release(&ptable.lock);
80104446:	83 ec 0c             	sub    $0xc,%esp
80104449:	68 80 2a 11 80       	push   $0x80112a80
8010444e:	e8 8e 0b 00 00       	call   80104fe1 <release>
80104453:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104456:	e8 ae e7 ff ff       	call   80102c09 <kalloc>
8010445b:	89 c2                	mov    %eax,%edx
8010445d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104460:	89 50 08             	mov    %edx,0x8(%eax)
80104463:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104466:	8b 40 08             	mov    0x8(%eax),%eax
80104469:	85 c0                	test   %eax,%eax
8010446b:	75 37                	jne    801044a4 <allocproc+0xa6>
8010446d:	eb 24                	jmp    80104493 <allocproc+0x95>
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010446f:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104473:	81 7d f4 b4 49 11 80 	cmpl   $0x801149b4,-0xc(%ebp)
8010447a:	72 a1                	jb     8010441d <allocproc+0x1f>
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
8010447c:	83 ec 0c             	sub    $0xc,%esp
8010447f:	68 80 2a 11 80       	push   $0x80112a80
80104484:	e8 58 0b 00 00       	call   80104fe1 <release>
80104489:	83 c4 10             	add    $0x10,%esp
  return 0;
8010448c:	b8 00 00 00 00       	mov    $0x0,%eax
80104491:	eb 6e                	jmp    80104501 <allocproc+0x103>
  p->pid = nextpid++;
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
80104493:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104496:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
8010449d:	b8 00 00 00 00       	mov    $0x0,%eax
801044a2:	eb 5d                	jmp    80104501 <allocproc+0x103>
  }
  sp = p->kstack + KSTACKSIZE;
801044a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044a7:	8b 40 08             	mov    0x8(%eax),%eax
801044aa:	05 00 10 00 00       	add    $0x1000,%eax
801044af:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801044b2:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
801044b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044b9:	8b 55 f0             	mov    -0x10(%ebp),%edx
801044bc:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
801044bf:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
801044c3:	ba b3 65 10 80       	mov    $0x801065b3,%edx
801044c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801044cb:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
801044cd:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
801044d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
801044d7:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
801044da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044dd:	8b 40 1c             	mov    0x1c(%eax),%eax
801044e0:	83 ec 04             	sub    $0x4,%esp
801044e3:	6a 14                	push   $0x14
801044e5:	6a 00                	push   $0x0
801044e7:	50                   	push   %eax
801044e8:	e8 ea 0c 00 00       	call   801051d7 <memset>
801044ed:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801044f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044f3:	8b 40 1c             	mov    0x1c(%eax),%eax
801044f6:	ba 46 4c 10 80       	mov    $0x80104c46,%edx
801044fb:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
801044fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104501:	c9                   	leave  
80104502:	c3                   	ret    

80104503 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80104503:	55                   	push   %ebp
80104504:	89 e5                	mov    %esp,%ebp
80104506:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
80104509:	e8 f0 fe ff ff       	call   801043fe <allocproc>
8010450e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
80104511:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104514:	a3 68 b6 10 80       	mov    %eax,0x8010b668
  if((p->pgdir = setupkvm()) == 0)
80104519:	e8 4e 37 00 00       	call   80107c6c <setupkvm>
8010451e:	89 c2                	mov    %eax,%edx
80104520:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104523:	89 50 04             	mov    %edx,0x4(%eax)
80104526:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104529:	8b 40 04             	mov    0x4(%eax),%eax
8010452c:	85 c0                	test   %eax,%eax
8010452e:	75 0d                	jne    8010453d <userinit+0x3a>
    panic("userinit: out of memory?");
80104530:	83 ec 0c             	sub    $0xc,%esp
80104533:	68 cc 87 10 80       	push   $0x801087cc
80104538:	e8 1f c0 ff ff       	call   8010055c <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
8010453d:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104542:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104545:	8b 40 04             	mov    0x4(%eax),%eax
80104548:	83 ec 04             	sub    $0x4,%esp
8010454b:	52                   	push   %edx
8010454c:	68 00 b5 10 80       	push   $0x8010b500
80104551:	50                   	push   %eax
80104552:	e8 6c 39 00 00       	call   80107ec3 <inituvm>
80104557:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
8010455a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010455d:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
80104563:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104566:	8b 40 18             	mov    0x18(%eax),%eax
80104569:	83 ec 04             	sub    $0x4,%esp
8010456c:	6a 4c                	push   $0x4c
8010456e:	6a 00                	push   $0x0
80104570:	50                   	push   %eax
80104571:	e8 61 0c 00 00       	call   801051d7 <memset>
80104576:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104579:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010457c:	8b 40 18             	mov    0x18(%eax),%eax
8010457f:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104585:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104588:	8b 40 18             	mov    0x18(%eax),%eax
8010458b:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104591:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104594:	8b 40 18             	mov    0x18(%eax),%eax
80104597:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010459a:	8b 52 18             	mov    0x18(%edx),%edx
8010459d:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801045a1:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801045a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045a8:	8b 40 18             	mov    0x18(%eax),%eax
801045ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045ae:	8b 52 18             	mov    0x18(%edx),%edx
801045b1:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801045b5:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801045b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045bc:	8b 40 18             	mov    0x18(%eax),%eax
801045bf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801045c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045c9:	8b 40 18             	mov    0x18(%eax),%eax
801045cc:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801045d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045d6:	8b 40 18             	mov    0x18(%eax),%eax
801045d9:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
801045e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045e3:	83 c0 6c             	add    $0x6c,%eax
801045e6:	83 ec 04             	sub    $0x4,%esp
801045e9:	6a 10                	push   $0x10
801045eb:	68 e5 87 10 80       	push   $0x801087e5
801045f0:	50                   	push   %eax
801045f1:	e8 e6 0d 00 00       	call   801053dc <safestrcpy>
801045f6:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
801045f9:	83 ec 0c             	sub    $0xc,%esp
801045fc:	68 ee 87 10 80       	push   $0x801087ee
80104601:	e8 d3 de ff ff       	call   801024d9 <namei>
80104606:	83 c4 10             	add    $0x10,%esp
80104609:	89 c2                	mov    %eax,%edx
8010460b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010460e:	89 50 68             	mov    %edx,0x68(%eax)

  p->state = RUNNABLE;
80104611:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104614:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
}
8010461b:	c9                   	leave  
8010461c:	c3                   	ret    

8010461d <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
8010461d:	55                   	push   %ebp
8010461e:	89 e5                	mov    %esp,%ebp
80104620:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  
  sz = proc->sz;
80104623:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104629:	8b 00                	mov    (%eax),%eax
8010462b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
8010462e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104632:	7e 31                	jle    80104665 <growproc+0x48>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80104634:	8b 55 08             	mov    0x8(%ebp),%edx
80104637:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010463a:	01 c2                	add    %eax,%edx
8010463c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104642:	8b 40 04             	mov    0x4(%eax),%eax
80104645:	83 ec 04             	sub    $0x4,%esp
80104648:	52                   	push   %edx
80104649:	ff 75 f4             	pushl  -0xc(%ebp)
8010464c:	50                   	push   %eax
8010464d:	e8 bd 39 00 00       	call   8010800f <allocuvm>
80104652:	83 c4 10             	add    $0x10,%esp
80104655:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104658:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010465c:	75 3e                	jne    8010469c <growproc+0x7f>
      return -1;
8010465e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104663:	eb 59                	jmp    801046be <growproc+0xa1>
  } else if(n < 0){
80104665:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104669:	79 31                	jns    8010469c <growproc+0x7f>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
8010466b:	8b 55 08             	mov    0x8(%ebp),%edx
8010466e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104671:	01 c2                	add    %eax,%edx
80104673:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104679:	8b 40 04             	mov    0x4(%eax),%eax
8010467c:	83 ec 04             	sub    $0x4,%esp
8010467f:	52                   	push   %edx
80104680:	ff 75 f4             	pushl  -0xc(%ebp)
80104683:	50                   	push   %eax
80104684:	e8 4f 3a 00 00       	call   801080d8 <deallocuvm>
80104689:	83 c4 10             	add    $0x10,%esp
8010468c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010468f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104693:	75 07                	jne    8010469c <growproc+0x7f>
      return -1;
80104695:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010469a:	eb 22                	jmp    801046be <growproc+0xa1>
  }
  proc->sz = sz;
8010469c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801046a5:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
801046a7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046ad:	83 ec 0c             	sub    $0xc,%esp
801046b0:	50                   	push   %eax
801046b1:	e8 9b 36 00 00       	call   80107d51 <switchuvm>
801046b6:	83 c4 10             	add    $0x10,%esp
  return 0;
801046b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801046be:	c9                   	leave  
801046bf:	c3                   	ret    

801046c0 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
801046c0:	55                   	push   %ebp
801046c1:	89 e5                	mov    %esp,%ebp
801046c3:	57                   	push   %edi
801046c4:	56                   	push   %esi
801046c5:	53                   	push   %ebx
801046c6:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
801046c9:	e8 30 fd ff ff       	call   801043fe <allocproc>
801046ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
801046d1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801046d5:	75 0a                	jne    801046e1 <fork+0x21>
    return -1;
801046d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046dc:	e9 68 01 00 00       	jmp    80104849 <fork+0x189>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
801046e1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046e7:	8b 10                	mov    (%eax),%edx
801046e9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046ef:	8b 40 04             	mov    0x4(%eax),%eax
801046f2:	83 ec 08             	sub    $0x8,%esp
801046f5:	52                   	push   %edx
801046f6:	50                   	push   %eax
801046f7:	e8 78 3b 00 00       	call   80108274 <copyuvm>
801046fc:	83 c4 10             	add    $0x10,%esp
801046ff:	89 c2                	mov    %eax,%edx
80104701:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104704:	89 50 04             	mov    %edx,0x4(%eax)
80104707:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010470a:	8b 40 04             	mov    0x4(%eax),%eax
8010470d:	85 c0                	test   %eax,%eax
8010470f:	75 30                	jne    80104741 <fork+0x81>
    kfree(np->kstack);
80104711:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104714:	8b 40 08             	mov    0x8(%eax),%eax
80104717:	83 ec 0c             	sub    $0xc,%esp
8010471a:	50                   	push   %eax
8010471b:	e8 4d e4 ff ff       	call   80102b6d <kfree>
80104720:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80104723:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104726:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
8010472d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104730:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80104737:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010473c:	e9 08 01 00 00       	jmp    80104849 <fork+0x189>
  }
  np->sz = proc->sz;
80104741:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104747:	8b 10                	mov    (%eax),%edx
80104749:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010474c:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
8010474e:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104755:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104758:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
8010475b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010475e:	8b 50 18             	mov    0x18(%eax),%edx
80104761:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104767:	8b 40 18             	mov    0x18(%eax),%eax
8010476a:	89 c3                	mov    %eax,%ebx
8010476c:	b8 13 00 00 00       	mov    $0x13,%eax
80104771:	89 d7                	mov    %edx,%edi
80104773:	89 de                	mov    %ebx,%esi
80104775:	89 c1                	mov    %eax,%ecx
80104777:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104779:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010477c:	8b 40 18             	mov    0x18(%eax),%eax
8010477f:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104786:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010478d:	eb 43                	jmp    801047d2 <fork+0x112>
    if(proc->ofile[i])
8010478f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104795:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104798:	83 c2 08             	add    $0x8,%edx
8010479b:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010479f:	85 c0                	test   %eax,%eax
801047a1:	74 2b                	je     801047ce <fork+0x10e>
      np->ofile[i] = filedup(proc->ofile[i]);
801047a3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047a9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801047ac:	83 c2 08             	add    $0x8,%edx
801047af:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801047b3:	83 ec 0c             	sub    $0xc,%esp
801047b6:	50                   	push   %eax
801047b7:	e8 00 c8 ff ff       	call   80100fbc <filedup>
801047bc:	83 c4 10             	add    $0x10,%esp
801047bf:	89 c1                	mov    %eax,%ecx
801047c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047c4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801047c7:	83 c2 08             	add    $0x8,%edx
801047ca:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
801047ce:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801047d2:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
801047d6:	7e b7                	jle    8010478f <fork+0xcf>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
801047d8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047de:	8b 40 68             	mov    0x68(%eax),%eax
801047e1:	83 ec 0c             	sub    $0xc,%esp
801047e4:	50                   	push   %eax
801047e5:	e8 fa d0 ff ff       	call   801018e4 <idup>
801047ea:	83 c4 10             	add    $0x10,%esp
801047ed:	89 c2                	mov    %eax,%edx
801047ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047f2:	89 50 68             	mov    %edx,0x68(%eax)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
801047f5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047fb:	8d 50 6c             	lea    0x6c(%eax),%edx
801047fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104801:	83 c0 6c             	add    $0x6c,%eax
80104804:	83 ec 04             	sub    $0x4,%esp
80104807:	6a 10                	push   $0x10
80104809:	52                   	push   %edx
8010480a:	50                   	push   %eax
8010480b:	e8 cc 0b 00 00       	call   801053dc <safestrcpy>
80104810:	83 c4 10             	add    $0x10,%esp
 
  pid = np->pid;
80104813:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104816:	8b 40 10             	mov    0x10(%eax),%eax
80104819:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
8010481c:	83 ec 0c             	sub    $0xc,%esp
8010481f:	68 80 2a 11 80       	push   $0x80112a80
80104824:	e8 52 07 00 00       	call   80104f7b <acquire>
80104829:	83 c4 10             	add    $0x10,%esp
  np->state = RUNNABLE;
8010482c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010482f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  release(&ptable.lock);
80104836:	83 ec 0c             	sub    $0xc,%esp
80104839:	68 80 2a 11 80       	push   $0x80112a80
8010483e:	e8 9e 07 00 00       	call   80104fe1 <release>
80104843:	83 c4 10             	add    $0x10,%esp
  
  return pid;
80104846:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80104849:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010484c:	5b                   	pop    %ebx
8010484d:	5e                   	pop    %esi
8010484e:	5f                   	pop    %edi
8010484f:	5d                   	pop    %ebp
80104850:	c3                   	ret    

80104851 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104851:	55                   	push   %ebp
80104852:	89 e5                	mov    %esp,%ebp
80104854:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
80104857:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010485e:	a1 68 b6 10 80       	mov    0x8010b668,%eax
80104863:	39 c2                	cmp    %eax,%edx
80104865:	75 0d                	jne    80104874 <exit+0x23>
    panic("init exiting");
80104867:	83 ec 0c             	sub    $0xc,%esp
8010486a:	68 f0 87 10 80       	push   $0x801087f0
8010486f:	e8 e8 bc ff ff       	call   8010055c <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104874:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010487b:	eb 48                	jmp    801048c5 <exit+0x74>
    if(proc->ofile[fd]){
8010487d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104883:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104886:	83 c2 08             	add    $0x8,%edx
80104889:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010488d:	85 c0                	test   %eax,%eax
8010488f:	74 30                	je     801048c1 <exit+0x70>
      fileclose(proc->ofile[fd]);
80104891:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104897:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010489a:	83 c2 08             	add    $0x8,%edx
8010489d:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801048a1:	83 ec 0c             	sub    $0xc,%esp
801048a4:	50                   	push   %eax
801048a5:	e8 63 c7 ff ff       	call   8010100d <fileclose>
801048aa:	83 c4 10             	add    $0x10,%esp
      proc->ofile[fd] = 0;
801048ad:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048b3:	8b 55 f0             	mov    -0x10(%ebp),%edx
801048b6:	83 c2 08             	add    $0x8,%edx
801048b9:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801048c0:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801048c1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801048c5:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
801048c9:	7e b2                	jle    8010487d <exit+0x2c>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
801048cb:	e8 12 ec ff ff       	call   801034e2 <begin_op>
  iput(proc->cwd);
801048d0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048d6:	8b 40 68             	mov    0x68(%eax),%eax
801048d9:	83 ec 0c             	sub    $0xc,%esp
801048dc:	50                   	push   %eax
801048dd:	e8 0a d2 ff ff       	call   80101aec <iput>
801048e2:	83 c4 10             	add    $0x10,%esp
  end_op();
801048e5:	e8 86 ec ff ff       	call   80103570 <end_op>
  proc->cwd = 0;
801048ea:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048f0:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
801048f7:	83 ec 0c             	sub    $0xc,%esp
801048fa:	68 80 2a 11 80       	push   $0x80112a80
801048ff:	e8 77 06 00 00       	call   80104f7b <acquire>
80104904:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104907:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010490d:	8b 40 14             	mov    0x14(%eax),%eax
80104910:	83 ec 0c             	sub    $0xc,%esp
80104913:	50                   	push   %eax
80104914:	e8 1d 04 00 00       	call   80104d36 <wakeup1>
80104919:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010491c:	c7 45 f4 b4 2a 11 80 	movl   $0x80112ab4,-0xc(%ebp)
80104923:	eb 3c                	jmp    80104961 <exit+0x110>
    if(p->parent == proc){
80104925:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104928:	8b 50 14             	mov    0x14(%eax),%edx
8010492b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104931:	39 c2                	cmp    %eax,%edx
80104933:	75 28                	jne    8010495d <exit+0x10c>
      p->parent = initproc;
80104935:	8b 15 68 b6 10 80    	mov    0x8010b668,%edx
8010493b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010493e:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104941:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104944:	8b 40 0c             	mov    0xc(%eax),%eax
80104947:	83 f8 05             	cmp    $0x5,%eax
8010494a:	75 11                	jne    8010495d <exit+0x10c>
        wakeup1(initproc);
8010494c:	a1 68 b6 10 80       	mov    0x8010b668,%eax
80104951:	83 ec 0c             	sub    $0xc,%esp
80104954:	50                   	push   %eax
80104955:	e8 dc 03 00 00       	call   80104d36 <wakeup1>
8010495a:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010495d:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104961:	81 7d f4 b4 49 11 80 	cmpl   $0x801149b4,-0xc(%ebp)
80104968:	72 bb                	jb     80104925 <exit+0xd4>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
8010496a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104970:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104977:	e8 d5 01 00 00       	call   80104b51 <sched>
  panic("zombie exit");
8010497c:	83 ec 0c             	sub    $0xc,%esp
8010497f:	68 fd 87 10 80       	push   $0x801087fd
80104984:	e8 d3 bb ff ff       	call   8010055c <panic>

80104989 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104989:	55                   	push   %ebp
8010498a:	89 e5                	mov    %esp,%ebp
8010498c:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
8010498f:	83 ec 0c             	sub    $0xc,%esp
80104992:	68 80 2a 11 80       	push   $0x80112a80
80104997:	e8 df 05 00 00       	call   80104f7b <acquire>
8010499c:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
8010499f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049a6:	c7 45 f4 b4 2a 11 80 	movl   $0x80112ab4,-0xc(%ebp)
801049ad:	e9 a6 00 00 00       	jmp    80104a58 <wait+0xcf>
      if(p->parent != proc)
801049b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049b5:	8b 50 14             	mov    0x14(%eax),%edx
801049b8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049be:	39 c2                	cmp    %eax,%edx
801049c0:	74 05                	je     801049c7 <wait+0x3e>
        continue;
801049c2:	e9 8d 00 00 00       	jmp    80104a54 <wait+0xcb>
      havekids = 1;
801049c7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
801049ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049d1:	8b 40 0c             	mov    0xc(%eax),%eax
801049d4:	83 f8 05             	cmp    $0x5,%eax
801049d7:	75 7b                	jne    80104a54 <wait+0xcb>
        // Found one.
        pid = p->pid;
801049d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049dc:	8b 40 10             	mov    0x10(%eax),%eax
801049df:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
801049e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049e5:	8b 40 08             	mov    0x8(%eax),%eax
801049e8:	83 ec 0c             	sub    $0xc,%esp
801049eb:	50                   	push   %eax
801049ec:	e8 7c e1 ff ff       	call   80102b6d <kfree>
801049f1:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
801049f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049f7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
801049fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a01:	8b 40 04             	mov    0x4(%eax),%eax
80104a04:	83 ec 0c             	sub    $0xc,%esp
80104a07:	50                   	push   %eax
80104a08:	e8 88 37 00 00       	call   80108195 <freevm>
80104a0d:	83 c4 10             	add    $0x10,%esp
        p->state = UNUSED;
80104a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a13:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104a1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a1d:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a27:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a31:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a38:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
80104a3f:	83 ec 0c             	sub    $0xc,%esp
80104a42:	68 80 2a 11 80       	push   $0x80112a80
80104a47:	e8 95 05 00 00       	call   80104fe1 <release>
80104a4c:	83 c4 10             	add    $0x10,%esp
        return pid;
80104a4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a52:	eb 57                	jmp    80104aab <wait+0x122>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a54:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104a58:	81 7d f4 b4 49 11 80 	cmpl   $0x801149b4,-0xc(%ebp)
80104a5f:	0f 82 4d ff ff ff    	jb     801049b2 <wait+0x29>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104a65:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104a69:	74 0d                	je     80104a78 <wait+0xef>
80104a6b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a71:	8b 40 24             	mov    0x24(%eax),%eax
80104a74:	85 c0                	test   %eax,%eax
80104a76:	74 17                	je     80104a8f <wait+0x106>
      release(&ptable.lock);
80104a78:	83 ec 0c             	sub    $0xc,%esp
80104a7b:	68 80 2a 11 80       	push   $0x80112a80
80104a80:	e8 5c 05 00 00       	call   80104fe1 <release>
80104a85:	83 c4 10             	add    $0x10,%esp
      return -1;
80104a88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a8d:	eb 1c                	jmp    80104aab <wait+0x122>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104a8f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a95:	83 ec 08             	sub    $0x8,%esp
80104a98:	68 80 2a 11 80       	push   $0x80112a80
80104a9d:	50                   	push   %eax
80104a9e:	e8 e8 01 00 00       	call   80104c8b <sleep>
80104aa3:	83 c4 10             	add    $0x10,%esp
  }
80104aa6:	e9 f4 fe ff ff       	jmp    8010499f <wait+0x16>
}
80104aab:	c9                   	leave  
80104aac:	c3                   	ret    

80104aad <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104aad:	55                   	push   %ebp
80104aae:	89 e5                	mov    %esp,%ebp
80104ab0:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  for(;;){
    // Enable interrupts on this processor.
    sti();
80104ab3:	e8 23 f9 ff ff       	call   801043db <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104ab8:	83 ec 0c             	sub    $0xc,%esp
80104abb:	68 80 2a 11 80       	push   $0x80112a80
80104ac0:	e8 b6 04 00 00       	call   80104f7b <acquire>
80104ac5:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ac8:	c7 45 f4 b4 2a 11 80 	movl   $0x80112ab4,-0xc(%ebp)
80104acf:	eb 62                	jmp    80104b33 <scheduler+0x86>
      if(p->state != RUNNABLE)
80104ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ad4:	8b 40 0c             	mov    0xc(%eax),%eax
80104ad7:	83 f8 03             	cmp    $0x3,%eax
80104ada:	74 02                	je     80104ade <scheduler+0x31>
        continue;
80104adc:	eb 51                	jmp    80104b2f <scheduler+0x82>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
80104ade:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ae1:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
80104ae7:	83 ec 0c             	sub    $0xc,%esp
80104aea:	ff 75 f4             	pushl  -0xc(%ebp)
80104aed:	e8 5f 32 00 00       	call   80107d51 <switchuvm>
80104af2:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
80104af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104af8:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      swtch(&cpu->scheduler, proc->context);
80104aff:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b05:	8b 40 1c             	mov    0x1c(%eax),%eax
80104b08:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104b0f:	83 c2 04             	add    $0x4,%edx
80104b12:	83 ec 08             	sub    $0x8,%esp
80104b15:	50                   	push   %eax
80104b16:	52                   	push   %edx
80104b17:	e8 31 09 00 00       	call   8010544d <swtch>
80104b1c:	83 c4 10             	add    $0x10,%esp
      switchkvm();
80104b1f:	e8 11 32 00 00       	call   80107d35 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80104b24:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104b2b:	00 00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b2f:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104b33:	81 7d f4 b4 49 11 80 	cmpl   $0x801149b4,-0xc(%ebp)
80104b3a:	72 95                	jb     80104ad1 <scheduler+0x24>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
80104b3c:	83 ec 0c             	sub    $0xc,%esp
80104b3f:	68 80 2a 11 80       	push   $0x80112a80
80104b44:	e8 98 04 00 00       	call   80104fe1 <release>
80104b49:	83 c4 10             	add    $0x10,%esp

  }
80104b4c:	e9 62 ff ff ff       	jmp    80104ab3 <scheduler+0x6>

80104b51 <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
80104b51:	55                   	push   %ebp
80104b52:	89 e5                	mov    %esp,%ebp
80104b54:	83 ec 18             	sub    $0x18,%esp
  int intena;

  if(!holding(&ptable.lock))
80104b57:	83 ec 0c             	sub    $0xc,%esp
80104b5a:	68 80 2a 11 80       	push   $0x80112a80
80104b5f:	e8 47 05 00 00       	call   801050ab <holding>
80104b64:	83 c4 10             	add    $0x10,%esp
80104b67:	85 c0                	test   %eax,%eax
80104b69:	75 0d                	jne    80104b78 <sched+0x27>
    panic("sched ptable.lock");
80104b6b:	83 ec 0c             	sub    $0xc,%esp
80104b6e:	68 09 88 10 80       	push   $0x80108809
80104b73:	e8 e4 b9 ff ff       	call   8010055c <panic>
  if(cpu->ncli != 1)
80104b78:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104b7e:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104b84:	83 f8 01             	cmp    $0x1,%eax
80104b87:	74 0d                	je     80104b96 <sched+0x45>
    panic("sched locks");
80104b89:	83 ec 0c             	sub    $0xc,%esp
80104b8c:	68 1b 88 10 80       	push   $0x8010881b
80104b91:	e8 c6 b9 ff ff       	call   8010055c <panic>
  if(proc->state == RUNNING)
80104b96:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b9c:	8b 40 0c             	mov    0xc(%eax),%eax
80104b9f:	83 f8 04             	cmp    $0x4,%eax
80104ba2:	75 0d                	jne    80104bb1 <sched+0x60>
    panic("sched running");
80104ba4:	83 ec 0c             	sub    $0xc,%esp
80104ba7:	68 27 88 10 80       	push   $0x80108827
80104bac:	e8 ab b9 ff ff       	call   8010055c <panic>
  if(readeflags()&FL_IF)
80104bb1:	e8 15 f8 ff ff       	call   801043cb <readeflags>
80104bb6:	25 00 02 00 00       	and    $0x200,%eax
80104bbb:	85 c0                	test   %eax,%eax
80104bbd:	74 0d                	je     80104bcc <sched+0x7b>
    panic("sched interruptible");
80104bbf:	83 ec 0c             	sub    $0xc,%esp
80104bc2:	68 35 88 10 80       	push   $0x80108835
80104bc7:	e8 90 b9 ff ff       	call   8010055c <panic>
  intena = cpu->intena;
80104bcc:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104bd2:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104bd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
80104bdb:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104be1:	8b 40 04             	mov    0x4(%eax),%eax
80104be4:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104beb:	83 c2 1c             	add    $0x1c,%edx
80104bee:	83 ec 08             	sub    $0x8,%esp
80104bf1:	50                   	push   %eax
80104bf2:	52                   	push   %edx
80104bf3:	e8 55 08 00 00       	call   8010544d <swtch>
80104bf8:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
80104bfb:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104c01:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104c04:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104c0a:	c9                   	leave  
80104c0b:	c3                   	ret    

80104c0c <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104c0c:	55                   	push   %ebp
80104c0d:	89 e5                	mov    %esp,%ebp
80104c0f:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104c12:	83 ec 0c             	sub    $0xc,%esp
80104c15:	68 80 2a 11 80       	push   $0x80112a80
80104c1a:	e8 5c 03 00 00       	call   80104f7b <acquire>
80104c1f:	83 c4 10             	add    $0x10,%esp
  proc->state = RUNNABLE;
80104c22:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c28:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104c2f:	e8 1d ff ff ff       	call   80104b51 <sched>
  release(&ptable.lock);
80104c34:	83 ec 0c             	sub    $0xc,%esp
80104c37:	68 80 2a 11 80       	push   $0x80112a80
80104c3c:	e8 a0 03 00 00       	call   80104fe1 <release>
80104c41:	83 c4 10             	add    $0x10,%esp
}
80104c44:	c9                   	leave  
80104c45:	c3                   	ret    

80104c46 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104c46:	55                   	push   %ebp
80104c47:	89 e5                	mov    %esp,%ebp
80104c49:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104c4c:	83 ec 0c             	sub    $0xc,%esp
80104c4f:	68 80 2a 11 80       	push   $0x80112a80
80104c54:	e8 88 03 00 00       	call   80104fe1 <release>
80104c59:	83 c4 10             	add    $0x10,%esp

  if (first) {
80104c5c:	a1 08 b0 10 80       	mov    0x8010b008,%eax
80104c61:	85 c0                	test   %eax,%eax
80104c63:	74 24                	je     80104c89 <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80104c65:	c7 05 08 b0 10 80 00 	movl   $0x0,0x8010b008
80104c6c:	00 00 00 
    iinit(ROOTDEV);
80104c6f:	83 ec 0c             	sub    $0xc,%esp
80104c72:	6a 01                	push   $0x1
80104c74:	e8 7c c9 ff ff       	call   801015f5 <iinit>
80104c79:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
80104c7c:	83 ec 0c             	sub    $0xc,%esp
80104c7f:	6a 01                	push   $0x1
80104c81:	e8 43 e6 ff ff       	call   801032c9 <initlog>
80104c86:	83 c4 10             	add    $0x10,%esp
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
80104c89:	c9                   	leave  
80104c8a:	c3                   	ret    

80104c8b <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104c8b:	55                   	push   %ebp
80104c8c:	89 e5                	mov    %esp,%ebp
80104c8e:	83 ec 08             	sub    $0x8,%esp
  if(proc == 0)
80104c91:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c97:	85 c0                	test   %eax,%eax
80104c99:	75 0d                	jne    80104ca8 <sleep+0x1d>
    panic("sleep");
80104c9b:	83 ec 0c             	sub    $0xc,%esp
80104c9e:	68 49 88 10 80       	push   $0x80108849
80104ca3:	e8 b4 b8 ff ff       	call   8010055c <panic>

  if(lk == 0)
80104ca8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104cac:	75 0d                	jne    80104cbb <sleep+0x30>
    panic("sleep without lk");
80104cae:	83 ec 0c             	sub    $0xc,%esp
80104cb1:	68 4f 88 10 80       	push   $0x8010884f
80104cb6:	e8 a1 b8 ff ff       	call   8010055c <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104cbb:	81 7d 0c 80 2a 11 80 	cmpl   $0x80112a80,0xc(%ebp)
80104cc2:	74 1e                	je     80104ce2 <sleep+0x57>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104cc4:	83 ec 0c             	sub    $0xc,%esp
80104cc7:	68 80 2a 11 80       	push   $0x80112a80
80104ccc:	e8 aa 02 00 00       	call   80104f7b <acquire>
80104cd1:	83 c4 10             	add    $0x10,%esp
    release(lk);
80104cd4:	83 ec 0c             	sub    $0xc,%esp
80104cd7:	ff 75 0c             	pushl  0xc(%ebp)
80104cda:	e8 02 03 00 00       	call   80104fe1 <release>
80104cdf:	83 c4 10             	add    $0x10,%esp
  }

  // Go to sleep.
  proc->chan = chan;
80104ce2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ce8:	8b 55 08             	mov    0x8(%ebp),%edx
80104ceb:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
80104cee:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cf4:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80104cfb:	e8 51 fe ff ff       	call   80104b51 <sched>

  // Tidy up.
  proc->chan = 0;
80104d00:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d06:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104d0d:	81 7d 0c 80 2a 11 80 	cmpl   $0x80112a80,0xc(%ebp)
80104d14:	74 1e                	je     80104d34 <sleep+0xa9>
    release(&ptable.lock);
80104d16:	83 ec 0c             	sub    $0xc,%esp
80104d19:	68 80 2a 11 80       	push   $0x80112a80
80104d1e:	e8 be 02 00 00       	call   80104fe1 <release>
80104d23:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
80104d26:	83 ec 0c             	sub    $0xc,%esp
80104d29:	ff 75 0c             	pushl  0xc(%ebp)
80104d2c:	e8 4a 02 00 00       	call   80104f7b <acquire>
80104d31:	83 c4 10             	add    $0x10,%esp
  }
}
80104d34:	c9                   	leave  
80104d35:	c3                   	ret    

80104d36 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104d36:	55                   	push   %ebp
80104d37:	89 e5                	mov    %esp,%ebp
80104d39:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d3c:	c7 45 fc b4 2a 11 80 	movl   $0x80112ab4,-0x4(%ebp)
80104d43:	eb 24                	jmp    80104d69 <wakeup1+0x33>
    if(p->state == SLEEPING && p->chan == chan)
80104d45:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d48:	8b 40 0c             	mov    0xc(%eax),%eax
80104d4b:	83 f8 02             	cmp    $0x2,%eax
80104d4e:	75 15                	jne    80104d65 <wakeup1+0x2f>
80104d50:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d53:	8b 40 20             	mov    0x20(%eax),%eax
80104d56:	3b 45 08             	cmp    0x8(%ebp),%eax
80104d59:	75 0a                	jne    80104d65 <wakeup1+0x2f>
      p->state = RUNNABLE;
80104d5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d5e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d65:	83 45 fc 7c          	addl   $0x7c,-0x4(%ebp)
80104d69:	81 7d fc b4 49 11 80 	cmpl   $0x801149b4,-0x4(%ebp)
80104d70:	72 d3                	jb     80104d45 <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
80104d72:	c9                   	leave  
80104d73:	c3                   	ret    

80104d74 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104d74:	55                   	push   %ebp
80104d75:	89 e5                	mov    %esp,%ebp
80104d77:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
80104d7a:	83 ec 0c             	sub    $0xc,%esp
80104d7d:	68 80 2a 11 80       	push   $0x80112a80
80104d82:	e8 f4 01 00 00       	call   80104f7b <acquire>
80104d87:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80104d8a:	83 ec 0c             	sub    $0xc,%esp
80104d8d:	ff 75 08             	pushl  0x8(%ebp)
80104d90:	e8 a1 ff ff ff       	call   80104d36 <wakeup1>
80104d95:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80104d98:	83 ec 0c             	sub    $0xc,%esp
80104d9b:	68 80 2a 11 80       	push   $0x80112a80
80104da0:	e8 3c 02 00 00       	call   80104fe1 <release>
80104da5:	83 c4 10             	add    $0x10,%esp
}
80104da8:	c9                   	leave  
80104da9:	c3                   	ret    

80104daa <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104daa:	55                   	push   %ebp
80104dab:	89 e5                	mov    %esp,%ebp
80104dad:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104db0:	83 ec 0c             	sub    $0xc,%esp
80104db3:	68 80 2a 11 80       	push   $0x80112a80
80104db8:	e8 be 01 00 00       	call   80104f7b <acquire>
80104dbd:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104dc0:	c7 45 f4 b4 2a 11 80 	movl   $0x80112ab4,-0xc(%ebp)
80104dc7:	eb 45                	jmp    80104e0e <kill+0x64>
    if(p->pid == pid){
80104dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dcc:	8b 40 10             	mov    0x10(%eax),%eax
80104dcf:	3b 45 08             	cmp    0x8(%ebp),%eax
80104dd2:	75 36                	jne    80104e0a <kill+0x60>
      p->killed = 1;
80104dd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dd7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104dde:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104de1:	8b 40 0c             	mov    0xc(%eax),%eax
80104de4:	83 f8 02             	cmp    $0x2,%eax
80104de7:	75 0a                	jne    80104df3 <kill+0x49>
        p->state = RUNNABLE;
80104de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dec:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104df3:	83 ec 0c             	sub    $0xc,%esp
80104df6:	68 80 2a 11 80       	push   $0x80112a80
80104dfb:	e8 e1 01 00 00       	call   80104fe1 <release>
80104e00:	83 c4 10             	add    $0x10,%esp
      return 0;
80104e03:	b8 00 00 00 00       	mov    $0x0,%eax
80104e08:	eb 22                	jmp    80104e2c <kill+0x82>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e0a:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104e0e:	81 7d f4 b4 49 11 80 	cmpl   $0x801149b4,-0xc(%ebp)
80104e15:	72 b2                	jb     80104dc9 <kill+0x1f>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104e17:	83 ec 0c             	sub    $0xc,%esp
80104e1a:	68 80 2a 11 80       	push   $0x80112a80
80104e1f:	e8 bd 01 00 00       	call   80104fe1 <release>
80104e24:	83 c4 10             	add    $0x10,%esp
  return -1;
80104e27:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e2c:	c9                   	leave  
80104e2d:	c3                   	ret    

80104e2e <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104e2e:	55                   	push   %ebp
80104e2f:	89 e5                	mov    %esp,%ebp
80104e31:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e34:	c7 45 f0 b4 2a 11 80 	movl   $0x80112ab4,-0x10(%ebp)
80104e3b:	e9 d5 00 00 00       	jmp    80104f15 <procdump+0xe7>
    if(p->state == UNUSED)
80104e40:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e43:	8b 40 0c             	mov    0xc(%eax),%eax
80104e46:	85 c0                	test   %eax,%eax
80104e48:	75 05                	jne    80104e4f <procdump+0x21>
      continue;
80104e4a:	e9 c2 00 00 00       	jmp    80104f11 <procdump+0xe3>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104e4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e52:	8b 40 0c             	mov    0xc(%eax),%eax
80104e55:	83 f8 05             	cmp    $0x5,%eax
80104e58:	77 23                	ja     80104e7d <procdump+0x4f>
80104e5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e5d:	8b 40 0c             	mov    0xc(%eax),%eax
80104e60:	8b 04 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%eax
80104e67:	85 c0                	test   %eax,%eax
80104e69:	74 12                	je     80104e7d <procdump+0x4f>
      state = states[p->state];
80104e6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e6e:	8b 40 0c             	mov    0xc(%eax),%eax
80104e71:	8b 04 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%eax
80104e78:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104e7b:	eb 07                	jmp    80104e84 <procdump+0x56>
    else
      state = "???";
80104e7d:	c7 45 ec 60 88 10 80 	movl   $0x80108860,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104e84:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e87:	8d 50 6c             	lea    0x6c(%eax),%edx
80104e8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e8d:	8b 40 10             	mov    0x10(%eax),%eax
80104e90:	52                   	push   %edx
80104e91:	ff 75 ec             	pushl  -0x14(%ebp)
80104e94:	50                   	push   %eax
80104e95:	68 64 88 10 80       	push   $0x80108864
80104e9a:	e8 20 b5 ff ff       	call   801003bf <cprintf>
80104e9f:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
80104ea2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ea5:	8b 40 0c             	mov    0xc(%eax),%eax
80104ea8:	83 f8 02             	cmp    $0x2,%eax
80104eab:	75 54                	jne    80104f01 <procdump+0xd3>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104ead:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104eb0:	8b 40 1c             	mov    0x1c(%eax),%eax
80104eb3:	8b 40 0c             	mov    0xc(%eax),%eax
80104eb6:	83 c0 08             	add    $0x8,%eax
80104eb9:	89 c2                	mov    %eax,%edx
80104ebb:	83 ec 08             	sub    $0x8,%esp
80104ebe:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104ec1:	50                   	push   %eax
80104ec2:	52                   	push   %edx
80104ec3:	e8 6a 01 00 00       	call   80105032 <getcallerpcs>
80104ec8:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104ecb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104ed2:	eb 1c                	jmp    80104ef0 <procdump+0xc2>
        cprintf(" %p", pc[i]);
80104ed4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ed7:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104edb:	83 ec 08             	sub    $0x8,%esp
80104ede:	50                   	push   %eax
80104edf:	68 6d 88 10 80       	push   $0x8010886d
80104ee4:	e8 d6 b4 ff ff       	call   801003bf <cprintf>
80104ee9:	83 c4 10             	add    $0x10,%esp
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104eec:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104ef0:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104ef4:	7f 0b                	jg     80104f01 <procdump+0xd3>
80104ef6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ef9:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104efd:	85 c0                	test   %eax,%eax
80104eff:	75 d3                	jne    80104ed4 <procdump+0xa6>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104f01:	83 ec 0c             	sub    $0xc,%esp
80104f04:	68 71 88 10 80       	push   $0x80108871
80104f09:	e8 b1 b4 ff ff       	call   801003bf <cprintf>
80104f0e:	83 c4 10             	add    $0x10,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f11:	83 45 f0 7c          	addl   $0x7c,-0x10(%ebp)
80104f15:	81 7d f0 b4 49 11 80 	cmpl   $0x801149b4,-0x10(%ebp)
80104f1c:	0f 82 1e ff ff ff    	jb     80104e40 <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104f22:	c9                   	leave  
80104f23:	c3                   	ret    

80104f24 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104f24:	55                   	push   %ebp
80104f25:	89 e5                	mov    %esp,%ebp
80104f27:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104f2a:	9c                   	pushf  
80104f2b:	58                   	pop    %eax
80104f2c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104f2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104f32:	c9                   	leave  
80104f33:	c3                   	ret    

80104f34 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80104f34:	55                   	push   %ebp
80104f35:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80104f37:	fa                   	cli    
}
80104f38:	5d                   	pop    %ebp
80104f39:	c3                   	ret    

80104f3a <sti>:

static inline void
sti(void)
{
80104f3a:	55                   	push   %ebp
80104f3b:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104f3d:	fb                   	sti    
}
80104f3e:	5d                   	pop    %ebp
80104f3f:	c3                   	ret    

80104f40 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80104f40:	55                   	push   %ebp
80104f41:	89 e5                	mov    %esp,%ebp
80104f43:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104f46:	8b 55 08             	mov    0x8(%ebp),%edx
80104f49:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f4c:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104f4f:	f0 87 02             	lock xchg %eax,(%edx)
80104f52:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80104f55:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104f58:	c9                   	leave  
80104f59:	c3                   	ret    

80104f5a <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104f5a:	55                   	push   %ebp
80104f5b:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80104f5d:	8b 45 08             	mov    0x8(%ebp),%eax
80104f60:	8b 55 0c             	mov    0xc(%ebp),%edx
80104f63:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80104f66:	8b 45 08             	mov    0x8(%ebp),%eax
80104f69:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80104f6f:	8b 45 08             	mov    0x8(%ebp),%eax
80104f72:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104f79:	5d                   	pop    %ebp
80104f7a:	c3                   	ret    

80104f7b <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104f7b:	55                   	push   %ebp
80104f7c:	89 e5                	mov    %esp,%ebp
80104f7e:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104f81:	e8 4f 01 00 00       	call   801050d5 <pushcli>
  if(holding(lk))
80104f86:	8b 45 08             	mov    0x8(%ebp),%eax
80104f89:	83 ec 0c             	sub    $0xc,%esp
80104f8c:	50                   	push   %eax
80104f8d:	e8 19 01 00 00       	call   801050ab <holding>
80104f92:	83 c4 10             	add    $0x10,%esp
80104f95:	85 c0                	test   %eax,%eax
80104f97:	74 0d                	je     80104fa6 <acquire+0x2b>
    panic("acquire");
80104f99:	83 ec 0c             	sub    $0xc,%esp
80104f9c:	68 9d 88 10 80       	push   $0x8010889d
80104fa1:	e8 b6 b5 ff ff       	call   8010055c <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80104fa6:	90                   	nop
80104fa7:	8b 45 08             	mov    0x8(%ebp),%eax
80104faa:	83 ec 08             	sub    $0x8,%esp
80104fad:	6a 01                	push   $0x1
80104faf:	50                   	push   %eax
80104fb0:	e8 8b ff ff ff       	call   80104f40 <xchg>
80104fb5:	83 c4 10             	add    $0x10,%esp
80104fb8:	85 c0                	test   %eax,%eax
80104fba:	75 eb                	jne    80104fa7 <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80104fbc:	8b 45 08             	mov    0x8(%ebp),%eax
80104fbf:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104fc6:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80104fc9:	8b 45 08             	mov    0x8(%ebp),%eax
80104fcc:	83 c0 0c             	add    $0xc,%eax
80104fcf:	83 ec 08             	sub    $0x8,%esp
80104fd2:	50                   	push   %eax
80104fd3:	8d 45 08             	lea    0x8(%ebp),%eax
80104fd6:	50                   	push   %eax
80104fd7:	e8 56 00 00 00       	call   80105032 <getcallerpcs>
80104fdc:	83 c4 10             	add    $0x10,%esp
}
80104fdf:	c9                   	leave  
80104fe0:	c3                   	ret    

80104fe1 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80104fe1:	55                   	push   %ebp
80104fe2:	89 e5                	mov    %esp,%ebp
80104fe4:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
80104fe7:	83 ec 0c             	sub    $0xc,%esp
80104fea:	ff 75 08             	pushl  0x8(%ebp)
80104fed:	e8 b9 00 00 00       	call   801050ab <holding>
80104ff2:	83 c4 10             	add    $0x10,%esp
80104ff5:	85 c0                	test   %eax,%eax
80104ff7:	75 0d                	jne    80105006 <release+0x25>
    panic("release");
80104ff9:	83 ec 0c             	sub    $0xc,%esp
80104ffc:	68 a5 88 10 80       	push   $0x801088a5
80105001:	e8 56 b5 ff ff       	call   8010055c <panic>

  lk->pcs[0] = 0;
80105006:	8b 45 08             	mov    0x8(%ebp),%eax
80105009:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80105010:	8b 45 08             	mov    0x8(%ebp),%eax
80105013:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
8010501a:	8b 45 08             	mov    0x8(%ebp),%eax
8010501d:	83 ec 08             	sub    $0x8,%esp
80105020:	6a 00                	push   $0x0
80105022:	50                   	push   %eax
80105023:	e8 18 ff ff ff       	call   80104f40 <xchg>
80105028:	83 c4 10             	add    $0x10,%esp

  popcli();
8010502b:	e8 e9 00 00 00       	call   80105119 <popcli>
}
80105030:	c9                   	leave  
80105031:	c3                   	ret    

80105032 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105032:	55                   	push   %ebp
80105033:	89 e5                	mov    %esp,%ebp
80105035:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80105038:	8b 45 08             	mov    0x8(%ebp),%eax
8010503b:	83 e8 08             	sub    $0x8,%eax
8010503e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80105041:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80105048:	eb 38                	jmp    80105082 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010504a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
8010504e:	74 38                	je     80105088 <getcallerpcs+0x56>
80105050:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80105057:	76 2f                	jbe    80105088 <getcallerpcs+0x56>
80105059:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
8010505d:	74 29                	je     80105088 <getcallerpcs+0x56>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010505f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105062:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105069:	8b 45 0c             	mov    0xc(%ebp),%eax
8010506c:	01 c2                	add    %eax,%edx
8010506e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105071:	8b 40 04             	mov    0x4(%eax),%eax
80105074:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80105076:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105079:	8b 00                	mov    (%eax),%eax
8010507b:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
8010507e:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105082:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105086:	7e c2                	jle    8010504a <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105088:	eb 19                	jmp    801050a3 <getcallerpcs+0x71>
    pcs[i] = 0;
8010508a:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010508d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105094:	8b 45 0c             	mov    0xc(%ebp),%eax
80105097:	01 d0                	add    %edx,%eax
80105099:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010509f:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801050a3:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801050a7:	7e e1                	jle    8010508a <getcallerpcs+0x58>
    pcs[i] = 0;
}
801050a9:	c9                   	leave  
801050aa:	c3                   	ret    

801050ab <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801050ab:	55                   	push   %ebp
801050ac:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
801050ae:	8b 45 08             	mov    0x8(%ebp),%eax
801050b1:	8b 00                	mov    (%eax),%eax
801050b3:	85 c0                	test   %eax,%eax
801050b5:	74 17                	je     801050ce <holding+0x23>
801050b7:	8b 45 08             	mov    0x8(%ebp),%eax
801050ba:	8b 50 08             	mov    0x8(%eax),%edx
801050bd:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801050c3:	39 c2                	cmp    %eax,%edx
801050c5:	75 07                	jne    801050ce <holding+0x23>
801050c7:	b8 01 00 00 00       	mov    $0x1,%eax
801050cc:	eb 05                	jmp    801050d3 <holding+0x28>
801050ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
801050d3:	5d                   	pop    %ebp
801050d4:	c3                   	ret    

801050d5 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801050d5:	55                   	push   %ebp
801050d6:	89 e5                	mov    %esp,%ebp
801050d8:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
801050db:	e8 44 fe ff ff       	call   80104f24 <readeflags>
801050e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
801050e3:	e8 4c fe ff ff       	call   80104f34 <cli>
  if(cpu->ncli++ == 0)
801050e8:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801050ef:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
801050f5:	8d 48 01             	lea    0x1(%eax),%ecx
801050f8:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
801050fe:	85 c0                	test   %eax,%eax
80105100:	75 15                	jne    80105117 <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
80105102:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105108:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010510b:	81 e2 00 02 00 00    	and    $0x200,%edx
80105111:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80105117:	c9                   	leave  
80105118:	c3                   	ret    

80105119 <popcli>:

void
popcli(void)
{
80105119:	55                   	push   %ebp
8010511a:	89 e5                	mov    %esp,%ebp
8010511c:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
8010511f:	e8 00 fe ff ff       	call   80104f24 <readeflags>
80105124:	25 00 02 00 00       	and    $0x200,%eax
80105129:	85 c0                	test   %eax,%eax
8010512b:	74 0d                	je     8010513a <popcli+0x21>
    panic("popcli - interruptible");
8010512d:	83 ec 0c             	sub    $0xc,%esp
80105130:	68 ad 88 10 80       	push   $0x801088ad
80105135:	e8 22 b4 ff ff       	call   8010055c <panic>
  if(--cpu->ncli < 0)
8010513a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105140:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80105146:	83 ea 01             	sub    $0x1,%edx
80105149:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
8010514f:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105155:	85 c0                	test   %eax,%eax
80105157:	79 0d                	jns    80105166 <popcli+0x4d>
    panic("popcli");
80105159:	83 ec 0c             	sub    $0xc,%esp
8010515c:	68 c4 88 10 80       	push   $0x801088c4
80105161:	e8 f6 b3 ff ff       	call   8010055c <panic>
  if(cpu->ncli == 0 && cpu->intena)
80105166:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010516c:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105172:	85 c0                	test   %eax,%eax
80105174:	75 15                	jne    8010518b <popcli+0x72>
80105176:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010517c:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80105182:	85 c0                	test   %eax,%eax
80105184:	74 05                	je     8010518b <popcli+0x72>
    sti();
80105186:	e8 af fd ff ff       	call   80104f3a <sti>
}
8010518b:	c9                   	leave  
8010518c:	c3                   	ret    

8010518d <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
8010518d:	55                   	push   %ebp
8010518e:	89 e5                	mov    %esp,%ebp
80105190:	57                   	push   %edi
80105191:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80105192:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105195:	8b 55 10             	mov    0x10(%ebp),%edx
80105198:	8b 45 0c             	mov    0xc(%ebp),%eax
8010519b:	89 cb                	mov    %ecx,%ebx
8010519d:	89 df                	mov    %ebx,%edi
8010519f:	89 d1                	mov    %edx,%ecx
801051a1:	fc                   	cld    
801051a2:	f3 aa                	rep stos %al,%es:(%edi)
801051a4:	89 ca                	mov    %ecx,%edx
801051a6:	89 fb                	mov    %edi,%ebx
801051a8:	89 5d 08             	mov    %ebx,0x8(%ebp)
801051ab:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801051ae:	5b                   	pop    %ebx
801051af:	5f                   	pop    %edi
801051b0:	5d                   	pop    %ebp
801051b1:	c3                   	ret    

801051b2 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
801051b2:	55                   	push   %ebp
801051b3:	89 e5                	mov    %esp,%ebp
801051b5:	57                   	push   %edi
801051b6:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
801051b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
801051ba:	8b 55 10             	mov    0x10(%ebp),%edx
801051bd:	8b 45 0c             	mov    0xc(%ebp),%eax
801051c0:	89 cb                	mov    %ecx,%ebx
801051c2:	89 df                	mov    %ebx,%edi
801051c4:	89 d1                	mov    %edx,%ecx
801051c6:	fc                   	cld    
801051c7:	f3 ab                	rep stos %eax,%es:(%edi)
801051c9:	89 ca                	mov    %ecx,%edx
801051cb:	89 fb                	mov    %edi,%ebx
801051cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
801051d0:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801051d3:	5b                   	pop    %ebx
801051d4:	5f                   	pop    %edi
801051d5:	5d                   	pop    %ebp
801051d6:	c3                   	ret    

801051d7 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801051d7:	55                   	push   %ebp
801051d8:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
801051da:	8b 45 08             	mov    0x8(%ebp),%eax
801051dd:	83 e0 03             	and    $0x3,%eax
801051e0:	85 c0                	test   %eax,%eax
801051e2:	75 43                	jne    80105227 <memset+0x50>
801051e4:	8b 45 10             	mov    0x10(%ebp),%eax
801051e7:	83 e0 03             	and    $0x3,%eax
801051ea:	85 c0                	test   %eax,%eax
801051ec:	75 39                	jne    80105227 <memset+0x50>
    c &= 0xFF;
801051ee:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801051f5:	8b 45 10             	mov    0x10(%ebp),%eax
801051f8:	c1 e8 02             	shr    $0x2,%eax
801051fb:	89 c1                	mov    %eax,%ecx
801051fd:	8b 45 0c             	mov    0xc(%ebp),%eax
80105200:	c1 e0 18             	shl    $0x18,%eax
80105203:	89 c2                	mov    %eax,%edx
80105205:	8b 45 0c             	mov    0xc(%ebp),%eax
80105208:	c1 e0 10             	shl    $0x10,%eax
8010520b:	09 c2                	or     %eax,%edx
8010520d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105210:	c1 e0 08             	shl    $0x8,%eax
80105213:	09 d0                	or     %edx,%eax
80105215:	0b 45 0c             	or     0xc(%ebp),%eax
80105218:	51                   	push   %ecx
80105219:	50                   	push   %eax
8010521a:	ff 75 08             	pushl  0x8(%ebp)
8010521d:	e8 90 ff ff ff       	call   801051b2 <stosl>
80105222:	83 c4 0c             	add    $0xc,%esp
80105225:	eb 12                	jmp    80105239 <memset+0x62>
  } else
    stosb(dst, c, n);
80105227:	8b 45 10             	mov    0x10(%ebp),%eax
8010522a:	50                   	push   %eax
8010522b:	ff 75 0c             	pushl  0xc(%ebp)
8010522e:	ff 75 08             	pushl  0x8(%ebp)
80105231:	e8 57 ff ff ff       	call   8010518d <stosb>
80105236:	83 c4 0c             	add    $0xc,%esp
  return dst;
80105239:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010523c:	c9                   	leave  
8010523d:	c3                   	ret    

8010523e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
8010523e:	55                   	push   %ebp
8010523f:	89 e5                	mov    %esp,%ebp
80105241:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80105244:	8b 45 08             	mov    0x8(%ebp),%eax
80105247:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
8010524a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010524d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80105250:	eb 30                	jmp    80105282 <memcmp+0x44>
    if(*s1 != *s2)
80105252:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105255:	0f b6 10             	movzbl (%eax),%edx
80105258:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010525b:	0f b6 00             	movzbl (%eax),%eax
8010525e:	38 c2                	cmp    %al,%dl
80105260:	74 18                	je     8010527a <memcmp+0x3c>
      return *s1 - *s2;
80105262:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105265:	0f b6 00             	movzbl (%eax),%eax
80105268:	0f b6 d0             	movzbl %al,%edx
8010526b:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010526e:	0f b6 00             	movzbl (%eax),%eax
80105271:	0f b6 c0             	movzbl %al,%eax
80105274:	29 c2                	sub    %eax,%edx
80105276:	89 d0                	mov    %edx,%eax
80105278:	eb 1a                	jmp    80105294 <memcmp+0x56>
    s1++, s2++;
8010527a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010527e:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80105282:	8b 45 10             	mov    0x10(%ebp),%eax
80105285:	8d 50 ff             	lea    -0x1(%eax),%edx
80105288:	89 55 10             	mov    %edx,0x10(%ebp)
8010528b:	85 c0                	test   %eax,%eax
8010528d:	75 c3                	jne    80105252 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010528f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105294:	c9                   	leave  
80105295:	c3                   	ret    

80105296 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105296:	55                   	push   %ebp
80105297:	89 e5                	mov    %esp,%ebp
80105299:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
8010529c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010529f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
801052a2:	8b 45 08             	mov    0x8(%ebp),%eax
801052a5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
801052a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052ab:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801052ae:	73 3d                	jae    801052ed <memmove+0x57>
801052b0:	8b 55 fc             	mov    -0x4(%ebp),%edx
801052b3:	8b 45 10             	mov    0x10(%ebp),%eax
801052b6:	01 d0                	add    %edx,%eax
801052b8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801052bb:	76 30                	jbe    801052ed <memmove+0x57>
    s += n;
801052bd:	8b 45 10             	mov    0x10(%ebp),%eax
801052c0:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
801052c3:	8b 45 10             	mov    0x10(%ebp),%eax
801052c6:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
801052c9:	eb 13                	jmp    801052de <memmove+0x48>
      *--d = *--s;
801052cb:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
801052cf:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
801052d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052d6:	0f b6 10             	movzbl (%eax),%edx
801052d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
801052dc:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
801052de:	8b 45 10             	mov    0x10(%ebp),%eax
801052e1:	8d 50 ff             	lea    -0x1(%eax),%edx
801052e4:	89 55 10             	mov    %edx,0x10(%ebp)
801052e7:	85 c0                	test   %eax,%eax
801052e9:	75 e0                	jne    801052cb <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801052eb:	eb 26                	jmp    80105313 <memmove+0x7d>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801052ed:	eb 17                	jmp    80105306 <memmove+0x70>
      *d++ = *s++;
801052ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
801052f2:	8d 50 01             	lea    0x1(%eax),%edx
801052f5:	89 55 f8             	mov    %edx,-0x8(%ebp)
801052f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
801052fb:	8d 4a 01             	lea    0x1(%edx),%ecx
801052fe:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80105301:	0f b6 12             	movzbl (%edx),%edx
80105304:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80105306:	8b 45 10             	mov    0x10(%ebp),%eax
80105309:	8d 50 ff             	lea    -0x1(%eax),%edx
8010530c:	89 55 10             	mov    %edx,0x10(%ebp)
8010530f:	85 c0                	test   %eax,%eax
80105311:	75 dc                	jne    801052ef <memmove+0x59>
      *d++ = *s++;

  return dst;
80105313:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105316:	c9                   	leave  
80105317:	c3                   	ret    

80105318 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105318:	55                   	push   %ebp
80105319:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
8010531b:	ff 75 10             	pushl  0x10(%ebp)
8010531e:	ff 75 0c             	pushl  0xc(%ebp)
80105321:	ff 75 08             	pushl  0x8(%ebp)
80105324:	e8 6d ff ff ff       	call   80105296 <memmove>
80105329:	83 c4 0c             	add    $0xc,%esp
}
8010532c:	c9                   	leave  
8010532d:	c3                   	ret    

8010532e <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
8010532e:	55                   	push   %ebp
8010532f:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80105331:	eb 0c                	jmp    8010533f <strncmp+0x11>
    n--, p++, q++;
80105333:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105337:	83 45 08 01          	addl   $0x1,0x8(%ebp)
8010533b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
8010533f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105343:	74 1a                	je     8010535f <strncmp+0x31>
80105345:	8b 45 08             	mov    0x8(%ebp),%eax
80105348:	0f b6 00             	movzbl (%eax),%eax
8010534b:	84 c0                	test   %al,%al
8010534d:	74 10                	je     8010535f <strncmp+0x31>
8010534f:	8b 45 08             	mov    0x8(%ebp),%eax
80105352:	0f b6 10             	movzbl (%eax),%edx
80105355:	8b 45 0c             	mov    0xc(%ebp),%eax
80105358:	0f b6 00             	movzbl (%eax),%eax
8010535b:	38 c2                	cmp    %al,%dl
8010535d:	74 d4                	je     80105333 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
8010535f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105363:	75 07                	jne    8010536c <strncmp+0x3e>
    return 0;
80105365:	b8 00 00 00 00       	mov    $0x0,%eax
8010536a:	eb 16                	jmp    80105382 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
8010536c:	8b 45 08             	mov    0x8(%ebp),%eax
8010536f:	0f b6 00             	movzbl (%eax),%eax
80105372:	0f b6 d0             	movzbl %al,%edx
80105375:	8b 45 0c             	mov    0xc(%ebp),%eax
80105378:	0f b6 00             	movzbl (%eax),%eax
8010537b:	0f b6 c0             	movzbl %al,%eax
8010537e:	29 c2                	sub    %eax,%edx
80105380:	89 d0                	mov    %edx,%eax
}
80105382:	5d                   	pop    %ebp
80105383:	c3                   	ret    

80105384 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105384:	55                   	push   %ebp
80105385:	89 e5                	mov    %esp,%ebp
80105387:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
8010538a:	8b 45 08             	mov    0x8(%ebp),%eax
8010538d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80105390:	90                   	nop
80105391:	8b 45 10             	mov    0x10(%ebp),%eax
80105394:	8d 50 ff             	lea    -0x1(%eax),%edx
80105397:	89 55 10             	mov    %edx,0x10(%ebp)
8010539a:	85 c0                	test   %eax,%eax
8010539c:	7e 1e                	jle    801053bc <strncpy+0x38>
8010539e:	8b 45 08             	mov    0x8(%ebp),%eax
801053a1:	8d 50 01             	lea    0x1(%eax),%edx
801053a4:	89 55 08             	mov    %edx,0x8(%ebp)
801053a7:	8b 55 0c             	mov    0xc(%ebp),%edx
801053aa:	8d 4a 01             	lea    0x1(%edx),%ecx
801053ad:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801053b0:	0f b6 12             	movzbl (%edx),%edx
801053b3:	88 10                	mov    %dl,(%eax)
801053b5:	0f b6 00             	movzbl (%eax),%eax
801053b8:	84 c0                	test   %al,%al
801053ba:	75 d5                	jne    80105391 <strncpy+0xd>
    ;
  while(n-- > 0)
801053bc:	eb 0c                	jmp    801053ca <strncpy+0x46>
    *s++ = 0;
801053be:	8b 45 08             	mov    0x8(%ebp),%eax
801053c1:	8d 50 01             	lea    0x1(%eax),%edx
801053c4:	89 55 08             	mov    %edx,0x8(%ebp)
801053c7:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
801053ca:	8b 45 10             	mov    0x10(%ebp),%eax
801053cd:	8d 50 ff             	lea    -0x1(%eax),%edx
801053d0:	89 55 10             	mov    %edx,0x10(%ebp)
801053d3:	85 c0                	test   %eax,%eax
801053d5:	7f e7                	jg     801053be <strncpy+0x3a>
    *s++ = 0;
  return os;
801053d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801053da:	c9                   	leave  
801053db:	c3                   	ret    

801053dc <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801053dc:	55                   	push   %ebp
801053dd:	89 e5                	mov    %esp,%ebp
801053df:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801053e2:	8b 45 08             	mov    0x8(%ebp),%eax
801053e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
801053e8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801053ec:	7f 05                	jg     801053f3 <safestrcpy+0x17>
    return os;
801053ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
801053f1:	eb 31                	jmp    80105424 <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
801053f3:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801053f7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801053fb:	7e 1e                	jle    8010541b <safestrcpy+0x3f>
801053fd:	8b 45 08             	mov    0x8(%ebp),%eax
80105400:	8d 50 01             	lea    0x1(%eax),%edx
80105403:	89 55 08             	mov    %edx,0x8(%ebp)
80105406:	8b 55 0c             	mov    0xc(%ebp),%edx
80105409:	8d 4a 01             	lea    0x1(%edx),%ecx
8010540c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
8010540f:	0f b6 12             	movzbl (%edx),%edx
80105412:	88 10                	mov    %dl,(%eax)
80105414:	0f b6 00             	movzbl (%eax),%eax
80105417:	84 c0                	test   %al,%al
80105419:	75 d8                	jne    801053f3 <safestrcpy+0x17>
    ;
  *s = 0;
8010541b:	8b 45 08             	mov    0x8(%ebp),%eax
8010541e:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80105421:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105424:	c9                   	leave  
80105425:	c3                   	ret    

80105426 <strlen>:

int
strlen(const char *s)
{
80105426:	55                   	push   %ebp
80105427:	89 e5                	mov    %esp,%ebp
80105429:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
8010542c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105433:	eb 04                	jmp    80105439 <strlen+0x13>
80105435:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105439:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010543c:	8b 45 08             	mov    0x8(%ebp),%eax
8010543f:	01 d0                	add    %edx,%eax
80105441:	0f b6 00             	movzbl (%eax),%eax
80105444:	84 c0                	test   %al,%al
80105446:	75 ed                	jne    80105435 <strlen+0xf>
    ;
  return n;
80105448:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010544b:	c9                   	leave  
8010544c:	c3                   	ret    

8010544d <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010544d:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105451:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80105455:	55                   	push   %ebp
  pushl %ebx
80105456:	53                   	push   %ebx
  pushl %esi
80105457:	56                   	push   %esi
  pushl %edi
80105458:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105459:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
8010545b:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010545d:	5f                   	pop    %edi
  popl %esi
8010545e:	5e                   	pop    %esi
  popl %ebx
8010545f:	5b                   	pop    %ebx
  popl %ebp
80105460:	5d                   	pop    %ebp
  ret
80105461:	c3                   	ret    

80105462 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105462:	55                   	push   %ebp
80105463:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80105465:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010546b:	8b 00                	mov    (%eax),%eax
8010546d:	3b 45 08             	cmp    0x8(%ebp),%eax
80105470:	76 12                	jbe    80105484 <fetchint+0x22>
80105472:	8b 45 08             	mov    0x8(%ebp),%eax
80105475:	8d 50 04             	lea    0x4(%eax),%edx
80105478:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010547e:	8b 00                	mov    (%eax),%eax
80105480:	39 c2                	cmp    %eax,%edx
80105482:	76 07                	jbe    8010548b <fetchint+0x29>
    return -1;
80105484:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105489:	eb 0f                	jmp    8010549a <fetchint+0x38>
  *ip = *(int*)(addr);
8010548b:	8b 45 08             	mov    0x8(%ebp),%eax
8010548e:	8b 10                	mov    (%eax),%edx
80105490:	8b 45 0c             	mov    0xc(%ebp),%eax
80105493:	89 10                	mov    %edx,(%eax)
  return 0;
80105495:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010549a:	5d                   	pop    %ebp
8010549b:	c3                   	ret    

8010549c <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
8010549c:	55                   	push   %ebp
8010549d:	89 e5                	mov    %esp,%ebp
8010549f:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
801054a2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054a8:	8b 00                	mov    (%eax),%eax
801054aa:	3b 45 08             	cmp    0x8(%ebp),%eax
801054ad:	77 07                	ja     801054b6 <fetchstr+0x1a>
    return -1;
801054af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054b4:	eb 46                	jmp    801054fc <fetchstr+0x60>
  *pp = (char*)addr;
801054b6:	8b 55 08             	mov    0x8(%ebp),%edx
801054b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801054bc:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
801054be:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054c4:	8b 00                	mov    (%eax),%eax
801054c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
801054c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801054cc:	8b 00                	mov    (%eax),%eax
801054ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
801054d1:	eb 1c                	jmp    801054ef <fetchstr+0x53>
    if(*s == 0)
801054d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801054d6:	0f b6 00             	movzbl (%eax),%eax
801054d9:	84 c0                	test   %al,%al
801054db:	75 0e                	jne    801054eb <fetchstr+0x4f>
      return s - *pp;
801054dd:	8b 55 fc             	mov    -0x4(%ebp),%edx
801054e0:	8b 45 0c             	mov    0xc(%ebp),%eax
801054e3:	8b 00                	mov    (%eax),%eax
801054e5:	29 c2                	sub    %eax,%edx
801054e7:	89 d0                	mov    %edx,%eax
801054e9:	eb 11                	jmp    801054fc <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
801054eb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801054ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
801054f2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801054f5:	72 dc                	jb     801054d3 <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
801054f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054fc:	c9                   	leave  
801054fd:	c3                   	ret    

801054fe <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801054fe:	55                   	push   %ebp
801054ff:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80105501:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105507:	8b 40 18             	mov    0x18(%eax),%eax
8010550a:	8b 40 44             	mov    0x44(%eax),%eax
8010550d:	8b 55 08             	mov    0x8(%ebp),%edx
80105510:	c1 e2 02             	shl    $0x2,%edx
80105513:	01 d0                	add    %edx,%eax
80105515:	83 c0 04             	add    $0x4,%eax
80105518:	ff 75 0c             	pushl  0xc(%ebp)
8010551b:	50                   	push   %eax
8010551c:	e8 41 ff ff ff       	call   80105462 <fetchint>
80105521:	83 c4 08             	add    $0x8,%esp
}
80105524:	c9                   	leave  
80105525:	c3                   	ret    

80105526 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105526:	55                   	push   %ebp
80105527:	89 e5                	mov    %esp,%ebp
80105529:	83 ec 10             	sub    $0x10,%esp
  int i;
  
  if(argint(n, &i) < 0)
8010552c:	8d 45 fc             	lea    -0x4(%ebp),%eax
8010552f:	50                   	push   %eax
80105530:	ff 75 08             	pushl  0x8(%ebp)
80105533:	e8 c6 ff ff ff       	call   801054fe <argint>
80105538:	83 c4 08             	add    $0x8,%esp
8010553b:	85 c0                	test   %eax,%eax
8010553d:	79 07                	jns    80105546 <argptr+0x20>
    return -1;
8010553f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105544:	eb 3d                	jmp    80105583 <argptr+0x5d>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
80105546:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105549:	89 c2                	mov    %eax,%edx
8010554b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105551:	8b 00                	mov    (%eax),%eax
80105553:	39 c2                	cmp    %eax,%edx
80105555:	73 16                	jae    8010556d <argptr+0x47>
80105557:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010555a:	89 c2                	mov    %eax,%edx
8010555c:	8b 45 10             	mov    0x10(%ebp),%eax
8010555f:	01 c2                	add    %eax,%edx
80105561:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105567:	8b 00                	mov    (%eax),%eax
80105569:	39 c2                	cmp    %eax,%edx
8010556b:	76 07                	jbe    80105574 <argptr+0x4e>
    return -1;
8010556d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105572:	eb 0f                	jmp    80105583 <argptr+0x5d>
  *pp = (char*)i;
80105574:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105577:	89 c2                	mov    %eax,%edx
80105579:	8b 45 0c             	mov    0xc(%ebp),%eax
8010557c:	89 10                	mov    %edx,(%eax)
  return 0;
8010557e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105583:	c9                   	leave  
80105584:	c3                   	ret    

80105585 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105585:	55                   	push   %ebp
80105586:	89 e5                	mov    %esp,%ebp
80105588:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
8010558b:	8d 45 fc             	lea    -0x4(%ebp),%eax
8010558e:	50                   	push   %eax
8010558f:	ff 75 08             	pushl  0x8(%ebp)
80105592:	e8 67 ff ff ff       	call   801054fe <argint>
80105597:	83 c4 08             	add    $0x8,%esp
8010559a:	85 c0                	test   %eax,%eax
8010559c:	79 07                	jns    801055a5 <argstr+0x20>
    return -1;
8010559e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055a3:	eb 0f                	jmp    801055b4 <argstr+0x2f>
  return fetchstr(addr, pp);
801055a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055a8:	ff 75 0c             	pushl  0xc(%ebp)
801055ab:	50                   	push   %eax
801055ac:	e8 eb fe ff ff       	call   8010549c <fetchstr>
801055b1:	83 c4 08             	add    $0x8,%esp
}
801055b4:	c9                   	leave  
801055b5:	c3                   	ret    

801055b6 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
801055b6:	55                   	push   %ebp
801055b7:	89 e5                	mov    %esp,%ebp
801055b9:	53                   	push   %ebx
801055ba:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
801055bd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055c3:	8b 40 18             	mov    0x18(%eax),%eax
801055c6:	8b 40 1c             	mov    0x1c(%eax),%eax
801055c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801055cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801055d0:	7e 30                	jle    80105602 <syscall+0x4c>
801055d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055d5:	83 f8 15             	cmp    $0x15,%eax
801055d8:	77 28                	ja     80105602 <syscall+0x4c>
801055da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055dd:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
801055e4:	85 c0                	test   %eax,%eax
801055e6:	74 1a                	je     80105602 <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
801055e8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055ee:	8b 58 18             	mov    0x18(%eax),%ebx
801055f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055f4:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
801055fb:	ff d0                	call   *%eax
801055fd:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105600:	eb 34                	jmp    80105636 <syscall+0x80>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80105602:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105608:	8d 50 6c             	lea    0x6c(%eax),%edx
8010560b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105611:	8b 40 10             	mov    0x10(%eax),%eax
80105614:	ff 75 f4             	pushl  -0xc(%ebp)
80105617:	52                   	push   %edx
80105618:	50                   	push   %eax
80105619:	68 cb 88 10 80       	push   $0x801088cb
8010561e:	e8 9c ad ff ff       	call   801003bf <cprintf>
80105623:	83 c4 10             	add    $0x10,%esp
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80105626:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010562c:	8b 40 18             	mov    0x18(%eax),%eax
8010562f:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105636:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105639:	c9                   	leave  
8010563a:	c3                   	ret    

8010563b <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
8010563b:	55                   	push   %ebp
8010563c:	89 e5                	mov    %esp,%ebp
8010563e:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105641:	83 ec 08             	sub    $0x8,%esp
80105644:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105647:	50                   	push   %eax
80105648:	ff 75 08             	pushl  0x8(%ebp)
8010564b:	e8 ae fe ff ff       	call   801054fe <argint>
80105650:	83 c4 10             	add    $0x10,%esp
80105653:	85 c0                	test   %eax,%eax
80105655:	79 07                	jns    8010565e <argfd+0x23>
    return -1;
80105657:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010565c:	eb 50                	jmp    801056ae <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
8010565e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105661:	85 c0                	test   %eax,%eax
80105663:	78 21                	js     80105686 <argfd+0x4b>
80105665:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105668:	83 f8 0f             	cmp    $0xf,%eax
8010566b:	7f 19                	jg     80105686 <argfd+0x4b>
8010566d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105673:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105676:	83 c2 08             	add    $0x8,%edx
80105679:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010567d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105680:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105684:	75 07                	jne    8010568d <argfd+0x52>
    return -1;
80105686:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010568b:	eb 21                	jmp    801056ae <argfd+0x73>
  if(pfd)
8010568d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105691:	74 08                	je     8010569b <argfd+0x60>
    *pfd = fd;
80105693:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105696:	8b 45 0c             	mov    0xc(%ebp),%eax
80105699:	89 10                	mov    %edx,(%eax)
  if(pf)
8010569b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010569f:	74 08                	je     801056a9 <argfd+0x6e>
    *pf = f;
801056a1:	8b 45 10             	mov    0x10(%ebp),%eax
801056a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801056a7:	89 10                	mov    %edx,(%eax)
  return 0;
801056a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801056ae:	c9                   	leave  
801056af:	c3                   	ret    

801056b0 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801056b0:	55                   	push   %ebp
801056b1:	89 e5                	mov    %esp,%ebp
801056b3:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801056b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801056bd:	eb 30                	jmp    801056ef <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
801056bf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056c5:	8b 55 fc             	mov    -0x4(%ebp),%edx
801056c8:	83 c2 08             	add    $0x8,%edx
801056cb:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801056cf:	85 c0                	test   %eax,%eax
801056d1:	75 18                	jne    801056eb <fdalloc+0x3b>
      proc->ofile[fd] = f;
801056d3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056d9:	8b 55 fc             	mov    -0x4(%ebp),%edx
801056dc:	8d 4a 08             	lea    0x8(%edx),%ecx
801056df:	8b 55 08             	mov    0x8(%ebp),%edx
801056e2:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
801056e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801056e9:	eb 0f                	jmp    801056fa <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801056eb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801056ef:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
801056f3:	7e ca                	jle    801056bf <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
801056f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056fa:	c9                   	leave  
801056fb:	c3                   	ret    

801056fc <sys_dup>:

int
sys_dup(void)
{
801056fc:	55                   	push   %ebp
801056fd:	89 e5                	mov    %esp,%ebp
801056ff:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80105702:	83 ec 04             	sub    $0x4,%esp
80105705:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105708:	50                   	push   %eax
80105709:	6a 00                	push   $0x0
8010570b:	6a 00                	push   $0x0
8010570d:	e8 29 ff ff ff       	call   8010563b <argfd>
80105712:	83 c4 10             	add    $0x10,%esp
80105715:	85 c0                	test   %eax,%eax
80105717:	79 07                	jns    80105720 <sys_dup+0x24>
    return -1;
80105719:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010571e:	eb 31                	jmp    80105751 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105720:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105723:	83 ec 0c             	sub    $0xc,%esp
80105726:	50                   	push   %eax
80105727:	e8 84 ff ff ff       	call   801056b0 <fdalloc>
8010572c:	83 c4 10             	add    $0x10,%esp
8010572f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105732:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105736:	79 07                	jns    8010573f <sys_dup+0x43>
    return -1;
80105738:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010573d:	eb 12                	jmp    80105751 <sys_dup+0x55>
  filedup(f);
8010573f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105742:	83 ec 0c             	sub    $0xc,%esp
80105745:	50                   	push   %eax
80105746:	e8 71 b8 ff ff       	call   80100fbc <filedup>
8010574b:	83 c4 10             	add    $0x10,%esp
  return fd;
8010574e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105751:	c9                   	leave  
80105752:	c3                   	ret    

80105753 <sys_read>:

int
sys_read(void)
{
80105753:	55                   	push   %ebp
80105754:	89 e5                	mov    %esp,%ebp
80105756:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105759:	83 ec 04             	sub    $0x4,%esp
8010575c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010575f:	50                   	push   %eax
80105760:	6a 00                	push   $0x0
80105762:	6a 00                	push   $0x0
80105764:	e8 d2 fe ff ff       	call   8010563b <argfd>
80105769:	83 c4 10             	add    $0x10,%esp
8010576c:	85 c0                	test   %eax,%eax
8010576e:	78 2e                	js     8010579e <sys_read+0x4b>
80105770:	83 ec 08             	sub    $0x8,%esp
80105773:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105776:	50                   	push   %eax
80105777:	6a 02                	push   $0x2
80105779:	e8 80 fd ff ff       	call   801054fe <argint>
8010577e:	83 c4 10             	add    $0x10,%esp
80105781:	85 c0                	test   %eax,%eax
80105783:	78 19                	js     8010579e <sys_read+0x4b>
80105785:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105788:	83 ec 04             	sub    $0x4,%esp
8010578b:	50                   	push   %eax
8010578c:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010578f:	50                   	push   %eax
80105790:	6a 01                	push   $0x1
80105792:	e8 8f fd ff ff       	call   80105526 <argptr>
80105797:	83 c4 10             	add    $0x10,%esp
8010579a:	85 c0                	test   %eax,%eax
8010579c:	79 07                	jns    801057a5 <sys_read+0x52>
    return -1;
8010579e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057a3:	eb 17                	jmp    801057bc <sys_read+0x69>
  return fileread(f, p, n);
801057a5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801057a8:	8b 55 ec             	mov    -0x14(%ebp),%edx
801057ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057ae:	83 ec 04             	sub    $0x4,%esp
801057b1:	51                   	push   %ecx
801057b2:	52                   	push   %edx
801057b3:	50                   	push   %eax
801057b4:	e8 93 b9 ff ff       	call   8010114c <fileread>
801057b9:	83 c4 10             	add    $0x10,%esp
}
801057bc:	c9                   	leave  
801057bd:	c3                   	ret    

801057be <sys_write>:

int
sys_write(void)
{
801057be:	55                   	push   %ebp
801057bf:	89 e5                	mov    %esp,%ebp
801057c1:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801057c4:	83 ec 04             	sub    $0x4,%esp
801057c7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057ca:	50                   	push   %eax
801057cb:	6a 00                	push   $0x0
801057cd:	6a 00                	push   $0x0
801057cf:	e8 67 fe ff ff       	call   8010563b <argfd>
801057d4:	83 c4 10             	add    $0x10,%esp
801057d7:	85 c0                	test   %eax,%eax
801057d9:	78 2e                	js     80105809 <sys_write+0x4b>
801057db:	83 ec 08             	sub    $0x8,%esp
801057de:	8d 45 f0             	lea    -0x10(%ebp),%eax
801057e1:	50                   	push   %eax
801057e2:	6a 02                	push   $0x2
801057e4:	e8 15 fd ff ff       	call   801054fe <argint>
801057e9:	83 c4 10             	add    $0x10,%esp
801057ec:	85 c0                	test   %eax,%eax
801057ee:	78 19                	js     80105809 <sys_write+0x4b>
801057f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057f3:	83 ec 04             	sub    $0x4,%esp
801057f6:	50                   	push   %eax
801057f7:	8d 45 ec             	lea    -0x14(%ebp),%eax
801057fa:	50                   	push   %eax
801057fb:	6a 01                	push   $0x1
801057fd:	e8 24 fd ff ff       	call   80105526 <argptr>
80105802:	83 c4 10             	add    $0x10,%esp
80105805:	85 c0                	test   %eax,%eax
80105807:	79 07                	jns    80105810 <sys_write+0x52>
    return -1;
80105809:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010580e:	eb 17                	jmp    80105827 <sys_write+0x69>
  return filewrite(f, p, n);
80105810:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105813:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105816:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105819:	83 ec 04             	sub    $0x4,%esp
8010581c:	51                   	push   %ecx
8010581d:	52                   	push   %edx
8010581e:	50                   	push   %eax
8010581f:	e8 e0 b9 ff ff       	call   80101204 <filewrite>
80105824:	83 c4 10             	add    $0x10,%esp
}
80105827:	c9                   	leave  
80105828:	c3                   	ret    

80105829 <sys_close>:

int
sys_close(void)
{
80105829:	55                   	push   %ebp
8010582a:	89 e5                	mov    %esp,%ebp
8010582c:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
8010582f:	83 ec 04             	sub    $0x4,%esp
80105832:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105835:	50                   	push   %eax
80105836:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105839:	50                   	push   %eax
8010583a:	6a 00                	push   $0x0
8010583c:	e8 fa fd ff ff       	call   8010563b <argfd>
80105841:	83 c4 10             	add    $0x10,%esp
80105844:	85 c0                	test   %eax,%eax
80105846:	79 07                	jns    8010584f <sys_close+0x26>
    return -1;
80105848:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010584d:	eb 28                	jmp    80105877 <sys_close+0x4e>
  proc->ofile[fd] = 0;
8010584f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105855:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105858:	83 c2 08             	add    $0x8,%edx
8010585b:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105862:	00 
  fileclose(f);
80105863:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105866:	83 ec 0c             	sub    $0xc,%esp
80105869:	50                   	push   %eax
8010586a:	e8 9e b7 ff ff       	call   8010100d <fileclose>
8010586f:	83 c4 10             	add    $0x10,%esp
  return 0;
80105872:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105877:	c9                   	leave  
80105878:	c3                   	ret    

80105879 <sys_fstat>:

int
sys_fstat(void)
{
80105879:	55                   	push   %ebp
8010587a:	89 e5                	mov    %esp,%ebp
8010587c:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010587f:	83 ec 04             	sub    $0x4,%esp
80105882:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105885:	50                   	push   %eax
80105886:	6a 00                	push   $0x0
80105888:	6a 00                	push   $0x0
8010588a:	e8 ac fd ff ff       	call   8010563b <argfd>
8010588f:	83 c4 10             	add    $0x10,%esp
80105892:	85 c0                	test   %eax,%eax
80105894:	78 17                	js     801058ad <sys_fstat+0x34>
80105896:	83 ec 04             	sub    $0x4,%esp
80105899:	6a 14                	push   $0x14
8010589b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010589e:	50                   	push   %eax
8010589f:	6a 01                	push   $0x1
801058a1:	e8 80 fc ff ff       	call   80105526 <argptr>
801058a6:	83 c4 10             	add    $0x10,%esp
801058a9:	85 c0                	test   %eax,%eax
801058ab:	79 07                	jns    801058b4 <sys_fstat+0x3b>
    return -1;
801058ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058b2:	eb 13                	jmp    801058c7 <sys_fstat+0x4e>
  return filestat(f, st);
801058b4:	8b 55 f0             	mov    -0x10(%ebp),%edx
801058b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058ba:	83 ec 08             	sub    $0x8,%esp
801058bd:	52                   	push   %edx
801058be:	50                   	push   %eax
801058bf:	e8 31 b8 ff ff       	call   801010f5 <filestat>
801058c4:	83 c4 10             	add    $0x10,%esp
}
801058c7:	c9                   	leave  
801058c8:	c3                   	ret    

801058c9 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801058c9:	55                   	push   %ebp
801058ca:	89 e5                	mov    %esp,%ebp
801058cc:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801058cf:	83 ec 08             	sub    $0x8,%esp
801058d2:	8d 45 d8             	lea    -0x28(%ebp),%eax
801058d5:	50                   	push   %eax
801058d6:	6a 00                	push   $0x0
801058d8:	e8 a8 fc ff ff       	call   80105585 <argstr>
801058dd:	83 c4 10             	add    $0x10,%esp
801058e0:	85 c0                	test   %eax,%eax
801058e2:	78 15                	js     801058f9 <sys_link+0x30>
801058e4:	83 ec 08             	sub    $0x8,%esp
801058e7:	8d 45 dc             	lea    -0x24(%ebp),%eax
801058ea:	50                   	push   %eax
801058eb:	6a 01                	push   $0x1
801058ed:	e8 93 fc ff ff       	call   80105585 <argstr>
801058f2:	83 c4 10             	add    $0x10,%esp
801058f5:	85 c0                	test   %eax,%eax
801058f7:	79 0a                	jns    80105903 <sys_link+0x3a>
    return -1;
801058f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058fe:	e9 69 01 00 00       	jmp    80105a6c <sys_link+0x1a3>

  begin_op();
80105903:	e8 da db ff ff       	call   801034e2 <begin_op>
  if((ip = namei(old)) == 0){
80105908:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010590b:	83 ec 0c             	sub    $0xc,%esp
8010590e:	50                   	push   %eax
8010590f:	e8 c5 cb ff ff       	call   801024d9 <namei>
80105914:	83 c4 10             	add    $0x10,%esp
80105917:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010591a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010591e:	75 0f                	jne    8010592f <sys_link+0x66>
    end_op();
80105920:	e8 4b dc ff ff       	call   80103570 <end_op>
    return -1;
80105925:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010592a:	e9 3d 01 00 00       	jmp    80105a6c <sys_link+0x1a3>
  }

  ilock(ip);
8010592f:	83 ec 0c             	sub    $0xc,%esp
80105932:	ff 75 f4             	pushl  -0xc(%ebp)
80105935:	e8 e4 bf ff ff       	call   8010191e <ilock>
8010593a:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
8010593d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105940:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105944:	66 83 f8 01          	cmp    $0x1,%ax
80105948:	75 1d                	jne    80105967 <sys_link+0x9e>
    iunlockput(ip);
8010594a:	83 ec 0c             	sub    $0xc,%esp
8010594d:	ff 75 f4             	pushl  -0xc(%ebp)
80105950:	e8 86 c2 ff ff       	call   80101bdb <iunlockput>
80105955:	83 c4 10             	add    $0x10,%esp
    end_op();
80105958:	e8 13 dc ff ff       	call   80103570 <end_op>
    return -1;
8010595d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105962:	e9 05 01 00 00       	jmp    80105a6c <sys_link+0x1a3>
  }

  ip->nlink++;
80105967:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010596a:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010596e:	83 c0 01             	add    $0x1,%eax
80105971:	89 c2                	mov    %eax,%edx
80105973:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105976:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
8010597a:	83 ec 0c             	sub    $0xc,%esp
8010597d:	ff 75 f4             	pushl  -0xc(%ebp)
80105980:	e8 c0 bd ff ff       	call   80101745 <iupdate>
80105985:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80105988:	83 ec 0c             	sub    $0xc,%esp
8010598b:	ff 75 f4             	pushl  -0xc(%ebp)
8010598e:	e8 e8 c0 ff ff       	call   80101a7b <iunlock>
80105993:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80105996:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105999:	83 ec 08             	sub    $0x8,%esp
8010599c:	8d 55 e2             	lea    -0x1e(%ebp),%edx
8010599f:	52                   	push   %edx
801059a0:	50                   	push   %eax
801059a1:	e8 4f cb ff ff       	call   801024f5 <nameiparent>
801059a6:	83 c4 10             	add    $0x10,%esp
801059a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
801059ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801059b0:	75 02                	jne    801059b4 <sys_link+0xeb>
    goto bad;
801059b2:	eb 71                	jmp    80105a25 <sys_link+0x15c>
  ilock(dp);
801059b4:	83 ec 0c             	sub    $0xc,%esp
801059b7:	ff 75 f0             	pushl  -0x10(%ebp)
801059ba:	e8 5f bf ff ff       	call   8010191e <ilock>
801059bf:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801059c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059c5:	8b 10                	mov    (%eax),%edx
801059c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059ca:	8b 00                	mov    (%eax),%eax
801059cc:	39 c2                	cmp    %eax,%edx
801059ce:	75 1d                	jne    801059ed <sys_link+0x124>
801059d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059d3:	8b 40 04             	mov    0x4(%eax),%eax
801059d6:	83 ec 04             	sub    $0x4,%esp
801059d9:	50                   	push   %eax
801059da:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801059dd:	50                   	push   %eax
801059de:	ff 75 f0             	pushl  -0x10(%ebp)
801059e1:	e8 5b c8 ff ff       	call   80102241 <dirlink>
801059e6:	83 c4 10             	add    $0x10,%esp
801059e9:	85 c0                	test   %eax,%eax
801059eb:	79 10                	jns    801059fd <sys_link+0x134>
    iunlockput(dp);
801059ed:	83 ec 0c             	sub    $0xc,%esp
801059f0:	ff 75 f0             	pushl  -0x10(%ebp)
801059f3:	e8 e3 c1 ff ff       	call   80101bdb <iunlockput>
801059f8:	83 c4 10             	add    $0x10,%esp
    goto bad;
801059fb:	eb 28                	jmp    80105a25 <sys_link+0x15c>
  }
  iunlockput(dp);
801059fd:	83 ec 0c             	sub    $0xc,%esp
80105a00:	ff 75 f0             	pushl  -0x10(%ebp)
80105a03:	e8 d3 c1 ff ff       	call   80101bdb <iunlockput>
80105a08:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80105a0b:	83 ec 0c             	sub    $0xc,%esp
80105a0e:	ff 75 f4             	pushl  -0xc(%ebp)
80105a11:	e8 d6 c0 ff ff       	call   80101aec <iput>
80105a16:	83 c4 10             	add    $0x10,%esp

  end_op();
80105a19:	e8 52 db ff ff       	call   80103570 <end_op>

  return 0;
80105a1e:	b8 00 00 00 00       	mov    $0x0,%eax
80105a23:	eb 47                	jmp    80105a6c <sys_link+0x1a3>

bad:
  ilock(ip);
80105a25:	83 ec 0c             	sub    $0xc,%esp
80105a28:	ff 75 f4             	pushl  -0xc(%ebp)
80105a2b:	e8 ee be ff ff       	call   8010191e <ilock>
80105a30:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80105a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a36:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105a3a:	83 e8 01             	sub    $0x1,%eax
80105a3d:	89 c2                	mov    %eax,%edx
80105a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a42:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105a46:	83 ec 0c             	sub    $0xc,%esp
80105a49:	ff 75 f4             	pushl  -0xc(%ebp)
80105a4c:	e8 f4 bc ff ff       	call   80101745 <iupdate>
80105a51:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105a54:	83 ec 0c             	sub    $0xc,%esp
80105a57:	ff 75 f4             	pushl  -0xc(%ebp)
80105a5a:	e8 7c c1 ff ff       	call   80101bdb <iunlockput>
80105a5f:	83 c4 10             	add    $0x10,%esp
  end_op();
80105a62:	e8 09 db ff ff       	call   80103570 <end_op>
  return -1;
80105a67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a6c:	c9                   	leave  
80105a6d:	c3                   	ret    

80105a6e <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105a6e:	55                   	push   %ebp
80105a6f:	89 e5                	mov    %esp,%ebp
80105a71:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105a74:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105a7b:	eb 40                	jmp    80105abd <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a80:	6a 10                	push   $0x10
80105a82:	50                   	push   %eax
80105a83:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105a86:	50                   	push   %eax
80105a87:	ff 75 08             	pushl  0x8(%ebp)
80105a8a:	e8 f7 c3 ff ff       	call   80101e86 <readi>
80105a8f:	83 c4 10             	add    $0x10,%esp
80105a92:	83 f8 10             	cmp    $0x10,%eax
80105a95:	74 0d                	je     80105aa4 <isdirempty+0x36>
      panic("isdirempty: readi");
80105a97:	83 ec 0c             	sub    $0xc,%esp
80105a9a:	68 e7 88 10 80       	push   $0x801088e7
80105a9f:	e8 b8 aa ff ff       	call   8010055c <panic>
    if(de.inum != 0)
80105aa4:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105aa8:	66 85 c0             	test   %ax,%ax
80105aab:	74 07                	je     80105ab4 <isdirempty+0x46>
      return 0;
80105aad:	b8 00 00 00 00       	mov    $0x0,%eax
80105ab2:	eb 1b                	jmp    80105acf <isdirempty+0x61>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ab7:	83 c0 10             	add    $0x10,%eax
80105aba:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105abd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105ac0:	8b 45 08             	mov    0x8(%ebp),%eax
80105ac3:	8b 40 18             	mov    0x18(%eax),%eax
80105ac6:	39 c2                	cmp    %eax,%edx
80105ac8:	72 b3                	jb     80105a7d <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80105aca:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105acf:	c9                   	leave  
80105ad0:	c3                   	ret    

80105ad1 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105ad1:	55                   	push   %ebp
80105ad2:	89 e5                	mov    %esp,%ebp
80105ad4:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105ad7:	83 ec 08             	sub    $0x8,%esp
80105ada:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105add:	50                   	push   %eax
80105ade:	6a 00                	push   $0x0
80105ae0:	e8 a0 fa ff ff       	call   80105585 <argstr>
80105ae5:	83 c4 10             	add    $0x10,%esp
80105ae8:	85 c0                	test   %eax,%eax
80105aea:	79 0a                	jns    80105af6 <sys_unlink+0x25>
    return -1;
80105aec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105af1:	e9 bc 01 00 00       	jmp    80105cb2 <sys_unlink+0x1e1>

  begin_op();
80105af6:	e8 e7 d9 ff ff       	call   801034e2 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105afb:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105afe:	83 ec 08             	sub    $0x8,%esp
80105b01:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105b04:	52                   	push   %edx
80105b05:	50                   	push   %eax
80105b06:	e8 ea c9 ff ff       	call   801024f5 <nameiparent>
80105b0b:	83 c4 10             	add    $0x10,%esp
80105b0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105b11:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b15:	75 0f                	jne    80105b26 <sys_unlink+0x55>
    end_op();
80105b17:	e8 54 da ff ff       	call   80103570 <end_op>
    return -1;
80105b1c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b21:	e9 8c 01 00 00       	jmp    80105cb2 <sys_unlink+0x1e1>
  }

  ilock(dp);
80105b26:	83 ec 0c             	sub    $0xc,%esp
80105b29:	ff 75 f4             	pushl  -0xc(%ebp)
80105b2c:	e8 ed bd ff ff       	call   8010191e <ilock>
80105b31:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105b34:	83 ec 08             	sub    $0x8,%esp
80105b37:	68 f9 88 10 80       	push   $0x801088f9
80105b3c:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105b3f:	50                   	push   %eax
80105b40:	e8 26 c6 ff ff       	call   8010216b <namecmp>
80105b45:	83 c4 10             	add    $0x10,%esp
80105b48:	85 c0                	test   %eax,%eax
80105b4a:	0f 84 4a 01 00 00    	je     80105c9a <sys_unlink+0x1c9>
80105b50:	83 ec 08             	sub    $0x8,%esp
80105b53:	68 fb 88 10 80       	push   $0x801088fb
80105b58:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105b5b:	50                   	push   %eax
80105b5c:	e8 0a c6 ff ff       	call   8010216b <namecmp>
80105b61:	83 c4 10             	add    $0x10,%esp
80105b64:	85 c0                	test   %eax,%eax
80105b66:	0f 84 2e 01 00 00    	je     80105c9a <sys_unlink+0x1c9>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105b6c:	83 ec 04             	sub    $0x4,%esp
80105b6f:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105b72:	50                   	push   %eax
80105b73:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105b76:	50                   	push   %eax
80105b77:	ff 75 f4             	pushl  -0xc(%ebp)
80105b7a:	e8 07 c6 ff ff       	call   80102186 <dirlookup>
80105b7f:	83 c4 10             	add    $0x10,%esp
80105b82:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105b85:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105b89:	75 05                	jne    80105b90 <sys_unlink+0xbf>
    goto bad;
80105b8b:	e9 0a 01 00 00       	jmp    80105c9a <sys_unlink+0x1c9>
  ilock(ip);
80105b90:	83 ec 0c             	sub    $0xc,%esp
80105b93:	ff 75 f0             	pushl  -0x10(%ebp)
80105b96:	e8 83 bd ff ff       	call   8010191e <ilock>
80105b9b:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80105b9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ba1:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105ba5:	66 85 c0             	test   %ax,%ax
80105ba8:	7f 0d                	jg     80105bb7 <sys_unlink+0xe6>
    panic("unlink: nlink < 1");
80105baa:	83 ec 0c             	sub    $0xc,%esp
80105bad:	68 fe 88 10 80       	push   $0x801088fe
80105bb2:	e8 a5 a9 ff ff       	call   8010055c <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105bb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bba:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105bbe:	66 83 f8 01          	cmp    $0x1,%ax
80105bc2:	75 25                	jne    80105be9 <sys_unlink+0x118>
80105bc4:	83 ec 0c             	sub    $0xc,%esp
80105bc7:	ff 75 f0             	pushl  -0x10(%ebp)
80105bca:	e8 9f fe ff ff       	call   80105a6e <isdirempty>
80105bcf:	83 c4 10             	add    $0x10,%esp
80105bd2:	85 c0                	test   %eax,%eax
80105bd4:	75 13                	jne    80105be9 <sys_unlink+0x118>
    iunlockput(ip);
80105bd6:	83 ec 0c             	sub    $0xc,%esp
80105bd9:	ff 75 f0             	pushl  -0x10(%ebp)
80105bdc:	e8 fa bf ff ff       	call   80101bdb <iunlockput>
80105be1:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105be4:	e9 b1 00 00 00       	jmp    80105c9a <sys_unlink+0x1c9>
  }

  memset(&de, 0, sizeof(de));
80105be9:	83 ec 04             	sub    $0x4,%esp
80105bec:	6a 10                	push   $0x10
80105bee:	6a 00                	push   $0x0
80105bf0:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105bf3:	50                   	push   %eax
80105bf4:	e8 de f5 ff ff       	call   801051d7 <memset>
80105bf9:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105bfc:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105bff:	6a 10                	push   $0x10
80105c01:	50                   	push   %eax
80105c02:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105c05:	50                   	push   %eax
80105c06:	ff 75 f4             	pushl  -0xc(%ebp)
80105c09:	e8 d2 c3 ff ff       	call   80101fe0 <writei>
80105c0e:	83 c4 10             	add    $0x10,%esp
80105c11:	83 f8 10             	cmp    $0x10,%eax
80105c14:	74 0d                	je     80105c23 <sys_unlink+0x152>
    panic("unlink: writei");
80105c16:	83 ec 0c             	sub    $0xc,%esp
80105c19:	68 10 89 10 80       	push   $0x80108910
80105c1e:	e8 39 a9 ff ff       	call   8010055c <panic>
  if(ip->type == T_DIR){
80105c23:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c26:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105c2a:	66 83 f8 01          	cmp    $0x1,%ax
80105c2e:	75 21                	jne    80105c51 <sys_unlink+0x180>
    dp->nlink--;
80105c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c33:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105c37:	83 e8 01             	sub    $0x1,%eax
80105c3a:	89 c2                	mov    %eax,%edx
80105c3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c3f:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105c43:	83 ec 0c             	sub    $0xc,%esp
80105c46:	ff 75 f4             	pushl  -0xc(%ebp)
80105c49:	e8 f7 ba ff ff       	call   80101745 <iupdate>
80105c4e:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
80105c51:	83 ec 0c             	sub    $0xc,%esp
80105c54:	ff 75 f4             	pushl  -0xc(%ebp)
80105c57:	e8 7f bf ff ff       	call   80101bdb <iunlockput>
80105c5c:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80105c5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c62:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105c66:	83 e8 01             	sub    $0x1,%eax
80105c69:	89 c2                	mov    %eax,%edx
80105c6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c6e:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105c72:	83 ec 0c             	sub    $0xc,%esp
80105c75:	ff 75 f0             	pushl  -0x10(%ebp)
80105c78:	e8 c8 ba ff ff       	call   80101745 <iupdate>
80105c7d:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105c80:	83 ec 0c             	sub    $0xc,%esp
80105c83:	ff 75 f0             	pushl  -0x10(%ebp)
80105c86:	e8 50 bf ff ff       	call   80101bdb <iunlockput>
80105c8b:	83 c4 10             	add    $0x10,%esp

  end_op();
80105c8e:	e8 dd d8 ff ff       	call   80103570 <end_op>

  return 0;
80105c93:	b8 00 00 00 00       	mov    $0x0,%eax
80105c98:	eb 18                	jmp    80105cb2 <sys_unlink+0x1e1>

bad:
  iunlockput(dp);
80105c9a:	83 ec 0c             	sub    $0xc,%esp
80105c9d:	ff 75 f4             	pushl  -0xc(%ebp)
80105ca0:	e8 36 bf ff ff       	call   80101bdb <iunlockput>
80105ca5:	83 c4 10             	add    $0x10,%esp
  end_op();
80105ca8:	e8 c3 d8 ff ff       	call   80103570 <end_op>
  return -1;
80105cad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cb2:	c9                   	leave  
80105cb3:	c3                   	ret    

80105cb4 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105cb4:	55                   	push   %ebp
80105cb5:	89 e5                	mov    %esp,%ebp
80105cb7:	83 ec 38             	sub    $0x38,%esp
80105cba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105cbd:	8b 55 10             	mov    0x10(%ebp),%edx
80105cc0:	8b 45 14             	mov    0x14(%ebp),%eax
80105cc3:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105cc7:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105ccb:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105ccf:	83 ec 08             	sub    $0x8,%esp
80105cd2:	8d 45 de             	lea    -0x22(%ebp),%eax
80105cd5:	50                   	push   %eax
80105cd6:	ff 75 08             	pushl  0x8(%ebp)
80105cd9:	e8 17 c8 ff ff       	call   801024f5 <nameiparent>
80105cde:	83 c4 10             	add    $0x10,%esp
80105ce1:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105ce4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ce8:	75 0a                	jne    80105cf4 <create+0x40>
    return 0;
80105cea:	b8 00 00 00 00       	mov    $0x0,%eax
80105cef:	e9 90 01 00 00       	jmp    80105e84 <create+0x1d0>
  ilock(dp);
80105cf4:	83 ec 0c             	sub    $0xc,%esp
80105cf7:	ff 75 f4             	pushl  -0xc(%ebp)
80105cfa:	e8 1f bc ff ff       	call   8010191e <ilock>
80105cff:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
80105d02:	83 ec 04             	sub    $0x4,%esp
80105d05:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105d08:	50                   	push   %eax
80105d09:	8d 45 de             	lea    -0x22(%ebp),%eax
80105d0c:	50                   	push   %eax
80105d0d:	ff 75 f4             	pushl  -0xc(%ebp)
80105d10:	e8 71 c4 ff ff       	call   80102186 <dirlookup>
80105d15:	83 c4 10             	add    $0x10,%esp
80105d18:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105d1b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105d1f:	74 50                	je     80105d71 <create+0xbd>
    iunlockput(dp);
80105d21:	83 ec 0c             	sub    $0xc,%esp
80105d24:	ff 75 f4             	pushl  -0xc(%ebp)
80105d27:	e8 af be ff ff       	call   80101bdb <iunlockput>
80105d2c:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
80105d2f:	83 ec 0c             	sub    $0xc,%esp
80105d32:	ff 75 f0             	pushl  -0x10(%ebp)
80105d35:	e8 e4 bb ff ff       	call   8010191e <ilock>
80105d3a:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
80105d3d:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105d42:	75 15                	jne    80105d59 <create+0xa5>
80105d44:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d47:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105d4b:	66 83 f8 02          	cmp    $0x2,%ax
80105d4f:	75 08                	jne    80105d59 <create+0xa5>
      return ip;
80105d51:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d54:	e9 2b 01 00 00       	jmp    80105e84 <create+0x1d0>
    iunlockput(ip);
80105d59:	83 ec 0c             	sub    $0xc,%esp
80105d5c:	ff 75 f0             	pushl  -0x10(%ebp)
80105d5f:	e8 77 be ff ff       	call   80101bdb <iunlockput>
80105d64:	83 c4 10             	add    $0x10,%esp
    return 0;
80105d67:	b8 00 00 00 00       	mov    $0x0,%eax
80105d6c:	e9 13 01 00 00       	jmp    80105e84 <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105d71:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d78:	8b 00                	mov    (%eax),%eax
80105d7a:	83 ec 08             	sub    $0x8,%esp
80105d7d:	52                   	push   %edx
80105d7e:	50                   	push   %eax
80105d7f:	e8 eb b8 ff ff       	call   8010166f <ialloc>
80105d84:	83 c4 10             	add    $0x10,%esp
80105d87:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105d8a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105d8e:	75 0d                	jne    80105d9d <create+0xe9>
    panic("create: ialloc");
80105d90:	83 ec 0c             	sub    $0xc,%esp
80105d93:	68 1f 89 10 80       	push   $0x8010891f
80105d98:	e8 bf a7 ff ff       	call   8010055c <panic>

  ilock(ip);
80105d9d:	83 ec 0c             	sub    $0xc,%esp
80105da0:	ff 75 f0             	pushl  -0x10(%ebp)
80105da3:	e8 76 bb ff ff       	call   8010191e <ilock>
80105da8:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80105dab:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dae:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80105db2:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
80105db6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105db9:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80105dbd:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80105dc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dc4:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80105dca:	83 ec 0c             	sub    $0xc,%esp
80105dcd:	ff 75 f0             	pushl  -0x10(%ebp)
80105dd0:	e8 70 b9 ff ff       	call   80101745 <iupdate>
80105dd5:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
80105dd8:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105ddd:	75 6a                	jne    80105e49 <create+0x195>
    dp->nlink++;  // for ".."
80105ddf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105de2:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105de6:	83 c0 01             	add    $0x1,%eax
80105de9:	89 c2                	mov    %eax,%edx
80105deb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dee:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105df2:	83 ec 0c             	sub    $0xc,%esp
80105df5:	ff 75 f4             	pushl  -0xc(%ebp)
80105df8:	e8 48 b9 ff ff       	call   80101745 <iupdate>
80105dfd:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105e00:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e03:	8b 40 04             	mov    0x4(%eax),%eax
80105e06:	83 ec 04             	sub    $0x4,%esp
80105e09:	50                   	push   %eax
80105e0a:	68 f9 88 10 80       	push   $0x801088f9
80105e0f:	ff 75 f0             	pushl  -0x10(%ebp)
80105e12:	e8 2a c4 ff ff       	call   80102241 <dirlink>
80105e17:	83 c4 10             	add    $0x10,%esp
80105e1a:	85 c0                	test   %eax,%eax
80105e1c:	78 1e                	js     80105e3c <create+0x188>
80105e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e21:	8b 40 04             	mov    0x4(%eax),%eax
80105e24:	83 ec 04             	sub    $0x4,%esp
80105e27:	50                   	push   %eax
80105e28:	68 fb 88 10 80       	push   $0x801088fb
80105e2d:	ff 75 f0             	pushl  -0x10(%ebp)
80105e30:	e8 0c c4 ff ff       	call   80102241 <dirlink>
80105e35:	83 c4 10             	add    $0x10,%esp
80105e38:	85 c0                	test   %eax,%eax
80105e3a:	79 0d                	jns    80105e49 <create+0x195>
      panic("create dots");
80105e3c:	83 ec 0c             	sub    $0xc,%esp
80105e3f:	68 2e 89 10 80       	push   $0x8010892e
80105e44:	e8 13 a7 ff ff       	call   8010055c <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105e49:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e4c:	8b 40 04             	mov    0x4(%eax),%eax
80105e4f:	83 ec 04             	sub    $0x4,%esp
80105e52:	50                   	push   %eax
80105e53:	8d 45 de             	lea    -0x22(%ebp),%eax
80105e56:	50                   	push   %eax
80105e57:	ff 75 f4             	pushl  -0xc(%ebp)
80105e5a:	e8 e2 c3 ff ff       	call   80102241 <dirlink>
80105e5f:	83 c4 10             	add    $0x10,%esp
80105e62:	85 c0                	test   %eax,%eax
80105e64:	79 0d                	jns    80105e73 <create+0x1bf>
    panic("create: dirlink");
80105e66:	83 ec 0c             	sub    $0xc,%esp
80105e69:	68 3a 89 10 80       	push   $0x8010893a
80105e6e:	e8 e9 a6 ff ff       	call   8010055c <panic>

  iunlockput(dp);
80105e73:	83 ec 0c             	sub    $0xc,%esp
80105e76:	ff 75 f4             	pushl  -0xc(%ebp)
80105e79:	e8 5d bd ff ff       	call   80101bdb <iunlockput>
80105e7e:	83 c4 10             	add    $0x10,%esp

  return ip;
80105e81:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105e84:	c9                   	leave  
80105e85:	c3                   	ret    

80105e86 <sys_open>:

int
sys_open(void)
{
80105e86:	55                   	push   %ebp
80105e87:	89 e5                	mov    %esp,%ebp
80105e89:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105e8c:	83 ec 08             	sub    $0x8,%esp
80105e8f:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105e92:	50                   	push   %eax
80105e93:	6a 00                	push   $0x0
80105e95:	e8 eb f6 ff ff       	call   80105585 <argstr>
80105e9a:	83 c4 10             	add    $0x10,%esp
80105e9d:	85 c0                	test   %eax,%eax
80105e9f:	78 15                	js     80105eb6 <sys_open+0x30>
80105ea1:	83 ec 08             	sub    $0x8,%esp
80105ea4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105ea7:	50                   	push   %eax
80105ea8:	6a 01                	push   $0x1
80105eaa:	e8 4f f6 ff ff       	call   801054fe <argint>
80105eaf:	83 c4 10             	add    $0x10,%esp
80105eb2:	85 c0                	test   %eax,%eax
80105eb4:	79 0a                	jns    80105ec0 <sys_open+0x3a>
    return -1;
80105eb6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ebb:	e9 61 01 00 00       	jmp    80106021 <sys_open+0x19b>

  begin_op();
80105ec0:	e8 1d d6 ff ff       	call   801034e2 <begin_op>

  if(omode & O_CREATE){
80105ec5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105ec8:	25 00 02 00 00       	and    $0x200,%eax
80105ecd:	85 c0                	test   %eax,%eax
80105ecf:	74 2a                	je     80105efb <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
80105ed1:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105ed4:	6a 00                	push   $0x0
80105ed6:	6a 00                	push   $0x0
80105ed8:	6a 02                	push   $0x2
80105eda:	50                   	push   %eax
80105edb:	e8 d4 fd ff ff       	call   80105cb4 <create>
80105ee0:	83 c4 10             	add    $0x10,%esp
80105ee3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80105ee6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105eea:	75 75                	jne    80105f61 <sys_open+0xdb>
      end_op();
80105eec:	e8 7f d6 ff ff       	call   80103570 <end_op>
      return -1;
80105ef1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ef6:	e9 26 01 00 00       	jmp    80106021 <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
80105efb:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105efe:	83 ec 0c             	sub    $0xc,%esp
80105f01:	50                   	push   %eax
80105f02:	e8 d2 c5 ff ff       	call   801024d9 <namei>
80105f07:	83 c4 10             	add    $0x10,%esp
80105f0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105f0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f11:	75 0f                	jne    80105f22 <sys_open+0x9c>
      end_op();
80105f13:	e8 58 d6 ff ff       	call   80103570 <end_op>
      return -1;
80105f18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f1d:	e9 ff 00 00 00       	jmp    80106021 <sys_open+0x19b>
    }
    ilock(ip);
80105f22:	83 ec 0c             	sub    $0xc,%esp
80105f25:	ff 75 f4             	pushl  -0xc(%ebp)
80105f28:	e8 f1 b9 ff ff       	call   8010191e <ilock>
80105f2d:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
80105f30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f33:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105f37:	66 83 f8 01          	cmp    $0x1,%ax
80105f3b:	75 24                	jne    80105f61 <sys_open+0xdb>
80105f3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105f40:	85 c0                	test   %eax,%eax
80105f42:	74 1d                	je     80105f61 <sys_open+0xdb>
      iunlockput(ip);
80105f44:	83 ec 0c             	sub    $0xc,%esp
80105f47:	ff 75 f4             	pushl  -0xc(%ebp)
80105f4a:	e8 8c bc ff ff       	call   80101bdb <iunlockput>
80105f4f:	83 c4 10             	add    $0x10,%esp
      end_op();
80105f52:	e8 19 d6 ff ff       	call   80103570 <end_op>
      return -1;
80105f57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f5c:	e9 c0 00 00 00       	jmp    80106021 <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105f61:	e8 ea af ff ff       	call   80100f50 <filealloc>
80105f66:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105f69:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105f6d:	74 17                	je     80105f86 <sys_open+0x100>
80105f6f:	83 ec 0c             	sub    $0xc,%esp
80105f72:	ff 75 f0             	pushl  -0x10(%ebp)
80105f75:	e8 36 f7 ff ff       	call   801056b0 <fdalloc>
80105f7a:	83 c4 10             	add    $0x10,%esp
80105f7d:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105f80:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80105f84:	79 2e                	jns    80105fb4 <sys_open+0x12e>
    if(f)
80105f86:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105f8a:	74 0e                	je     80105f9a <sys_open+0x114>
      fileclose(f);
80105f8c:	83 ec 0c             	sub    $0xc,%esp
80105f8f:	ff 75 f0             	pushl  -0x10(%ebp)
80105f92:	e8 76 b0 ff ff       	call   8010100d <fileclose>
80105f97:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105f9a:	83 ec 0c             	sub    $0xc,%esp
80105f9d:	ff 75 f4             	pushl  -0xc(%ebp)
80105fa0:	e8 36 bc ff ff       	call   80101bdb <iunlockput>
80105fa5:	83 c4 10             	add    $0x10,%esp
    end_op();
80105fa8:	e8 c3 d5 ff ff       	call   80103570 <end_op>
    return -1;
80105fad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fb2:	eb 6d                	jmp    80106021 <sys_open+0x19b>
  }
  iunlock(ip);
80105fb4:	83 ec 0c             	sub    $0xc,%esp
80105fb7:	ff 75 f4             	pushl  -0xc(%ebp)
80105fba:	e8 bc ba ff ff       	call   80101a7b <iunlock>
80105fbf:	83 c4 10             	add    $0x10,%esp
  end_op();
80105fc2:	e8 a9 d5 ff ff       	call   80103570 <end_op>

  f->type = FD_INODE;
80105fc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fca:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80105fd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fd3:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105fd6:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80105fd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fdc:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80105fe3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105fe6:	83 e0 01             	and    $0x1,%eax
80105fe9:	85 c0                	test   %eax,%eax
80105feb:	0f 94 c0             	sete   %al
80105fee:	89 c2                	mov    %eax,%edx
80105ff0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ff3:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105ff6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105ff9:	83 e0 01             	and    $0x1,%eax
80105ffc:	85 c0                	test   %eax,%eax
80105ffe:	75 0a                	jne    8010600a <sys_open+0x184>
80106000:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106003:	83 e0 02             	and    $0x2,%eax
80106006:	85 c0                	test   %eax,%eax
80106008:	74 07                	je     80106011 <sys_open+0x18b>
8010600a:	b8 01 00 00 00       	mov    $0x1,%eax
8010600f:	eb 05                	jmp    80106016 <sys_open+0x190>
80106011:	b8 00 00 00 00       	mov    $0x0,%eax
80106016:	89 c2                	mov    %eax,%edx
80106018:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010601b:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
8010601e:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80106021:	c9                   	leave  
80106022:	c3                   	ret    

80106023 <sys_mkdir>:

int
sys_mkdir(void)
{
80106023:	55                   	push   %ebp
80106024:	89 e5                	mov    %esp,%ebp
80106026:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106029:	e8 b4 d4 ff ff       	call   801034e2 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010602e:	83 ec 08             	sub    $0x8,%esp
80106031:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106034:	50                   	push   %eax
80106035:	6a 00                	push   $0x0
80106037:	e8 49 f5 ff ff       	call   80105585 <argstr>
8010603c:	83 c4 10             	add    $0x10,%esp
8010603f:	85 c0                	test   %eax,%eax
80106041:	78 1b                	js     8010605e <sys_mkdir+0x3b>
80106043:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106046:	6a 00                	push   $0x0
80106048:	6a 00                	push   $0x0
8010604a:	6a 01                	push   $0x1
8010604c:	50                   	push   %eax
8010604d:	e8 62 fc ff ff       	call   80105cb4 <create>
80106052:	83 c4 10             	add    $0x10,%esp
80106055:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106058:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010605c:	75 0c                	jne    8010606a <sys_mkdir+0x47>
    end_op();
8010605e:	e8 0d d5 ff ff       	call   80103570 <end_op>
    return -1;
80106063:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106068:	eb 18                	jmp    80106082 <sys_mkdir+0x5f>
  }
  iunlockput(ip);
8010606a:	83 ec 0c             	sub    $0xc,%esp
8010606d:	ff 75 f4             	pushl  -0xc(%ebp)
80106070:	e8 66 bb ff ff       	call   80101bdb <iunlockput>
80106075:	83 c4 10             	add    $0x10,%esp
  end_op();
80106078:	e8 f3 d4 ff ff       	call   80103570 <end_op>
  return 0;
8010607d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106082:	c9                   	leave  
80106083:	c3                   	ret    

80106084 <sys_mknod>:

int
sys_mknod(void)
{
80106084:	55                   	push   %ebp
80106085:	89 e5                	mov    %esp,%ebp
80106087:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
8010608a:	e8 53 d4 ff ff       	call   801034e2 <begin_op>
  if((len=argstr(0, &path)) < 0 ||
8010608f:	83 ec 08             	sub    $0x8,%esp
80106092:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106095:	50                   	push   %eax
80106096:	6a 00                	push   $0x0
80106098:	e8 e8 f4 ff ff       	call   80105585 <argstr>
8010609d:	83 c4 10             	add    $0x10,%esp
801060a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801060a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801060a7:	78 4f                	js     801060f8 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
801060a9:	83 ec 08             	sub    $0x8,%esp
801060ac:	8d 45 e8             	lea    -0x18(%ebp),%eax
801060af:	50                   	push   %eax
801060b0:	6a 01                	push   $0x1
801060b2:	e8 47 f4 ff ff       	call   801054fe <argint>
801060b7:	83 c4 10             	add    $0x10,%esp
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
801060ba:	85 c0                	test   %eax,%eax
801060bc:	78 3a                	js     801060f8 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801060be:	83 ec 08             	sub    $0x8,%esp
801060c1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801060c4:	50                   	push   %eax
801060c5:	6a 02                	push   $0x2
801060c7:	e8 32 f4 ff ff       	call   801054fe <argint>
801060cc:	83 c4 10             	add    $0x10,%esp
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
801060cf:	85 c0                	test   %eax,%eax
801060d1:	78 25                	js     801060f8 <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
801060d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801060d6:	0f bf c8             	movswl %ax,%ecx
801060d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
801060dc:	0f bf d0             	movswl %ax,%edx
801060df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801060e2:	51                   	push   %ecx
801060e3:	52                   	push   %edx
801060e4:	6a 03                	push   $0x3
801060e6:	50                   	push   %eax
801060e7:	e8 c8 fb ff ff       	call   80105cb4 <create>
801060ec:	83 c4 10             	add    $0x10,%esp
801060ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
801060f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801060f6:	75 0c                	jne    80106104 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
801060f8:	e8 73 d4 ff ff       	call   80103570 <end_op>
    return -1;
801060fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106102:	eb 18                	jmp    8010611c <sys_mknod+0x98>
  }
  iunlockput(ip);
80106104:	83 ec 0c             	sub    $0xc,%esp
80106107:	ff 75 f0             	pushl  -0x10(%ebp)
8010610a:	e8 cc ba ff ff       	call   80101bdb <iunlockput>
8010610f:	83 c4 10             	add    $0x10,%esp
  end_op();
80106112:	e8 59 d4 ff ff       	call   80103570 <end_op>
  return 0;
80106117:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010611c:	c9                   	leave  
8010611d:	c3                   	ret    

8010611e <sys_chdir>:

int
sys_chdir(void)
{
8010611e:	55                   	push   %ebp
8010611f:	89 e5                	mov    %esp,%ebp
80106121:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106124:	e8 b9 d3 ff ff       	call   801034e2 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106129:	83 ec 08             	sub    $0x8,%esp
8010612c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010612f:	50                   	push   %eax
80106130:	6a 00                	push   $0x0
80106132:	e8 4e f4 ff ff       	call   80105585 <argstr>
80106137:	83 c4 10             	add    $0x10,%esp
8010613a:	85 c0                	test   %eax,%eax
8010613c:	78 18                	js     80106156 <sys_chdir+0x38>
8010613e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106141:	83 ec 0c             	sub    $0xc,%esp
80106144:	50                   	push   %eax
80106145:	e8 8f c3 ff ff       	call   801024d9 <namei>
8010614a:	83 c4 10             	add    $0x10,%esp
8010614d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106150:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106154:	75 0c                	jne    80106162 <sys_chdir+0x44>
    end_op();
80106156:	e8 15 d4 ff ff       	call   80103570 <end_op>
    return -1;
8010615b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106160:	eb 6e                	jmp    801061d0 <sys_chdir+0xb2>
  }
  ilock(ip);
80106162:	83 ec 0c             	sub    $0xc,%esp
80106165:	ff 75 f4             	pushl  -0xc(%ebp)
80106168:	e8 b1 b7 ff ff       	call   8010191e <ilock>
8010616d:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
80106170:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106173:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106177:	66 83 f8 01          	cmp    $0x1,%ax
8010617b:	74 1a                	je     80106197 <sys_chdir+0x79>
    iunlockput(ip);
8010617d:	83 ec 0c             	sub    $0xc,%esp
80106180:	ff 75 f4             	pushl  -0xc(%ebp)
80106183:	e8 53 ba ff ff       	call   80101bdb <iunlockput>
80106188:	83 c4 10             	add    $0x10,%esp
    end_op();
8010618b:	e8 e0 d3 ff ff       	call   80103570 <end_op>
    return -1;
80106190:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106195:	eb 39                	jmp    801061d0 <sys_chdir+0xb2>
  }
  iunlock(ip);
80106197:	83 ec 0c             	sub    $0xc,%esp
8010619a:	ff 75 f4             	pushl  -0xc(%ebp)
8010619d:	e8 d9 b8 ff ff       	call   80101a7b <iunlock>
801061a2:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
801061a5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801061ab:	8b 40 68             	mov    0x68(%eax),%eax
801061ae:	83 ec 0c             	sub    $0xc,%esp
801061b1:	50                   	push   %eax
801061b2:	e8 35 b9 ff ff       	call   80101aec <iput>
801061b7:	83 c4 10             	add    $0x10,%esp
  end_op();
801061ba:	e8 b1 d3 ff ff       	call   80103570 <end_op>
  proc->cwd = ip;
801061bf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801061c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801061c8:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
801061cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
801061d0:	c9                   	leave  
801061d1:	c3                   	ret    

801061d2 <sys_exec>:

int
sys_exec(void)
{
801061d2:	55                   	push   %ebp
801061d3:	89 e5                	mov    %esp,%ebp
801061d5:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801061db:	83 ec 08             	sub    $0x8,%esp
801061de:	8d 45 f0             	lea    -0x10(%ebp),%eax
801061e1:	50                   	push   %eax
801061e2:	6a 00                	push   $0x0
801061e4:	e8 9c f3 ff ff       	call   80105585 <argstr>
801061e9:	83 c4 10             	add    $0x10,%esp
801061ec:	85 c0                	test   %eax,%eax
801061ee:	78 18                	js     80106208 <sys_exec+0x36>
801061f0:	83 ec 08             	sub    $0x8,%esp
801061f3:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
801061f9:	50                   	push   %eax
801061fa:	6a 01                	push   $0x1
801061fc:	e8 fd f2 ff ff       	call   801054fe <argint>
80106201:	83 c4 10             	add    $0x10,%esp
80106204:	85 c0                	test   %eax,%eax
80106206:	79 0a                	jns    80106212 <sys_exec+0x40>
    return -1;
80106208:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010620d:	e9 c6 00 00 00       	jmp    801062d8 <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
80106212:	83 ec 04             	sub    $0x4,%esp
80106215:	68 80 00 00 00       	push   $0x80
8010621a:	6a 00                	push   $0x0
8010621c:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106222:	50                   	push   %eax
80106223:	e8 af ef ff ff       	call   801051d7 <memset>
80106228:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
8010622b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80106232:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106235:	83 f8 1f             	cmp    $0x1f,%eax
80106238:	76 0a                	jbe    80106244 <sys_exec+0x72>
      return -1;
8010623a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010623f:	e9 94 00 00 00       	jmp    801062d8 <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106244:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106247:	c1 e0 02             	shl    $0x2,%eax
8010624a:	89 c2                	mov    %eax,%edx
8010624c:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80106252:	01 c2                	add    %eax,%edx
80106254:	83 ec 08             	sub    $0x8,%esp
80106257:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
8010625d:	50                   	push   %eax
8010625e:	52                   	push   %edx
8010625f:	e8 fe f1 ff ff       	call   80105462 <fetchint>
80106264:	83 c4 10             	add    $0x10,%esp
80106267:	85 c0                	test   %eax,%eax
80106269:	79 07                	jns    80106272 <sys_exec+0xa0>
      return -1;
8010626b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106270:	eb 66                	jmp    801062d8 <sys_exec+0x106>
    if(uarg == 0){
80106272:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106278:	85 c0                	test   %eax,%eax
8010627a:	75 27                	jne    801062a3 <sys_exec+0xd1>
      argv[i] = 0;
8010627c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010627f:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80106286:	00 00 00 00 
      break;
8010628a:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
8010628b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010628e:	83 ec 08             	sub    $0x8,%esp
80106291:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80106297:	52                   	push   %edx
80106298:	50                   	push   %eax
80106299:	e8 a6 a8 ff ff       	call   80100b44 <exec>
8010629e:	83 c4 10             	add    $0x10,%esp
801062a1:	eb 35                	jmp    801062d8 <sys_exec+0x106>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801062a3:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801062a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801062ac:	c1 e2 02             	shl    $0x2,%edx
801062af:	01 c2                	add    %eax,%edx
801062b1:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801062b7:	83 ec 08             	sub    $0x8,%esp
801062ba:	52                   	push   %edx
801062bb:	50                   	push   %eax
801062bc:	e8 db f1 ff ff       	call   8010549c <fetchstr>
801062c1:	83 c4 10             	add    $0x10,%esp
801062c4:	85 c0                	test   %eax,%eax
801062c6:	79 07                	jns    801062cf <sys_exec+0xfd>
      return -1;
801062c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062cd:	eb 09                	jmp    801062d8 <sys_exec+0x106>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
801062cf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
801062d3:	e9 5a ff ff ff       	jmp    80106232 <sys_exec+0x60>
  return exec(path, argv);
}
801062d8:	c9                   	leave  
801062d9:	c3                   	ret    

801062da <sys_pipe>:

int
sys_pipe(void)
{
801062da:	55                   	push   %ebp
801062db:	89 e5                	mov    %esp,%ebp
801062dd:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801062e0:	83 ec 04             	sub    $0x4,%esp
801062e3:	6a 08                	push   $0x8
801062e5:	8d 45 ec             	lea    -0x14(%ebp),%eax
801062e8:	50                   	push   %eax
801062e9:	6a 00                	push   $0x0
801062eb:	e8 36 f2 ff ff       	call   80105526 <argptr>
801062f0:	83 c4 10             	add    $0x10,%esp
801062f3:	85 c0                	test   %eax,%eax
801062f5:	79 0a                	jns    80106301 <sys_pipe+0x27>
    return -1;
801062f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062fc:	e9 af 00 00 00       	jmp    801063b0 <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
80106301:	83 ec 08             	sub    $0x8,%esp
80106304:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106307:	50                   	push   %eax
80106308:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010630b:	50                   	push   %eax
8010630c:	e8 b9 dc ff ff       	call   80103fca <pipealloc>
80106311:	83 c4 10             	add    $0x10,%esp
80106314:	85 c0                	test   %eax,%eax
80106316:	79 0a                	jns    80106322 <sys_pipe+0x48>
    return -1;
80106318:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010631d:	e9 8e 00 00 00       	jmp    801063b0 <sys_pipe+0xd6>
  fd0 = -1;
80106322:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106329:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010632c:	83 ec 0c             	sub    $0xc,%esp
8010632f:	50                   	push   %eax
80106330:	e8 7b f3 ff ff       	call   801056b0 <fdalloc>
80106335:	83 c4 10             	add    $0x10,%esp
80106338:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010633b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010633f:	78 18                	js     80106359 <sys_pipe+0x7f>
80106341:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106344:	83 ec 0c             	sub    $0xc,%esp
80106347:	50                   	push   %eax
80106348:	e8 63 f3 ff ff       	call   801056b0 <fdalloc>
8010634d:	83 c4 10             	add    $0x10,%esp
80106350:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106353:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106357:	79 3f                	jns    80106398 <sys_pipe+0xbe>
    if(fd0 >= 0)
80106359:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010635d:	78 14                	js     80106373 <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
8010635f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106365:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106368:	83 c2 08             	add    $0x8,%edx
8010636b:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106372:	00 
    fileclose(rf);
80106373:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106376:	83 ec 0c             	sub    $0xc,%esp
80106379:	50                   	push   %eax
8010637a:	e8 8e ac ff ff       	call   8010100d <fileclose>
8010637f:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
80106382:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106385:	83 ec 0c             	sub    $0xc,%esp
80106388:	50                   	push   %eax
80106389:	e8 7f ac ff ff       	call   8010100d <fileclose>
8010638e:	83 c4 10             	add    $0x10,%esp
    return -1;
80106391:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106396:	eb 18                	jmp    801063b0 <sys_pipe+0xd6>
  }
  fd[0] = fd0;
80106398:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010639b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010639e:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
801063a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801063a3:	8d 50 04             	lea    0x4(%eax),%edx
801063a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063a9:	89 02                	mov    %eax,(%edx)
  return 0;
801063ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
801063b0:	c9                   	leave  
801063b1:	c3                   	ret    

801063b2 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801063b2:	55                   	push   %ebp
801063b3:	89 e5                	mov    %esp,%ebp
801063b5:	83 ec 08             	sub    $0x8,%esp
  return fork();
801063b8:	e8 03 e3 ff ff       	call   801046c0 <fork>
}
801063bd:	c9                   	leave  
801063be:	c3                   	ret    

801063bf <sys_exit>:

int
sys_exit(void)
{
801063bf:	55                   	push   %ebp
801063c0:	89 e5                	mov    %esp,%ebp
801063c2:	83 ec 08             	sub    $0x8,%esp
  exit();
801063c5:	e8 87 e4 ff ff       	call   80104851 <exit>
  return 0;  // not reached
801063ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
801063cf:	c9                   	leave  
801063d0:	c3                   	ret    

801063d1 <sys_wait>:

int
sys_wait(void)
{
801063d1:	55                   	push   %ebp
801063d2:	89 e5                	mov    %esp,%ebp
801063d4:	83 ec 08             	sub    $0x8,%esp
  return wait();
801063d7:	e8 ad e5 ff ff       	call   80104989 <wait>
}
801063dc:	c9                   	leave  
801063dd:	c3                   	ret    

801063de <sys_kill>:

int
sys_kill(void)
{
801063de:	55                   	push   %ebp
801063df:	89 e5                	mov    %esp,%ebp
801063e1:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
801063e4:	83 ec 08             	sub    $0x8,%esp
801063e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801063ea:	50                   	push   %eax
801063eb:	6a 00                	push   $0x0
801063ed:	e8 0c f1 ff ff       	call   801054fe <argint>
801063f2:	83 c4 10             	add    $0x10,%esp
801063f5:	85 c0                	test   %eax,%eax
801063f7:	79 07                	jns    80106400 <sys_kill+0x22>
    return -1;
801063f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063fe:	eb 0f                	jmp    8010640f <sys_kill+0x31>
  return kill(pid);
80106400:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106403:	83 ec 0c             	sub    $0xc,%esp
80106406:	50                   	push   %eax
80106407:	e8 9e e9 ff ff       	call   80104daa <kill>
8010640c:	83 c4 10             	add    $0x10,%esp
}
8010640f:	c9                   	leave  
80106410:	c3                   	ret    

80106411 <sys_getpid>:

int
sys_getpid(void)
{
80106411:	55                   	push   %ebp
80106412:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80106414:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010641a:	8b 40 10             	mov    0x10(%eax),%eax
}
8010641d:	5d                   	pop    %ebp
8010641e:	c3                   	ret    

8010641f <sys_sbrk>:

int
sys_sbrk(void)
{
8010641f:	55                   	push   %ebp
80106420:	89 e5                	mov    %esp,%ebp
80106422:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106425:	83 ec 08             	sub    $0x8,%esp
80106428:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010642b:	50                   	push   %eax
8010642c:	6a 00                	push   $0x0
8010642e:	e8 cb f0 ff ff       	call   801054fe <argint>
80106433:	83 c4 10             	add    $0x10,%esp
80106436:	85 c0                	test   %eax,%eax
80106438:	79 07                	jns    80106441 <sys_sbrk+0x22>
    return -1;
8010643a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010643f:	eb 28                	jmp    80106469 <sys_sbrk+0x4a>
  addr = proc->sz;
80106441:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106447:	8b 00                	mov    (%eax),%eax
80106449:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
8010644c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010644f:	83 ec 0c             	sub    $0xc,%esp
80106452:	50                   	push   %eax
80106453:	e8 c5 e1 ff ff       	call   8010461d <growproc>
80106458:	83 c4 10             	add    $0x10,%esp
8010645b:	85 c0                	test   %eax,%eax
8010645d:	79 07                	jns    80106466 <sys_sbrk+0x47>
    return -1;
8010645f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106464:	eb 03                	jmp    80106469 <sys_sbrk+0x4a>
  return addr;
80106466:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106469:	c9                   	leave  
8010646a:	c3                   	ret    

8010646b <sys_sleep>:

int
sys_sleep(void)
{
8010646b:	55                   	push   %ebp
8010646c:	89 e5                	mov    %esp,%ebp
8010646e:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
80106471:	83 ec 08             	sub    $0x8,%esp
80106474:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106477:	50                   	push   %eax
80106478:	6a 00                	push   $0x0
8010647a:	e8 7f f0 ff ff       	call   801054fe <argint>
8010647f:	83 c4 10             	add    $0x10,%esp
80106482:	85 c0                	test   %eax,%eax
80106484:	79 07                	jns    8010648d <sys_sleep+0x22>
    return -1;
80106486:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010648b:	eb 77                	jmp    80106504 <sys_sleep+0x99>
  acquire(&tickslock);
8010648d:	83 ec 0c             	sub    $0xc,%esp
80106490:	68 c0 49 11 80       	push   $0x801149c0
80106495:	e8 e1 ea ff ff       	call   80104f7b <acquire>
8010649a:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
8010649d:	a1 00 52 11 80       	mov    0x80115200,%eax
801064a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
801064a5:	eb 39                	jmp    801064e0 <sys_sleep+0x75>
    if(proc->killed){
801064a7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801064ad:	8b 40 24             	mov    0x24(%eax),%eax
801064b0:	85 c0                	test   %eax,%eax
801064b2:	74 17                	je     801064cb <sys_sleep+0x60>
      release(&tickslock);
801064b4:	83 ec 0c             	sub    $0xc,%esp
801064b7:	68 c0 49 11 80       	push   $0x801149c0
801064bc:	e8 20 eb ff ff       	call   80104fe1 <release>
801064c1:	83 c4 10             	add    $0x10,%esp
      return -1;
801064c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064c9:	eb 39                	jmp    80106504 <sys_sleep+0x99>
    }
    sleep(&ticks, &tickslock);
801064cb:	83 ec 08             	sub    $0x8,%esp
801064ce:	68 c0 49 11 80       	push   $0x801149c0
801064d3:	68 00 52 11 80       	push   $0x80115200
801064d8:	e8 ae e7 ff ff       	call   80104c8b <sleep>
801064dd:	83 c4 10             	add    $0x10,%esp
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801064e0:	a1 00 52 11 80       	mov    0x80115200,%eax
801064e5:	2b 45 f4             	sub    -0xc(%ebp),%eax
801064e8:	8b 55 f0             	mov    -0x10(%ebp),%edx
801064eb:	39 d0                	cmp    %edx,%eax
801064ed:	72 b8                	jb     801064a7 <sys_sleep+0x3c>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
801064ef:	83 ec 0c             	sub    $0xc,%esp
801064f2:	68 c0 49 11 80       	push   $0x801149c0
801064f7:	e8 e5 ea ff ff       	call   80104fe1 <release>
801064fc:	83 c4 10             	add    $0x10,%esp
  return 0;
801064ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106504:	c9                   	leave  
80106505:	c3                   	ret    

80106506 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106506:	55                   	push   %ebp
80106507:	89 e5                	mov    %esp,%ebp
80106509:	83 ec 18             	sub    $0x18,%esp
  uint xticks;
  
  acquire(&tickslock);
8010650c:	83 ec 0c             	sub    $0xc,%esp
8010650f:	68 c0 49 11 80       	push   $0x801149c0
80106514:	e8 62 ea ff ff       	call   80104f7b <acquire>
80106519:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
8010651c:	a1 00 52 11 80       	mov    0x80115200,%eax
80106521:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80106524:	83 ec 0c             	sub    $0xc,%esp
80106527:	68 c0 49 11 80       	push   $0x801149c0
8010652c:	e8 b0 ea ff ff       	call   80104fe1 <release>
80106531:	83 c4 10             	add    $0x10,%esp
  return xticks;
80106534:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106537:	c9                   	leave  
80106538:	c3                   	ret    

80106539 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106539:	55                   	push   %ebp
8010653a:	89 e5                	mov    %esp,%ebp
8010653c:	83 ec 08             	sub    $0x8,%esp
8010653f:	8b 55 08             	mov    0x8(%ebp),%edx
80106542:	8b 45 0c             	mov    0xc(%ebp),%eax
80106545:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106549:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010654c:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106550:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106554:	ee                   	out    %al,(%dx)
}
80106555:	c9                   	leave  
80106556:	c3                   	ret    

80106557 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80106557:	55                   	push   %ebp
80106558:	89 e5                	mov    %esp,%ebp
8010655a:	83 ec 08             	sub    $0x8,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
8010655d:	6a 34                	push   $0x34
8010655f:	6a 43                	push   $0x43
80106561:	e8 d3 ff ff ff       	call   80106539 <outb>
80106566:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80106569:	68 9c 00 00 00       	push   $0x9c
8010656e:	6a 40                	push   $0x40
80106570:	e8 c4 ff ff ff       	call   80106539 <outb>
80106575:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80106578:	6a 2e                	push   $0x2e
8010657a:	6a 40                	push   $0x40
8010657c:	e8 b8 ff ff ff       	call   80106539 <outb>
80106581:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
80106584:	83 ec 0c             	sub    $0xc,%esp
80106587:	6a 00                	push   $0x0
80106589:	e8 28 d9 ff ff       	call   80103eb6 <picenable>
8010658e:	83 c4 10             	add    $0x10,%esp
}
80106591:	c9                   	leave  
80106592:	c3                   	ret    

80106593 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106593:	1e                   	push   %ds
  pushl %es
80106594:	06                   	push   %es
  pushl %fs
80106595:	0f a0                	push   %fs
  pushl %gs
80106597:	0f a8                	push   %gs
  pushal
80106599:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
8010659a:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010659e:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801065a0:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
801065a2:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
801065a6:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
801065a8:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
801065aa:	54                   	push   %esp
  call trap
801065ab:	e8 d4 01 00 00       	call   80106784 <trap>
  addl $4, %esp
801065b0:	83 c4 04             	add    $0x4,%esp

801065b3 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801065b3:	61                   	popa   
  popl %gs
801065b4:	0f a9                	pop    %gs
  popl %fs
801065b6:	0f a1                	pop    %fs
  popl %es
801065b8:	07                   	pop    %es
  popl %ds
801065b9:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801065ba:	83 c4 08             	add    $0x8,%esp
  iret
801065bd:	cf                   	iret   

801065be <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
801065be:	55                   	push   %ebp
801065bf:	89 e5                	mov    %esp,%ebp
801065c1:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
801065c4:	8b 45 0c             	mov    0xc(%ebp),%eax
801065c7:	83 e8 01             	sub    $0x1,%eax
801065ca:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801065ce:	8b 45 08             	mov    0x8(%ebp),%eax
801065d1:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801065d5:	8b 45 08             	mov    0x8(%ebp),%eax
801065d8:	c1 e8 10             	shr    $0x10,%eax
801065db:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
801065df:	8d 45 fa             	lea    -0x6(%ebp),%eax
801065e2:	0f 01 18             	lidtl  (%eax)
}
801065e5:	c9                   	leave  
801065e6:	c3                   	ret    

801065e7 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
801065e7:	55                   	push   %ebp
801065e8:	89 e5                	mov    %esp,%ebp
801065ea:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801065ed:	0f 20 d0             	mov    %cr2,%eax
801065f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
801065f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801065f6:	c9                   	leave  
801065f7:	c3                   	ret    

801065f8 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801065f8:	55                   	push   %ebp
801065f9:	89 e5                	mov    %esp,%ebp
801065fb:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
801065fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106605:	e9 c3 00 00 00       	jmp    801066cd <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
8010660a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010660d:	8b 04 85 98 b0 10 80 	mov    -0x7fef4f68(,%eax,4),%eax
80106614:	89 c2                	mov    %eax,%edx
80106616:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106619:	66 89 14 c5 00 4a 11 	mov    %dx,-0x7feeb600(,%eax,8)
80106620:	80 
80106621:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106624:	66 c7 04 c5 02 4a 11 	movw   $0x8,-0x7feeb5fe(,%eax,8)
8010662b:	80 08 00 
8010662e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106631:	0f b6 14 c5 04 4a 11 	movzbl -0x7feeb5fc(,%eax,8),%edx
80106638:	80 
80106639:	83 e2 e0             	and    $0xffffffe0,%edx
8010663c:	88 14 c5 04 4a 11 80 	mov    %dl,-0x7feeb5fc(,%eax,8)
80106643:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106646:	0f b6 14 c5 04 4a 11 	movzbl -0x7feeb5fc(,%eax,8),%edx
8010664d:	80 
8010664e:	83 e2 1f             	and    $0x1f,%edx
80106651:	88 14 c5 04 4a 11 80 	mov    %dl,-0x7feeb5fc(,%eax,8)
80106658:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010665b:	0f b6 14 c5 05 4a 11 	movzbl -0x7feeb5fb(,%eax,8),%edx
80106662:	80 
80106663:	83 e2 f0             	and    $0xfffffff0,%edx
80106666:	83 ca 0e             	or     $0xe,%edx
80106669:	88 14 c5 05 4a 11 80 	mov    %dl,-0x7feeb5fb(,%eax,8)
80106670:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106673:	0f b6 14 c5 05 4a 11 	movzbl -0x7feeb5fb(,%eax,8),%edx
8010667a:	80 
8010667b:	83 e2 ef             	and    $0xffffffef,%edx
8010667e:	88 14 c5 05 4a 11 80 	mov    %dl,-0x7feeb5fb(,%eax,8)
80106685:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106688:	0f b6 14 c5 05 4a 11 	movzbl -0x7feeb5fb(,%eax,8),%edx
8010668f:	80 
80106690:	83 e2 9f             	and    $0xffffff9f,%edx
80106693:	88 14 c5 05 4a 11 80 	mov    %dl,-0x7feeb5fb(,%eax,8)
8010669a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010669d:	0f b6 14 c5 05 4a 11 	movzbl -0x7feeb5fb(,%eax,8),%edx
801066a4:	80 
801066a5:	83 ca 80             	or     $0xffffff80,%edx
801066a8:	88 14 c5 05 4a 11 80 	mov    %dl,-0x7feeb5fb(,%eax,8)
801066af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066b2:	8b 04 85 98 b0 10 80 	mov    -0x7fef4f68(,%eax,4),%eax
801066b9:	c1 e8 10             	shr    $0x10,%eax
801066bc:	89 c2                	mov    %eax,%edx
801066be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066c1:	66 89 14 c5 06 4a 11 	mov    %dx,-0x7feeb5fa(,%eax,8)
801066c8:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801066c9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801066cd:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
801066d4:	0f 8e 30 ff ff ff    	jle    8010660a <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801066da:	a1 98 b1 10 80       	mov    0x8010b198,%eax
801066df:	66 a3 00 4c 11 80    	mov    %ax,0x80114c00
801066e5:	66 c7 05 02 4c 11 80 	movw   $0x8,0x80114c02
801066ec:	08 00 
801066ee:	0f b6 05 04 4c 11 80 	movzbl 0x80114c04,%eax
801066f5:	83 e0 e0             	and    $0xffffffe0,%eax
801066f8:	a2 04 4c 11 80       	mov    %al,0x80114c04
801066fd:	0f b6 05 04 4c 11 80 	movzbl 0x80114c04,%eax
80106704:	83 e0 1f             	and    $0x1f,%eax
80106707:	a2 04 4c 11 80       	mov    %al,0x80114c04
8010670c:	0f b6 05 05 4c 11 80 	movzbl 0x80114c05,%eax
80106713:	83 c8 0f             	or     $0xf,%eax
80106716:	a2 05 4c 11 80       	mov    %al,0x80114c05
8010671b:	0f b6 05 05 4c 11 80 	movzbl 0x80114c05,%eax
80106722:	83 e0 ef             	and    $0xffffffef,%eax
80106725:	a2 05 4c 11 80       	mov    %al,0x80114c05
8010672a:	0f b6 05 05 4c 11 80 	movzbl 0x80114c05,%eax
80106731:	83 c8 60             	or     $0x60,%eax
80106734:	a2 05 4c 11 80       	mov    %al,0x80114c05
80106739:	0f b6 05 05 4c 11 80 	movzbl 0x80114c05,%eax
80106740:	83 c8 80             	or     $0xffffff80,%eax
80106743:	a2 05 4c 11 80       	mov    %al,0x80114c05
80106748:	a1 98 b1 10 80       	mov    0x8010b198,%eax
8010674d:	c1 e8 10             	shr    $0x10,%eax
80106750:	66 a3 06 4c 11 80    	mov    %ax,0x80114c06
  
  initlock(&tickslock, "time");
80106756:	83 ec 08             	sub    $0x8,%esp
80106759:	68 4c 89 10 80       	push   $0x8010894c
8010675e:	68 c0 49 11 80       	push   $0x801149c0
80106763:	e8 f2 e7 ff ff       	call   80104f5a <initlock>
80106768:	83 c4 10             	add    $0x10,%esp
}
8010676b:	c9                   	leave  
8010676c:	c3                   	ret    

8010676d <idtinit>:

void
idtinit(void)
{
8010676d:	55                   	push   %ebp
8010676e:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80106770:	68 00 08 00 00       	push   $0x800
80106775:	68 00 4a 11 80       	push   $0x80114a00
8010677a:	e8 3f fe ff ff       	call   801065be <lidt>
8010677f:	83 c4 08             	add    $0x8,%esp
}
80106782:	c9                   	leave  
80106783:	c3                   	ret    

80106784 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106784:	55                   	push   %ebp
80106785:	89 e5                	mov    %esp,%ebp
80106787:	57                   	push   %edi
80106788:	56                   	push   %esi
80106789:	53                   	push   %ebx
8010678a:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
8010678d:	8b 45 08             	mov    0x8(%ebp),%eax
80106790:	8b 40 30             	mov    0x30(%eax),%eax
80106793:	83 f8 40             	cmp    $0x40,%eax
80106796:	75 3f                	jne    801067d7 <trap+0x53>
    if(proc->killed)
80106798:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010679e:	8b 40 24             	mov    0x24(%eax),%eax
801067a1:	85 c0                	test   %eax,%eax
801067a3:	74 05                	je     801067aa <trap+0x26>
      exit();
801067a5:	e8 a7 e0 ff ff       	call   80104851 <exit>
    proc->tf = tf;
801067aa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801067b0:	8b 55 08             	mov    0x8(%ebp),%edx
801067b3:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
801067b6:	e8 fb ed ff ff       	call   801055b6 <syscall>
    if(proc->killed)
801067bb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801067c1:	8b 40 24             	mov    0x24(%eax),%eax
801067c4:	85 c0                	test   %eax,%eax
801067c6:	74 0a                	je     801067d2 <trap+0x4e>
      exit();
801067c8:	e8 84 e0 ff ff       	call   80104851 <exit>
    return;
801067cd:	e9 14 02 00 00       	jmp    801069e6 <trap+0x262>
801067d2:	e9 0f 02 00 00       	jmp    801069e6 <trap+0x262>
  }

  switch(tf->trapno){
801067d7:	8b 45 08             	mov    0x8(%ebp),%eax
801067da:	8b 40 30             	mov    0x30(%eax),%eax
801067dd:	83 e8 20             	sub    $0x20,%eax
801067e0:	83 f8 1f             	cmp    $0x1f,%eax
801067e3:	0f 87 c0 00 00 00    	ja     801068a9 <trap+0x125>
801067e9:	8b 04 85 f4 89 10 80 	mov    -0x7fef760c(,%eax,4),%eax
801067f0:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
801067f2:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801067f8:	0f b6 00             	movzbl (%eax),%eax
801067fb:	84 c0                	test   %al,%al
801067fd:	75 3d                	jne    8010683c <trap+0xb8>
      acquire(&tickslock);
801067ff:	83 ec 0c             	sub    $0xc,%esp
80106802:	68 c0 49 11 80       	push   $0x801149c0
80106807:	e8 6f e7 ff ff       	call   80104f7b <acquire>
8010680c:	83 c4 10             	add    $0x10,%esp
      ticks++;
8010680f:	a1 00 52 11 80       	mov    0x80115200,%eax
80106814:	83 c0 01             	add    $0x1,%eax
80106817:	a3 00 52 11 80       	mov    %eax,0x80115200
      wakeup(&ticks);
8010681c:	83 ec 0c             	sub    $0xc,%esp
8010681f:	68 00 52 11 80       	push   $0x80115200
80106824:	e8 4b e5 ff ff       	call   80104d74 <wakeup>
80106829:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
8010682c:	83 ec 0c             	sub    $0xc,%esp
8010682f:	68 c0 49 11 80       	push   $0x801149c0
80106834:	e8 a8 e7 ff ff       	call   80104fe1 <release>
80106839:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
8010683c:	e8 82 c7 ff ff       	call   80102fc3 <lapiceoi>
    break;
80106841:	e9 1c 01 00 00       	jmp    80106962 <trap+0x1de>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106846:	e8 99 bf ff ff       	call   801027e4 <ideintr>
    lapiceoi();
8010684b:	e8 73 c7 ff ff       	call   80102fc3 <lapiceoi>
    break;
80106850:	e9 0d 01 00 00       	jmp    80106962 <trap+0x1de>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106855:	e8 70 c5 ff ff       	call   80102dca <kbdintr>
    lapiceoi();
8010685a:	e8 64 c7 ff ff       	call   80102fc3 <lapiceoi>
    break;
8010685f:	e9 fe 00 00 00       	jmp    80106962 <trap+0x1de>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106864:	e8 5a 03 00 00       	call   80106bc3 <uartintr>
    lapiceoi();
80106869:	e8 55 c7 ff ff       	call   80102fc3 <lapiceoi>
    break;
8010686e:	e9 ef 00 00 00       	jmp    80106962 <trap+0x1de>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106873:	8b 45 08             	mov    0x8(%ebp),%eax
80106876:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80106879:	8b 45 08             	mov    0x8(%ebp),%eax
8010687c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106880:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80106883:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106889:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010688c:	0f b6 c0             	movzbl %al,%eax
8010688f:	51                   	push   %ecx
80106890:	52                   	push   %edx
80106891:	50                   	push   %eax
80106892:	68 54 89 10 80       	push   $0x80108954
80106897:	e8 23 9b ff ff       	call   801003bf <cprintf>
8010689c:	83 c4 10             	add    $0x10,%esp
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
8010689f:	e8 1f c7 ff ff       	call   80102fc3 <lapiceoi>
    break;
801068a4:	e9 b9 00 00 00       	jmp    80106962 <trap+0x1de>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
801068a9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068af:	85 c0                	test   %eax,%eax
801068b1:	74 11                	je     801068c4 <trap+0x140>
801068b3:	8b 45 08             	mov    0x8(%ebp),%eax
801068b6:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801068ba:	0f b7 c0             	movzwl %ax,%eax
801068bd:	83 e0 03             	and    $0x3,%eax
801068c0:	85 c0                	test   %eax,%eax
801068c2:	75 40                	jne    80106904 <trap+0x180>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801068c4:	e8 1e fd ff ff       	call   801065e7 <rcr2>
801068c9:	89 c3                	mov    %eax,%ebx
801068cb:	8b 45 08             	mov    0x8(%ebp),%eax
801068ce:	8b 48 38             	mov    0x38(%eax),%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
801068d1:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801068d7:	0f b6 00             	movzbl (%eax),%eax
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801068da:	0f b6 d0             	movzbl %al,%edx
801068dd:	8b 45 08             	mov    0x8(%ebp),%eax
801068e0:	8b 40 30             	mov    0x30(%eax),%eax
801068e3:	83 ec 0c             	sub    $0xc,%esp
801068e6:	53                   	push   %ebx
801068e7:	51                   	push   %ecx
801068e8:	52                   	push   %edx
801068e9:	50                   	push   %eax
801068ea:	68 78 89 10 80       	push   $0x80108978
801068ef:	e8 cb 9a ff ff       	call   801003bf <cprintf>
801068f4:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
801068f7:	83 ec 0c             	sub    $0xc,%esp
801068fa:	68 aa 89 10 80       	push   $0x801089aa
801068ff:	e8 58 9c ff ff       	call   8010055c <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106904:	e8 de fc ff ff       	call   801065e7 <rcr2>
80106909:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010690c:	8b 45 08             	mov    0x8(%ebp),%eax
8010690f:	8b 70 38             	mov    0x38(%eax),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106912:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106918:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010691b:	0f b6 d8             	movzbl %al,%ebx
8010691e:	8b 45 08             	mov    0x8(%ebp),%eax
80106921:	8b 48 34             	mov    0x34(%eax),%ecx
80106924:	8b 45 08             	mov    0x8(%ebp),%eax
80106927:	8b 50 30             	mov    0x30(%eax),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
8010692a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106930:	8d 78 6c             	lea    0x6c(%eax),%edi
80106933:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106939:	8b 40 10             	mov    0x10(%eax),%eax
8010693c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010693f:	56                   	push   %esi
80106940:	53                   	push   %ebx
80106941:	51                   	push   %ecx
80106942:	52                   	push   %edx
80106943:	57                   	push   %edi
80106944:	50                   	push   %eax
80106945:	68 b0 89 10 80       	push   $0x801089b0
8010694a:	e8 70 9a ff ff       	call   801003bf <cprintf>
8010694f:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
80106952:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106958:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010695f:	eb 01                	jmp    80106962 <trap+0x1de>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80106961:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106962:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106968:	85 c0                	test   %eax,%eax
8010696a:	74 24                	je     80106990 <trap+0x20c>
8010696c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106972:	8b 40 24             	mov    0x24(%eax),%eax
80106975:	85 c0                	test   %eax,%eax
80106977:	74 17                	je     80106990 <trap+0x20c>
80106979:	8b 45 08             	mov    0x8(%ebp),%eax
8010697c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106980:	0f b7 c0             	movzwl %ax,%eax
80106983:	83 e0 03             	and    $0x3,%eax
80106986:	83 f8 03             	cmp    $0x3,%eax
80106989:	75 05                	jne    80106990 <trap+0x20c>
    exit();
8010698b:	e8 c1 de ff ff       	call   80104851 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80106990:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106996:	85 c0                	test   %eax,%eax
80106998:	74 1e                	je     801069b8 <trap+0x234>
8010699a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069a0:	8b 40 0c             	mov    0xc(%eax),%eax
801069a3:	83 f8 04             	cmp    $0x4,%eax
801069a6:	75 10                	jne    801069b8 <trap+0x234>
801069a8:	8b 45 08             	mov    0x8(%ebp),%eax
801069ab:	8b 40 30             	mov    0x30(%eax),%eax
801069ae:	83 f8 20             	cmp    $0x20,%eax
801069b1:	75 05                	jne    801069b8 <trap+0x234>
    yield();
801069b3:	e8 54 e2 ff ff       	call   80104c0c <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801069b8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069be:	85 c0                	test   %eax,%eax
801069c0:	74 24                	je     801069e6 <trap+0x262>
801069c2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069c8:	8b 40 24             	mov    0x24(%eax),%eax
801069cb:	85 c0                	test   %eax,%eax
801069cd:	74 17                	je     801069e6 <trap+0x262>
801069cf:	8b 45 08             	mov    0x8(%ebp),%eax
801069d2:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801069d6:	0f b7 c0             	movzwl %ax,%eax
801069d9:	83 e0 03             	and    $0x3,%eax
801069dc:	83 f8 03             	cmp    $0x3,%eax
801069df:	75 05                	jne    801069e6 <trap+0x262>
    exit();
801069e1:	e8 6b de ff ff       	call   80104851 <exit>
}
801069e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801069e9:	5b                   	pop    %ebx
801069ea:	5e                   	pop    %esi
801069eb:	5f                   	pop    %edi
801069ec:	5d                   	pop    %ebp
801069ed:	c3                   	ret    

801069ee <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801069ee:	55                   	push   %ebp
801069ef:	89 e5                	mov    %esp,%ebp
801069f1:	83 ec 14             	sub    $0x14,%esp
801069f4:	8b 45 08             	mov    0x8(%ebp),%eax
801069f7:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801069fb:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801069ff:	89 c2                	mov    %eax,%edx
80106a01:	ec                   	in     (%dx),%al
80106a02:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80106a05:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80106a09:	c9                   	leave  
80106a0a:	c3                   	ret    

80106a0b <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106a0b:	55                   	push   %ebp
80106a0c:	89 e5                	mov    %esp,%ebp
80106a0e:	83 ec 08             	sub    $0x8,%esp
80106a11:	8b 55 08             	mov    0x8(%ebp),%edx
80106a14:	8b 45 0c             	mov    0xc(%ebp),%eax
80106a17:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106a1b:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106a1e:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106a22:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106a26:	ee                   	out    %al,(%dx)
}
80106a27:	c9                   	leave  
80106a28:	c3                   	ret    

80106a29 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106a29:	55                   	push   %ebp
80106a2a:	89 e5                	mov    %esp,%ebp
80106a2c:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106a2f:	6a 00                	push   $0x0
80106a31:	68 fa 03 00 00       	push   $0x3fa
80106a36:	e8 d0 ff ff ff       	call   80106a0b <outb>
80106a3b:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106a3e:	68 80 00 00 00       	push   $0x80
80106a43:	68 fb 03 00 00       	push   $0x3fb
80106a48:	e8 be ff ff ff       	call   80106a0b <outb>
80106a4d:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80106a50:	6a 0c                	push   $0xc
80106a52:	68 f8 03 00 00       	push   $0x3f8
80106a57:	e8 af ff ff ff       	call   80106a0b <outb>
80106a5c:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80106a5f:	6a 00                	push   $0x0
80106a61:	68 f9 03 00 00       	push   $0x3f9
80106a66:	e8 a0 ff ff ff       	call   80106a0b <outb>
80106a6b:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106a6e:	6a 03                	push   $0x3
80106a70:	68 fb 03 00 00       	push   $0x3fb
80106a75:	e8 91 ff ff ff       	call   80106a0b <outb>
80106a7a:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80106a7d:	6a 00                	push   $0x0
80106a7f:	68 fc 03 00 00       	push   $0x3fc
80106a84:	e8 82 ff ff ff       	call   80106a0b <outb>
80106a89:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106a8c:	6a 01                	push   $0x1
80106a8e:	68 f9 03 00 00       	push   $0x3f9
80106a93:	e8 73 ff ff ff       	call   80106a0b <outb>
80106a98:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106a9b:	68 fd 03 00 00       	push   $0x3fd
80106aa0:	e8 49 ff ff ff       	call   801069ee <inb>
80106aa5:	83 c4 04             	add    $0x4,%esp
80106aa8:	3c ff                	cmp    $0xff,%al
80106aaa:	75 02                	jne    80106aae <uartinit+0x85>
    return;
80106aac:	eb 6c                	jmp    80106b1a <uartinit+0xf1>
  uart = 1;
80106aae:	c7 05 6c b6 10 80 01 	movl   $0x1,0x8010b66c
80106ab5:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106ab8:	68 fa 03 00 00       	push   $0x3fa
80106abd:	e8 2c ff ff ff       	call   801069ee <inb>
80106ac2:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80106ac5:	68 f8 03 00 00       	push   $0x3f8
80106aca:	e8 1f ff ff ff       	call   801069ee <inb>
80106acf:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
80106ad2:	83 ec 0c             	sub    $0xc,%esp
80106ad5:	6a 04                	push   $0x4
80106ad7:	e8 da d3 ff ff       	call   80103eb6 <picenable>
80106adc:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
80106adf:	83 ec 08             	sub    $0x8,%esp
80106ae2:	6a 00                	push   $0x0
80106ae4:	6a 04                	push   $0x4
80106ae6:	e8 97 bf ff ff       	call   80102a82 <ioapicenable>
80106aeb:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106aee:	c7 45 f4 74 8a 10 80 	movl   $0x80108a74,-0xc(%ebp)
80106af5:	eb 19                	jmp    80106b10 <uartinit+0xe7>
    uartputc(*p);
80106af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106afa:	0f b6 00             	movzbl (%eax),%eax
80106afd:	0f be c0             	movsbl %al,%eax
80106b00:	83 ec 0c             	sub    $0xc,%esp
80106b03:	50                   	push   %eax
80106b04:	e8 13 00 00 00       	call   80106b1c <uartputc>
80106b09:	83 c4 10             	add    $0x10,%esp
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106b0c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b13:	0f b6 00             	movzbl (%eax),%eax
80106b16:	84 c0                	test   %al,%al
80106b18:	75 dd                	jne    80106af7 <uartinit+0xce>
    uartputc(*p);
}
80106b1a:	c9                   	leave  
80106b1b:	c3                   	ret    

80106b1c <uartputc>:

void
uartputc(int c)
{
80106b1c:	55                   	push   %ebp
80106b1d:	89 e5                	mov    %esp,%ebp
80106b1f:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
80106b22:	a1 6c b6 10 80       	mov    0x8010b66c,%eax
80106b27:	85 c0                	test   %eax,%eax
80106b29:	75 02                	jne    80106b2d <uartputc+0x11>
    return;
80106b2b:	eb 51                	jmp    80106b7e <uartputc+0x62>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106b2d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106b34:	eb 11                	jmp    80106b47 <uartputc+0x2b>
    microdelay(10);
80106b36:	83 ec 0c             	sub    $0xc,%esp
80106b39:	6a 0a                	push   $0xa
80106b3b:	e8 9d c4 ff ff       	call   80102fdd <microdelay>
80106b40:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106b43:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106b47:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106b4b:	7f 1a                	jg     80106b67 <uartputc+0x4b>
80106b4d:	83 ec 0c             	sub    $0xc,%esp
80106b50:	68 fd 03 00 00       	push   $0x3fd
80106b55:	e8 94 fe ff ff       	call   801069ee <inb>
80106b5a:	83 c4 10             	add    $0x10,%esp
80106b5d:	0f b6 c0             	movzbl %al,%eax
80106b60:	83 e0 20             	and    $0x20,%eax
80106b63:	85 c0                	test   %eax,%eax
80106b65:	74 cf                	je     80106b36 <uartputc+0x1a>
    microdelay(10);
  outb(COM1+0, c);
80106b67:	8b 45 08             	mov    0x8(%ebp),%eax
80106b6a:	0f b6 c0             	movzbl %al,%eax
80106b6d:	83 ec 08             	sub    $0x8,%esp
80106b70:	50                   	push   %eax
80106b71:	68 f8 03 00 00       	push   $0x3f8
80106b76:	e8 90 fe ff ff       	call   80106a0b <outb>
80106b7b:	83 c4 10             	add    $0x10,%esp
}
80106b7e:	c9                   	leave  
80106b7f:	c3                   	ret    

80106b80 <uartgetc>:

static int
uartgetc(void)
{
80106b80:	55                   	push   %ebp
80106b81:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106b83:	a1 6c b6 10 80       	mov    0x8010b66c,%eax
80106b88:	85 c0                	test   %eax,%eax
80106b8a:	75 07                	jne    80106b93 <uartgetc+0x13>
    return -1;
80106b8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b91:	eb 2e                	jmp    80106bc1 <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
80106b93:	68 fd 03 00 00       	push   $0x3fd
80106b98:	e8 51 fe ff ff       	call   801069ee <inb>
80106b9d:	83 c4 04             	add    $0x4,%esp
80106ba0:	0f b6 c0             	movzbl %al,%eax
80106ba3:	83 e0 01             	and    $0x1,%eax
80106ba6:	85 c0                	test   %eax,%eax
80106ba8:	75 07                	jne    80106bb1 <uartgetc+0x31>
    return -1;
80106baa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106baf:	eb 10                	jmp    80106bc1 <uartgetc+0x41>
  return inb(COM1+0);
80106bb1:	68 f8 03 00 00       	push   $0x3f8
80106bb6:	e8 33 fe ff ff       	call   801069ee <inb>
80106bbb:	83 c4 04             	add    $0x4,%esp
80106bbe:	0f b6 c0             	movzbl %al,%eax
}
80106bc1:	c9                   	leave  
80106bc2:	c3                   	ret    

80106bc3 <uartintr>:

void
uartintr(void)
{
80106bc3:	55                   	push   %ebp
80106bc4:	89 e5                	mov    %esp,%ebp
80106bc6:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
80106bc9:	83 ec 0c             	sub    $0xc,%esp
80106bcc:	68 80 6b 10 80       	push   $0x80106b80
80106bd1:	e8 fb 9b ff ff       	call   801007d1 <consoleintr>
80106bd6:	83 c4 10             	add    $0x10,%esp
}
80106bd9:	c9                   	leave  
80106bda:	c3                   	ret    

80106bdb <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $0
80106bdd:	6a 00                	push   $0x0
  jmp alltraps
80106bdf:	e9 af f9 ff ff       	jmp    80106593 <alltraps>

80106be4 <vector1>:
.globl vector1
vector1:
  pushl $0
80106be4:	6a 00                	push   $0x0
  pushl $1
80106be6:	6a 01                	push   $0x1
  jmp alltraps
80106be8:	e9 a6 f9 ff ff       	jmp    80106593 <alltraps>

80106bed <vector2>:
.globl vector2
vector2:
  pushl $0
80106bed:	6a 00                	push   $0x0
  pushl $2
80106bef:	6a 02                	push   $0x2
  jmp alltraps
80106bf1:	e9 9d f9 ff ff       	jmp    80106593 <alltraps>

80106bf6 <vector3>:
.globl vector3
vector3:
  pushl $0
80106bf6:	6a 00                	push   $0x0
  pushl $3
80106bf8:	6a 03                	push   $0x3
  jmp alltraps
80106bfa:	e9 94 f9 ff ff       	jmp    80106593 <alltraps>

80106bff <vector4>:
.globl vector4
vector4:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $4
80106c01:	6a 04                	push   $0x4
  jmp alltraps
80106c03:	e9 8b f9 ff ff       	jmp    80106593 <alltraps>

80106c08 <vector5>:
.globl vector5
vector5:
  pushl $0
80106c08:	6a 00                	push   $0x0
  pushl $5
80106c0a:	6a 05                	push   $0x5
  jmp alltraps
80106c0c:	e9 82 f9 ff ff       	jmp    80106593 <alltraps>

80106c11 <vector6>:
.globl vector6
vector6:
  pushl $0
80106c11:	6a 00                	push   $0x0
  pushl $6
80106c13:	6a 06                	push   $0x6
  jmp alltraps
80106c15:	e9 79 f9 ff ff       	jmp    80106593 <alltraps>

80106c1a <vector7>:
.globl vector7
vector7:
  pushl $0
80106c1a:	6a 00                	push   $0x0
  pushl $7
80106c1c:	6a 07                	push   $0x7
  jmp alltraps
80106c1e:	e9 70 f9 ff ff       	jmp    80106593 <alltraps>

80106c23 <vector8>:
.globl vector8
vector8:
  pushl $8
80106c23:	6a 08                	push   $0x8
  jmp alltraps
80106c25:	e9 69 f9 ff ff       	jmp    80106593 <alltraps>

80106c2a <vector9>:
.globl vector9
vector9:
  pushl $0
80106c2a:	6a 00                	push   $0x0
  pushl $9
80106c2c:	6a 09                	push   $0x9
  jmp alltraps
80106c2e:	e9 60 f9 ff ff       	jmp    80106593 <alltraps>

80106c33 <vector10>:
.globl vector10
vector10:
  pushl $10
80106c33:	6a 0a                	push   $0xa
  jmp alltraps
80106c35:	e9 59 f9 ff ff       	jmp    80106593 <alltraps>

80106c3a <vector11>:
.globl vector11
vector11:
  pushl $11
80106c3a:	6a 0b                	push   $0xb
  jmp alltraps
80106c3c:	e9 52 f9 ff ff       	jmp    80106593 <alltraps>

80106c41 <vector12>:
.globl vector12
vector12:
  pushl $12
80106c41:	6a 0c                	push   $0xc
  jmp alltraps
80106c43:	e9 4b f9 ff ff       	jmp    80106593 <alltraps>

80106c48 <vector13>:
.globl vector13
vector13:
  pushl $13
80106c48:	6a 0d                	push   $0xd
  jmp alltraps
80106c4a:	e9 44 f9 ff ff       	jmp    80106593 <alltraps>

80106c4f <vector14>:
.globl vector14
vector14:
  pushl $14
80106c4f:	6a 0e                	push   $0xe
  jmp alltraps
80106c51:	e9 3d f9 ff ff       	jmp    80106593 <alltraps>

80106c56 <vector15>:
.globl vector15
vector15:
  pushl $0
80106c56:	6a 00                	push   $0x0
  pushl $15
80106c58:	6a 0f                	push   $0xf
  jmp alltraps
80106c5a:	e9 34 f9 ff ff       	jmp    80106593 <alltraps>

80106c5f <vector16>:
.globl vector16
vector16:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $16
80106c61:	6a 10                	push   $0x10
  jmp alltraps
80106c63:	e9 2b f9 ff ff       	jmp    80106593 <alltraps>

80106c68 <vector17>:
.globl vector17
vector17:
  pushl $17
80106c68:	6a 11                	push   $0x11
  jmp alltraps
80106c6a:	e9 24 f9 ff ff       	jmp    80106593 <alltraps>

80106c6f <vector18>:
.globl vector18
vector18:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $18
80106c71:	6a 12                	push   $0x12
  jmp alltraps
80106c73:	e9 1b f9 ff ff       	jmp    80106593 <alltraps>

80106c78 <vector19>:
.globl vector19
vector19:
  pushl $0
80106c78:	6a 00                	push   $0x0
  pushl $19
80106c7a:	6a 13                	push   $0x13
  jmp alltraps
80106c7c:	e9 12 f9 ff ff       	jmp    80106593 <alltraps>

80106c81 <vector20>:
.globl vector20
vector20:
  pushl $0
80106c81:	6a 00                	push   $0x0
  pushl $20
80106c83:	6a 14                	push   $0x14
  jmp alltraps
80106c85:	e9 09 f9 ff ff       	jmp    80106593 <alltraps>

80106c8a <vector21>:
.globl vector21
vector21:
  pushl $0
80106c8a:	6a 00                	push   $0x0
  pushl $21
80106c8c:	6a 15                	push   $0x15
  jmp alltraps
80106c8e:	e9 00 f9 ff ff       	jmp    80106593 <alltraps>

80106c93 <vector22>:
.globl vector22
vector22:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $22
80106c95:	6a 16                	push   $0x16
  jmp alltraps
80106c97:	e9 f7 f8 ff ff       	jmp    80106593 <alltraps>

80106c9c <vector23>:
.globl vector23
vector23:
  pushl $0
80106c9c:	6a 00                	push   $0x0
  pushl $23
80106c9e:	6a 17                	push   $0x17
  jmp alltraps
80106ca0:	e9 ee f8 ff ff       	jmp    80106593 <alltraps>

80106ca5 <vector24>:
.globl vector24
vector24:
  pushl $0
80106ca5:	6a 00                	push   $0x0
  pushl $24
80106ca7:	6a 18                	push   $0x18
  jmp alltraps
80106ca9:	e9 e5 f8 ff ff       	jmp    80106593 <alltraps>

80106cae <vector25>:
.globl vector25
vector25:
  pushl $0
80106cae:	6a 00                	push   $0x0
  pushl $25
80106cb0:	6a 19                	push   $0x19
  jmp alltraps
80106cb2:	e9 dc f8 ff ff       	jmp    80106593 <alltraps>

80106cb7 <vector26>:
.globl vector26
vector26:
  pushl $0
80106cb7:	6a 00                	push   $0x0
  pushl $26
80106cb9:	6a 1a                	push   $0x1a
  jmp alltraps
80106cbb:	e9 d3 f8 ff ff       	jmp    80106593 <alltraps>

80106cc0 <vector27>:
.globl vector27
vector27:
  pushl $0
80106cc0:	6a 00                	push   $0x0
  pushl $27
80106cc2:	6a 1b                	push   $0x1b
  jmp alltraps
80106cc4:	e9 ca f8 ff ff       	jmp    80106593 <alltraps>

80106cc9 <vector28>:
.globl vector28
vector28:
  pushl $0
80106cc9:	6a 00                	push   $0x0
  pushl $28
80106ccb:	6a 1c                	push   $0x1c
  jmp alltraps
80106ccd:	e9 c1 f8 ff ff       	jmp    80106593 <alltraps>

80106cd2 <vector29>:
.globl vector29
vector29:
  pushl $0
80106cd2:	6a 00                	push   $0x0
  pushl $29
80106cd4:	6a 1d                	push   $0x1d
  jmp alltraps
80106cd6:	e9 b8 f8 ff ff       	jmp    80106593 <alltraps>

80106cdb <vector30>:
.globl vector30
vector30:
  pushl $0
80106cdb:	6a 00                	push   $0x0
  pushl $30
80106cdd:	6a 1e                	push   $0x1e
  jmp alltraps
80106cdf:	e9 af f8 ff ff       	jmp    80106593 <alltraps>

80106ce4 <vector31>:
.globl vector31
vector31:
  pushl $0
80106ce4:	6a 00                	push   $0x0
  pushl $31
80106ce6:	6a 1f                	push   $0x1f
  jmp alltraps
80106ce8:	e9 a6 f8 ff ff       	jmp    80106593 <alltraps>

80106ced <vector32>:
.globl vector32
vector32:
  pushl $0
80106ced:	6a 00                	push   $0x0
  pushl $32
80106cef:	6a 20                	push   $0x20
  jmp alltraps
80106cf1:	e9 9d f8 ff ff       	jmp    80106593 <alltraps>

80106cf6 <vector33>:
.globl vector33
vector33:
  pushl $0
80106cf6:	6a 00                	push   $0x0
  pushl $33
80106cf8:	6a 21                	push   $0x21
  jmp alltraps
80106cfa:	e9 94 f8 ff ff       	jmp    80106593 <alltraps>

80106cff <vector34>:
.globl vector34
vector34:
  pushl $0
80106cff:	6a 00                	push   $0x0
  pushl $34
80106d01:	6a 22                	push   $0x22
  jmp alltraps
80106d03:	e9 8b f8 ff ff       	jmp    80106593 <alltraps>

80106d08 <vector35>:
.globl vector35
vector35:
  pushl $0
80106d08:	6a 00                	push   $0x0
  pushl $35
80106d0a:	6a 23                	push   $0x23
  jmp alltraps
80106d0c:	e9 82 f8 ff ff       	jmp    80106593 <alltraps>

80106d11 <vector36>:
.globl vector36
vector36:
  pushl $0
80106d11:	6a 00                	push   $0x0
  pushl $36
80106d13:	6a 24                	push   $0x24
  jmp alltraps
80106d15:	e9 79 f8 ff ff       	jmp    80106593 <alltraps>

80106d1a <vector37>:
.globl vector37
vector37:
  pushl $0
80106d1a:	6a 00                	push   $0x0
  pushl $37
80106d1c:	6a 25                	push   $0x25
  jmp alltraps
80106d1e:	e9 70 f8 ff ff       	jmp    80106593 <alltraps>

80106d23 <vector38>:
.globl vector38
vector38:
  pushl $0
80106d23:	6a 00                	push   $0x0
  pushl $38
80106d25:	6a 26                	push   $0x26
  jmp alltraps
80106d27:	e9 67 f8 ff ff       	jmp    80106593 <alltraps>

80106d2c <vector39>:
.globl vector39
vector39:
  pushl $0
80106d2c:	6a 00                	push   $0x0
  pushl $39
80106d2e:	6a 27                	push   $0x27
  jmp alltraps
80106d30:	e9 5e f8 ff ff       	jmp    80106593 <alltraps>

80106d35 <vector40>:
.globl vector40
vector40:
  pushl $0
80106d35:	6a 00                	push   $0x0
  pushl $40
80106d37:	6a 28                	push   $0x28
  jmp alltraps
80106d39:	e9 55 f8 ff ff       	jmp    80106593 <alltraps>

80106d3e <vector41>:
.globl vector41
vector41:
  pushl $0
80106d3e:	6a 00                	push   $0x0
  pushl $41
80106d40:	6a 29                	push   $0x29
  jmp alltraps
80106d42:	e9 4c f8 ff ff       	jmp    80106593 <alltraps>

80106d47 <vector42>:
.globl vector42
vector42:
  pushl $0
80106d47:	6a 00                	push   $0x0
  pushl $42
80106d49:	6a 2a                	push   $0x2a
  jmp alltraps
80106d4b:	e9 43 f8 ff ff       	jmp    80106593 <alltraps>

80106d50 <vector43>:
.globl vector43
vector43:
  pushl $0
80106d50:	6a 00                	push   $0x0
  pushl $43
80106d52:	6a 2b                	push   $0x2b
  jmp alltraps
80106d54:	e9 3a f8 ff ff       	jmp    80106593 <alltraps>

80106d59 <vector44>:
.globl vector44
vector44:
  pushl $0
80106d59:	6a 00                	push   $0x0
  pushl $44
80106d5b:	6a 2c                	push   $0x2c
  jmp alltraps
80106d5d:	e9 31 f8 ff ff       	jmp    80106593 <alltraps>

80106d62 <vector45>:
.globl vector45
vector45:
  pushl $0
80106d62:	6a 00                	push   $0x0
  pushl $45
80106d64:	6a 2d                	push   $0x2d
  jmp alltraps
80106d66:	e9 28 f8 ff ff       	jmp    80106593 <alltraps>

80106d6b <vector46>:
.globl vector46
vector46:
  pushl $0
80106d6b:	6a 00                	push   $0x0
  pushl $46
80106d6d:	6a 2e                	push   $0x2e
  jmp alltraps
80106d6f:	e9 1f f8 ff ff       	jmp    80106593 <alltraps>

80106d74 <vector47>:
.globl vector47
vector47:
  pushl $0
80106d74:	6a 00                	push   $0x0
  pushl $47
80106d76:	6a 2f                	push   $0x2f
  jmp alltraps
80106d78:	e9 16 f8 ff ff       	jmp    80106593 <alltraps>

80106d7d <vector48>:
.globl vector48
vector48:
  pushl $0
80106d7d:	6a 00                	push   $0x0
  pushl $48
80106d7f:	6a 30                	push   $0x30
  jmp alltraps
80106d81:	e9 0d f8 ff ff       	jmp    80106593 <alltraps>

80106d86 <vector49>:
.globl vector49
vector49:
  pushl $0
80106d86:	6a 00                	push   $0x0
  pushl $49
80106d88:	6a 31                	push   $0x31
  jmp alltraps
80106d8a:	e9 04 f8 ff ff       	jmp    80106593 <alltraps>

80106d8f <vector50>:
.globl vector50
vector50:
  pushl $0
80106d8f:	6a 00                	push   $0x0
  pushl $50
80106d91:	6a 32                	push   $0x32
  jmp alltraps
80106d93:	e9 fb f7 ff ff       	jmp    80106593 <alltraps>

80106d98 <vector51>:
.globl vector51
vector51:
  pushl $0
80106d98:	6a 00                	push   $0x0
  pushl $51
80106d9a:	6a 33                	push   $0x33
  jmp alltraps
80106d9c:	e9 f2 f7 ff ff       	jmp    80106593 <alltraps>

80106da1 <vector52>:
.globl vector52
vector52:
  pushl $0
80106da1:	6a 00                	push   $0x0
  pushl $52
80106da3:	6a 34                	push   $0x34
  jmp alltraps
80106da5:	e9 e9 f7 ff ff       	jmp    80106593 <alltraps>

80106daa <vector53>:
.globl vector53
vector53:
  pushl $0
80106daa:	6a 00                	push   $0x0
  pushl $53
80106dac:	6a 35                	push   $0x35
  jmp alltraps
80106dae:	e9 e0 f7 ff ff       	jmp    80106593 <alltraps>

80106db3 <vector54>:
.globl vector54
vector54:
  pushl $0
80106db3:	6a 00                	push   $0x0
  pushl $54
80106db5:	6a 36                	push   $0x36
  jmp alltraps
80106db7:	e9 d7 f7 ff ff       	jmp    80106593 <alltraps>

80106dbc <vector55>:
.globl vector55
vector55:
  pushl $0
80106dbc:	6a 00                	push   $0x0
  pushl $55
80106dbe:	6a 37                	push   $0x37
  jmp alltraps
80106dc0:	e9 ce f7 ff ff       	jmp    80106593 <alltraps>

80106dc5 <vector56>:
.globl vector56
vector56:
  pushl $0
80106dc5:	6a 00                	push   $0x0
  pushl $56
80106dc7:	6a 38                	push   $0x38
  jmp alltraps
80106dc9:	e9 c5 f7 ff ff       	jmp    80106593 <alltraps>

80106dce <vector57>:
.globl vector57
vector57:
  pushl $0
80106dce:	6a 00                	push   $0x0
  pushl $57
80106dd0:	6a 39                	push   $0x39
  jmp alltraps
80106dd2:	e9 bc f7 ff ff       	jmp    80106593 <alltraps>

80106dd7 <vector58>:
.globl vector58
vector58:
  pushl $0
80106dd7:	6a 00                	push   $0x0
  pushl $58
80106dd9:	6a 3a                	push   $0x3a
  jmp alltraps
80106ddb:	e9 b3 f7 ff ff       	jmp    80106593 <alltraps>

80106de0 <vector59>:
.globl vector59
vector59:
  pushl $0
80106de0:	6a 00                	push   $0x0
  pushl $59
80106de2:	6a 3b                	push   $0x3b
  jmp alltraps
80106de4:	e9 aa f7 ff ff       	jmp    80106593 <alltraps>

80106de9 <vector60>:
.globl vector60
vector60:
  pushl $0
80106de9:	6a 00                	push   $0x0
  pushl $60
80106deb:	6a 3c                	push   $0x3c
  jmp alltraps
80106ded:	e9 a1 f7 ff ff       	jmp    80106593 <alltraps>

80106df2 <vector61>:
.globl vector61
vector61:
  pushl $0
80106df2:	6a 00                	push   $0x0
  pushl $61
80106df4:	6a 3d                	push   $0x3d
  jmp alltraps
80106df6:	e9 98 f7 ff ff       	jmp    80106593 <alltraps>

80106dfb <vector62>:
.globl vector62
vector62:
  pushl $0
80106dfb:	6a 00                	push   $0x0
  pushl $62
80106dfd:	6a 3e                	push   $0x3e
  jmp alltraps
80106dff:	e9 8f f7 ff ff       	jmp    80106593 <alltraps>

80106e04 <vector63>:
.globl vector63
vector63:
  pushl $0
80106e04:	6a 00                	push   $0x0
  pushl $63
80106e06:	6a 3f                	push   $0x3f
  jmp alltraps
80106e08:	e9 86 f7 ff ff       	jmp    80106593 <alltraps>

80106e0d <vector64>:
.globl vector64
vector64:
  pushl $0
80106e0d:	6a 00                	push   $0x0
  pushl $64
80106e0f:	6a 40                	push   $0x40
  jmp alltraps
80106e11:	e9 7d f7 ff ff       	jmp    80106593 <alltraps>

80106e16 <vector65>:
.globl vector65
vector65:
  pushl $0
80106e16:	6a 00                	push   $0x0
  pushl $65
80106e18:	6a 41                	push   $0x41
  jmp alltraps
80106e1a:	e9 74 f7 ff ff       	jmp    80106593 <alltraps>

80106e1f <vector66>:
.globl vector66
vector66:
  pushl $0
80106e1f:	6a 00                	push   $0x0
  pushl $66
80106e21:	6a 42                	push   $0x42
  jmp alltraps
80106e23:	e9 6b f7 ff ff       	jmp    80106593 <alltraps>

80106e28 <vector67>:
.globl vector67
vector67:
  pushl $0
80106e28:	6a 00                	push   $0x0
  pushl $67
80106e2a:	6a 43                	push   $0x43
  jmp alltraps
80106e2c:	e9 62 f7 ff ff       	jmp    80106593 <alltraps>

80106e31 <vector68>:
.globl vector68
vector68:
  pushl $0
80106e31:	6a 00                	push   $0x0
  pushl $68
80106e33:	6a 44                	push   $0x44
  jmp alltraps
80106e35:	e9 59 f7 ff ff       	jmp    80106593 <alltraps>

80106e3a <vector69>:
.globl vector69
vector69:
  pushl $0
80106e3a:	6a 00                	push   $0x0
  pushl $69
80106e3c:	6a 45                	push   $0x45
  jmp alltraps
80106e3e:	e9 50 f7 ff ff       	jmp    80106593 <alltraps>

80106e43 <vector70>:
.globl vector70
vector70:
  pushl $0
80106e43:	6a 00                	push   $0x0
  pushl $70
80106e45:	6a 46                	push   $0x46
  jmp alltraps
80106e47:	e9 47 f7 ff ff       	jmp    80106593 <alltraps>

80106e4c <vector71>:
.globl vector71
vector71:
  pushl $0
80106e4c:	6a 00                	push   $0x0
  pushl $71
80106e4e:	6a 47                	push   $0x47
  jmp alltraps
80106e50:	e9 3e f7 ff ff       	jmp    80106593 <alltraps>

80106e55 <vector72>:
.globl vector72
vector72:
  pushl $0
80106e55:	6a 00                	push   $0x0
  pushl $72
80106e57:	6a 48                	push   $0x48
  jmp alltraps
80106e59:	e9 35 f7 ff ff       	jmp    80106593 <alltraps>

80106e5e <vector73>:
.globl vector73
vector73:
  pushl $0
80106e5e:	6a 00                	push   $0x0
  pushl $73
80106e60:	6a 49                	push   $0x49
  jmp alltraps
80106e62:	e9 2c f7 ff ff       	jmp    80106593 <alltraps>

80106e67 <vector74>:
.globl vector74
vector74:
  pushl $0
80106e67:	6a 00                	push   $0x0
  pushl $74
80106e69:	6a 4a                	push   $0x4a
  jmp alltraps
80106e6b:	e9 23 f7 ff ff       	jmp    80106593 <alltraps>

80106e70 <vector75>:
.globl vector75
vector75:
  pushl $0
80106e70:	6a 00                	push   $0x0
  pushl $75
80106e72:	6a 4b                	push   $0x4b
  jmp alltraps
80106e74:	e9 1a f7 ff ff       	jmp    80106593 <alltraps>

80106e79 <vector76>:
.globl vector76
vector76:
  pushl $0
80106e79:	6a 00                	push   $0x0
  pushl $76
80106e7b:	6a 4c                	push   $0x4c
  jmp alltraps
80106e7d:	e9 11 f7 ff ff       	jmp    80106593 <alltraps>

80106e82 <vector77>:
.globl vector77
vector77:
  pushl $0
80106e82:	6a 00                	push   $0x0
  pushl $77
80106e84:	6a 4d                	push   $0x4d
  jmp alltraps
80106e86:	e9 08 f7 ff ff       	jmp    80106593 <alltraps>

80106e8b <vector78>:
.globl vector78
vector78:
  pushl $0
80106e8b:	6a 00                	push   $0x0
  pushl $78
80106e8d:	6a 4e                	push   $0x4e
  jmp alltraps
80106e8f:	e9 ff f6 ff ff       	jmp    80106593 <alltraps>

80106e94 <vector79>:
.globl vector79
vector79:
  pushl $0
80106e94:	6a 00                	push   $0x0
  pushl $79
80106e96:	6a 4f                	push   $0x4f
  jmp alltraps
80106e98:	e9 f6 f6 ff ff       	jmp    80106593 <alltraps>

80106e9d <vector80>:
.globl vector80
vector80:
  pushl $0
80106e9d:	6a 00                	push   $0x0
  pushl $80
80106e9f:	6a 50                	push   $0x50
  jmp alltraps
80106ea1:	e9 ed f6 ff ff       	jmp    80106593 <alltraps>

80106ea6 <vector81>:
.globl vector81
vector81:
  pushl $0
80106ea6:	6a 00                	push   $0x0
  pushl $81
80106ea8:	6a 51                	push   $0x51
  jmp alltraps
80106eaa:	e9 e4 f6 ff ff       	jmp    80106593 <alltraps>

80106eaf <vector82>:
.globl vector82
vector82:
  pushl $0
80106eaf:	6a 00                	push   $0x0
  pushl $82
80106eb1:	6a 52                	push   $0x52
  jmp alltraps
80106eb3:	e9 db f6 ff ff       	jmp    80106593 <alltraps>

80106eb8 <vector83>:
.globl vector83
vector83:
  pushl $0
80106eb8:	6a 00                	push   $0x0
  pushl $83
80106eba:	6a 53                	push   $0x53
  jmp alltraps
80106ebc:	e9 d2 f6 ff ff       	jmp    80106593 <alltraps>

80106ec1 <vector84>:
.globl vector84
vector84:
  pushl $0
80106ec1:	6a 00                	push   $0x0
  pushl $84
80106ec3:	6a 54                	push   $0x54
  jmp alltraps
80106ec5:	e9 c9 f6 ff ff       	jmp    80106593 <alltraps>

80106eca <vector85>:
.globl vector85
vector85:
  pushl $0
80106eca:	6a 00                	push   $0x0
  pushl $85
80106ecc:	6a 55                	push   $0x55
  jmp alltraps
80106ece:	e9 c0 f6 ff ff       	jmp    80106593 <alltraps>

80106ed3 <vector86>:
.globl vector86
vector86:
  pushl $0
80106ed3:	6a 00                	push   $0x0
  pushl $86
80106ed5:	6a 56                	push   $0x56
  jmp alltraps
80106ed7:	e9 b7 f6 ff ff       	jmp    80106593 <alltraps>

80106edc <vector87>:
.globl vector87
vector87:
  pushl $0
80106edc:	6a 00                	push   $0x0
  pushl $87
80106ede:	6a 57                	push   $0x57
  jmp alltraps
80106ee0:	e9 ae f6 ff ff       	jmp    80106593 <alltraps>

80106ee5 <vector88>:
.globl vector88
vector88:
  pushl $0
80106ee5:	6a 00                	push   $0x0
  pushl $88
80106ee7:	6a 58                	push   $0x58
  jmp alltraps
80106ee9:	e9 a5 f6 ff ff       	jmp    80106593 <alltraps>

80106eee <vector89>:
.globl vector89
vector89:
  pushl $0
80106eee:	6a 00                	push   $0x0
  pushl $89
80106ef0:	6a 59                	push   $0x59
  jmp alltraps
80106ef2:	e9 9c f6 ff ff       	jmp    80106593 <alltraps>

80106ef7 <vector90>:
.globl vector90
vector90:
  pushl $0
80106ef7:	6a 00                	push   $0x0
  pushl $90
80106ef9:	6a 5a                	push   $0x5a
  jmp alltraps
80106efb:	e9 93 f6 ff ff       	jmp    80106593 <alltraps>

80106f00 <vector91>:
.globl vector91
vector91:
  pushl $0
80106f00:	6a 00                	push   $0x0
  pushl $91
80106f02:	6a 5b                	push   $0x5b
  jmp alltraps
80106f04:	e9 8a f6 ff ff       	jmp    80106593 <alltraps>

80106f09 <vector92>:
.globl vector92
vector92:
  pushl $0
80106f09:	6a 00                	push   $0x0
  pushl $92
80106f0b:	6a 5c                	push   $0x5c
  jmp alltraps
80106f0d:	e9 81 f6 ff ff       	jmp    80106593 <alltraps>

80106f12 <vector93>:
.globl vector93
vector93:
  pushl $0
80106f12:	6a 00                	push   $0x0
  pushl $93
80106f14:	6a 5d                	push   $0x5d
  jmp alltraps
80106f16:	e9 78 f6 ff ff       	jmp    80106593 <alltraps>

80106f1b <vector94>:
.globl vector94
vector94:
  pushl $0
80106f1b:	6a 00                	push   $0x0
  pushl $94
80106f1d:	6a 5e                	push   $0x5e
  jmp alltraps
80106f1f:	e9 6f f6 ff ff       	jmp    80106593 <alltraps>

80106f24 <vector95>:
.globl vector95
vector95:
  pushl $0
80106f24:	6a 00                	push   $0x0
  pushl $95
80106f26:	6a 5f                	push   $0x5f
  jmp alltraps
80106f28:	e9 66 f6 ff ff       	jmp    80106593 <alltraps>

80106f2d <vector96>:
.globl vector96
vector96:
  pushl $0
80106f2d:	6a 00                	push   $0x0
  pushl $96
80106f2f:	6a 60                	push   $0x60
  jmp alltraps
80106f31:	e9 5d f6 ff ff       	jmp    80106593 <alltraps>

80106f36 <vector97>:
.globl vector97
vector97:
  pushl $0
80106f36:	6a 00                	push   $0x0
  pushl $97
80106f38:	6a 61                	push   $0x61
  jmp alltraps
80106f3a:	e9 54 f6 ff ff       	jmp    80106593 <alltraps>

80106f3f <vector98>:
.globl vector98
vector98:
  pushl $0
80106f3f:	6a 00                	push   $0x0
  pushl $98
80106f41:	6a 62                	push   $0x62
  jmp alltraps
80106f43:	e9 4b f6 ff ff       	jmp    80106593 <alltraps>

80106f48 <vector99>:
.globl vector99
vector99:
  pushl $0
80106f48:	6a 00                	push   $0x0
  pushl $99
80106f4a:	6a 63                	push   $0x63
  jmp alltraps
80106f4c:	e9 42 f6 ff ff       	jmp    80106593 <alltraps>

80106f51 <vector100>:
.globl vector100
vector100:
  pushl $0
80106f51:	6a 00                	push   $0x0
  pushl $100
80106f53:	6a 64                	push   $0x64
  jmp alltraps
80106f55:	e9 39 f6 ff ff       	jmp    80106593 <alltraps>

80106f5a <vector101>:
.globl vector101
vector101:
  pushl $0
80106f5a:	6a 00                	push   $0x0
  pushl $101
80106f5c:	6a 65                	push   $0x65
  jmp alltraps
80106f5e:	e9 30 f6 ff ff       	jmp    80106593 <alltraps>

80106f63 <vector102>:
.globl vector102
vector102:
  pushl $0
80106f63:	6a 00                	push   $0x0
  pushl $102
80106f65:	6a 66                	push   $0x66
  jmp alltraps
80106f67:	e9 27 f6 ff ff       	jmp    80106593 <alltraps>

80106f6c <vector103>:
.globl vector103
vector103:
  pushl $0
80106f6c:	6a 00                	push   $0x0
  pushl $103
80106f6e:	6a 67                	push   $0x67
  jmp alltraps
80106f70:	e9 1e f6 ff ff       	jmp    80106593 <alltraps>

80106f75 <vector104>:
.globl vector104
vector104:
  pushl $0
80106f75:	6a 00                	push   $0x0
  pushl $104
80106f77:	6a 68                	push   $0x68
  jmp alltraps
80106f79:	e9 15 f6 ff ff       	jmp    80106593 <alltraps>

80106f7e <vector105>:
.globl vector105
vector105:
  pushl $0
80106f7e:	6a 00                	push   $0x0
  pushl $105
80106f80:	6a 69                	push   $0x69
  jmp alltraps
80106f82:	e9 0c f6 ff ff       	jmp    80106593 <alltraps>

80106f87 <vector106>:
.globl vector106
vector106:
  pushl $0
80106f87:	6a 00                	push   $0x0
  pushl $106
80106f89:	6a 6a                	push   $0x6a
  jmp alltraps
80106f8b:	e9 03 f6 ff ff       	jmp    80106593 <alltraps>

80106f90 <vector107>:
.globl vector107
vector107:
  pushl $0
80106f90:	6a 00                	push   $0x0
  pushl $107
80106f92:	6a 6b                	push   $0x6b
  jmp alltraps
80106f94:	e9 fa f5 ff ff       	jmp    80106593 <alltraps>

80106f99 <vector108>:
.globl vector108
vector108:
  pushl $0
80106f99:	6a 00                	push   $0x0
  pushl $108
80106f9b:	6a 6c                	push   $0x6c
  jmp alltraps
80106f9d:	e9 f1 f5 ff ff       	jmp    80106593 <alltraps>

80106fa2 <vector109>:
.globl vector109
vector109:
  pushl $0
80106fa2:	6a 00                	push   $0x0
  pushl $109
80106fa4:	6a 6d                	push   $0x6d
  jmp alltraps
80106fa6:	e9 e8 f5 ff ff       	jmp    80106593 <alltraps>

80106fab <vector110>:
.globl vector110
vector110:
  pushl $0
80106fab:	6a 00                	push   $0x0
  pushl $110
80106fad:	6a 6e                	push   $0x6e
  jmp alltraps
80106faf:	e9 df f5 ff ff       	jmp    80106593 <alltraps>

80106fb4 <vector111>:
.globl vector111
vector111:
  pushl $0
80106fb4:	6a 00                	push   $0x0
  pushl $111
80106fb6:	6a 6f                	push   $0x6f
  jmp alltraps
80106fb8:	e9 d6 f5 ff ff       	jmp    80106593 <alltraps>

80106fbd <vector112>:
.globl vector112
vector112:
  pushl $0
80106fbd:	6a 00                	push   $0x0
  pushl $112
80106fbf:	6a 70                	push   $0x70
  jmp alltraps
80106fc1:	e9 cd f5 ff ff       	jmp    80106593 <alltraps>

80106fc6 <vector113>:
.globl vector113
vector113:
  pushl $0
80106fc6:	6a 00                	push   $0x0
  pushl $113
80106fc8:	6a 71                	push   $0x71
  jmp alltraps
80106fca:	e9 c4 f5 ff ff       	jmp    80106593 <alltraps>

80106fcf <vector114>:
.globl vector114
vector114:
  pushl $0
80106fcf:	6a 00                	push   $0x0
  pushl $114
80106fd1:	6a 72                	push   $0x72
  jmp alltraps
80106fd3:	e9 bb f5 ff ff       	jmp    80106593 <alltraps>

80106fd8 <vector115>:
.globl vector115
vector115:
  pushl $0
80106fd8:	6a 00                	push   $0x0
  pushl $115
80106fda:	6a 73                	push   $0x73
  jmp alltraps
80106fdc:	e9 b2 f5 ff ff       	jmp    80106593 <alltraps>

80106fe1 <vector116>:
.globl vector116
vector116:
  pushl $0
80106fe1:	6a 00                	push   $0x0
  pushl $116
80106fe3:	6a 74                	push   $0x74
  jmp alltraps
80106fe5:	e9 a9 f5 ff ff       	jmp    80106593 <alltraps>

80106fea <vector117>:
.globl vector117
vector117:
  pushl $0
80106fea:	6a 00                	push   $0x0
  pushl $117
80106fec:	6a 75                	push   $0x75
  jmp alltraps
80106fee:	e9 a0 f5 ff ff       	jmp    80106593 <alltraps>

80106ff3 <vector118>:
.globl vector118
vector118:
  pushl $0
80106ff3:	6a 00                	push   $0x0
  pushl $118
80106ff5:	6a 76                	push   $0x76
  jmp alltraps
80106ff7:	e9 97 f5 ff ff       	jmp    80106593 <alltraps>

80106ffc <vector119>:
.globl vector119
vector119:
  pushl $0
80106ffc:	6a 00                	push   $0x0
  pushl $119
80106ffe:	6a 77                	push   $0x77
  jmp alltraps
80107000:	e9 8e f5 ff ff       	jmp    80106593 <alltraps>

80107005 <vector120>:
.globl vector120
vector120:
  pushl $0
80107005:	6a 00                	push   $0x0
  pushl $120
80107007:	6a 78                	push   $0x78
  jmp alltraps
80107009:	e9 85 f5 ff ff       	jmp    80106593 <alltraps>

8010700e <vector121>:
.globl vector121
vector121:
  pushl $0
8010700e:	6a 00                	push   $0x0
  pushl $121
80107010:	6a 79                	push   $0x79
  jmp alltraps
80107012:	e9 7c f5 ff ff       	jmp    80106593 <alltraps>

80107017 <vector122>:
.globl vector122
vector122:
  pushl $0
80107017:	6a 00                	push   $0x0
  pushl $122
80107019:	6a 7a                	push   $0x7a
  jmp alltraps
8010701b:	e9 73 f5 ff ff       	jmp    80106593 <alltraps>

80107020 <vector123>:
.globl vector123
vector123:
  pushl $0
80107020:	6a 00                	push   $0x0
  pushl $123
80107022:	6a 7b                	push   $0x7b
  jmp alltraps
80107024:	e9 6a f5 ff ff       	jmp    80106593 <alltraps>

80107029 <vector124>:
.globl vector124
vector124:
  pushl $0
80107029:	6a 00                	push   $0x0
  pushl $124
8010702b:	6a 7c                	push   $0x7c
  jmp alltraps
8010702d:	e9 61 f5 ff ff       	jmp    80106593 <alltraps>

80107032 <vector125>:
.globl vector125
vector125:
  pushl $0
80107032:	6a 00                	push   $0x0
  pushl $125
80107034:	6a 7d                	push   $0x7d
  jmp alltraps
80107036:	e9 58 f5 ff ff       	jmp    80106593 <alltraps>

8010703b <vector126>:
.globl vector126
vector126:
  pushl $0
8010703b:	6a 00                	push   $0x0
  pushl $126
8010703d:	6a 7e                	push   $0x7e
  jmp alltraps
8010703f:	e9 4f f5 ff ff       	jmp    80106593 <alltraps>

80107044 <vector127>:
.globl vector127
vector127:
  pushl $0
80107044:	6a 00                	push   $0x0
  pushl $127
80107046:	6a 7f                	push   $0x7f
  jmp alltraps
80107048:	e9 46 f5 ff ff       	jmp    80106593 <alltraps>

8010704d <vector128>:
.globl vector128
vector128:
  pushl $0
8010704d:	6a 00                	push   $0x0
  pushl $128
8010704f:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107054:	e9 3a f5 ff ff       	jmp    80106593 <alltraps>

80107059 <vector129>:
.globl vector129
vector129:
  pushl $0
80107059:	6a 00                	push   $0x0
  pushl $129
8010705b:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80107060:	e9 2e f5 ff ff       	jmp    80106593 <alltraps>

80107065 <vector130>:
.globl vector130
vector130:
  pushl $0
80107065:	6a 00                	push   $0x0
  pushl $130
80107067:	68 82 00 00 00       	push   $0x82
  jmp alltraps
8010706c:	e9 22 f5 ff ff       	jmp    80106593 <alltraps>

80107071 <vector131>:
.globl vector131
vector131:
  pushl $0
80107071:	6a 00                	push   $0x0
  pushl $131
80107073:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107078:	e9 16 f5 ff ff       	jmp    80106593 <alltraps>

8010707d <vector132>:
.globl vector132
vector132:
  pushl $0
8010707d:	6a 00                	push   $0x0
  pushl $132
8010707f:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80107084:	e9 0a f5 ff ff       	jmp    80106593 <alltraps>

80107089 <vector133>:
.globl vector133
vector133:
  pushl $0
80107089:	6a 00                	push   $0x0
  pushl $133
8010708b:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80107090:	e9 fe f4 ff ff       	jmp    80106593 <alltraps>

80107095 <vector134>:
.globl vector134
vector134:
  pushl $0
80107095:	6a 00                	push   $0x0
  pushl $134
80107097:	68 86 00 00 00       	push   $0x86
  jmp alltraps
8010709c:	e9 f2 f4 ff ff       	jmp    80106593 <alltraps>

801070a1 <vector135>:
.globl vector135
vector135:
  pushl $0
801070a1:	6a 00                	push   $0x0
  pushl $135
801070a3:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801070a8:	e9 e6 f4 ff ff       	jmp    80106593 <alltraps>

801070ad <vector136>:
.globl vector136
vector136:
  pushl $0
801070ad:	6a 00                	push   $0x0
  pushl $136
801070af:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801070b4:	e9 da f4 ff ff       	jmp    80106593 <alltraps>

801070b9 <vector137>:
.globl vector137
vector137:
  pushl $0
801070b9:	6a 00                	push   $0x0
  pushl $137
801070bb:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801070c0:	e9 ce f4 ff ff       	jmp    80106593 <alltraps>

801070c5 <vector138>:
.globl vector138
vector138:
  pushl $0
801070c5:	6a 00                	push   $0x0
  pushl $138
801070c7:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801070cc:	e9 c2 f4 ff ff       	jmp    80106593 <alltraps>

801070d1 <vector139>:
.globl vector139
vector139:
  pushl $0
801070d1:	6a 00                	push   $0x0
  pushl $139
801070d3:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801070d8:	e9 b6 f4 ff ff       	jmp    80106593 <alltraps>

801070dd <vector140>:
.globl vector140
vector140:
  pushl $0
801070dd:	6a 00                	push   $0x0
  pushl $140
801070df:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801070e4:	e9 aa f4 ff ff       	jmp    80106593 <alltraps>

801070e9 <vector141>:
.globl vector141
vector141:
  pushl $0
801070e9:	6a 00                	push   $0x0
  pushl $141
801070eb:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801070f0:	e9 9e f4 ff ff       	jmp    80106593 <alltraps>

801070f5 <vector142>:
.globl vector142
vector142:
  pushl $0
801070f5:	6a 00                	push   $0x0
  pushl $142
801070f7:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801070fc:	e9 92 f4 ff ff       	jmp    80106593 <alltraps>

80107101 <vector143>:
.globl vector143
vector143:
  pushl $0
80107101:	6a 00                	push   $0x0
  pushl $143
80107103:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107108:	e9 86 f4 ff ff       	jmp    80106593 <alltraps>

8010710d <vector144>:
.globl vector144
vector144:
  pushl $0
8010710d:	6a 00                	push   $0x0
  pushl $144
8010710f:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107114:	e9 7a f4 ff ff       	jmp    80106593 <alltraps>

80107119 <vector145>:
.globl vector145
vector145:
  pushl $0
80107119:	6a 00                	push   $0x0
  pushl $145
8010711b:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80107120:	e9 6e f4 ff ff       	jmp    80106593 <alltraps>

80107125 <vector146>:
.globl vector146
vector146:
  pushl $0
80107125:	6a 00                	push   $0x0
  pushl $146
80107127:	68 92 00 00 00       	push   $0x92
  jmp alltraps
8010712c:	e9 62 f4 ff ff       	jmp    80106593 <alltraps>

80107131 <vector147>:
.globl vector147
vector147:
  pushl $0
80107131:	6a 00                	push   $0x0
  pushl $147
80107133:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107138:	e9 56 f4 ff ff       	jmp    80106593 <alltraps>

8010713d <vector148>:
.globl vector148
vector148:
  pushl $0
8010713d:	6a 00                	push   $0x0
  pushl $148
8010713f:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107144:	e9 4a f4 ff ff       	jmp    80106593 <alltraps>

80107149 <vector149>:
.globl vector149
vector149:
  pushl $0
80107149:	6a 00                	push   $0x0
  pushl $149
8010714b:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80107150:	e9 3e f4 ff ff       	jmp    80106593 <alltraps>

80107155 <vector150>:
.globl vector150
vector150:
  pushl $0
80107155:	6a 00                	push   $0x0
  pushl $150
80107157:	68 96 00 00 00       	push   $0x96
  jmp alltraps
8010715c:	e9 32 f4 ff ff       	jmp    80106593 <alltraps>

80107161 <vector151>:
.globl vector151
vector151:
  pushl $0
80107161:	6a 00                	push   $0x0
  pushl $151
80107163:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107168:	e9 26 f4 ff ff       	jmp    80106593 <alltraps>

8010716d <vector152>:
.globl vector152
vector152:
  pushl $0
8010716d:	6a 00                	push   $0x0
  pushl $152
8010716f:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107174:	e9 1a f4 ff ff       	jmp    80106593 <alltraps>

80107179 <vector153>:
.globl vector153
vector153:
  pushl $0
80107179:	6a 00                	push   $0x0
  pushl $153
8010717b:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80107180:	e9 0e f4 ff ff       	jmp    80106593 <alltraps>

80107185 <vector154>:
.globl vector154
vector154:
  pushl $0
80107185:	6a 00                	push   $0x0
  pushl $154
80107187:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
8010718c:	e9 02 f4 ff ff       	jmp    80106593 <alltraps>

80107191 <vector155>:
.globl vector155
vector155:
  pushl $0
80107191:	6a 00                	push   $0x0
  pushl $155
80107193:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107198:	e9 f6 f3 ff ff       	jmp    80106593 <alltraps>

8010719d <vector156>:
.globl vector156
vector156:
  pushl $0
8010719d:	6a 00                	push   $0x0
  pushl $156
8010719f:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801071a4:	e9 ea f3 ff ff       	jmp    80106593 <alltraps>

801071a9 <vector157>:
.globl vector157
vector157:
  pushl $0
801071a9:	6a 00                	push   $0x0
  pushl $157
801071ab:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801071b0:	e9 de f3 ff ff       	jmp    80106593 <alltraps>

801071b5 <vector158>:
.globl vector158
vector158:
  pushl $0
801071b5:	6a 00                	push   $0x0
  pushl $158
801071b7:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801071bc:	e9 d2 f3 ff ff       	jmp    80106593 <alltraps>

801071c1 <vector159>:
.globl vector159
vector159:
  pushl $0
801071c1:	6a 00                	push   $0x0
  pushl $159
801071c3:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801071c8:	e9 c6 f3 ff ff       	jmp    80106593 <alltraps>

801071cd <vector160>:
.globl vector160
vector160:
  pushl $0
801071cd:	6a 00                	push   $0x0
  pushl $160
801071cf:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801071d4:	e9 ba f3 ff ff       	jmp    80106593 <alltraps>

801071d9 <vector161>:
.globl vector161
vector161:
  pushl $0
801071d9:	6a 00                	push   $0x0
  pushl $161
801071db:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801071e0:	e9 ae f3 ff ff       	jmp    80106593 <alltraps>

801071e5 <vector162>:
.globl vector162
vector162:
  pushl $0
801071e5:	6a 00                	push   $0x0
  pushl $162
801071e7:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801071ec:	e9 a2 f3 ff ff       	jmp    80106593 <alltraps>

801071f1 <vector163>:
.globl vector163
vector163:
  pushl $0
801071f1:	6a 00                	push   $0x0
  pushl $163
801071f3:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801071f8:	e9 96 f3 ff ff       	jmp    80106593 <alltraps>

801071fd <vector164>:
.globl vector164
vector164:
  pushl $0
801071fd:	6a 00                	push   $0x0
  pushl $164
801071ff:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107204:	e9 8a f3 ff ff       	jmp    80106593 <alltraps>

80107209 <vector165>:
.globl vector165
vector165:
  pushl $0
80107209:	6a 00                	push   $0x0
  pushl $165
8010720b:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107210:	e9 7e f3 ff ff       	jmp    80106593 <alltraps>

80107215 <vector166>:
.globl vector166
vector166:
  pushl $0
80107215:	6a 00                	push   $0x0
  pushl $166
80107217:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
8010721c:	e9 72 f3 ff ff       	jmp    80106593 <alltraps>

80107221 <vector167>:
.globl vector167
vector167:
  pushl $0
80107221:	6a 00                	push   $0x0
  pushl $167
80107223:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107228:	e9 66 f3 ff ff       	jmp    80106593 <alltraps>

8010722d <vector168>:
.globl vector168
vector168:
  pushl $0
8010722d:	6a 00                	push   $0x0
  pushl $168
8010722f:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107234:	e9 5a f3 ff ff       	jmp    80106593 <alltraps>

80107239 <vector169>:
.globl vector169
vector169:
  pushl $0
80107239:	6a 00                	push   $0x0
  pushl $169
8010723b:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107240:	e9 4e f3 ff ff       	jmp    80106593 <alltraps>

80107245 <vector170>:
.globl vector170
vector170:
  pushl $0
80107245:	6a 00                	push   $0x0
  pushl $170
80107247:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
8010724c:	e9 42 f3 ff ff       	jmp    80106593 <alltraps>

80107251 <vector171>:
.globl vector171
vector171:
  pushl $0
80107251:	6a 00                	push   $0x0
  pushl $171
80107253:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107258:	e9 36 f3 ff ff       	jmp    80106593 <alltraps>

8010725d <vector172>:
.globl vector172
vector172:
  pushl $0
8010725d:	6a 00                	push   $0x0
  pushl $172
8010725f:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107264:	e9 2a f3 ff ff       	jmp    80106593 <alltraps>

80107269 <vector173>:
.globl vector173
vector173:
  pushl $0
80107269:	6a 00                	push   $0x0
  pushl $173
8010726b:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107270:	e9 1e f3 ff ff       	jmp    80106593 <alltraps>

80107275 <vector174>:
.globl vector174
vector174:
  pushl $0
80107275:	6a 00                	push   $0x0
  pushl $174
80107277:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
8010727c:	e9 12 f3 ff ff       	jmp    80106593 <alltraps>

80107281 <vector175>:
.globl vector175
vector175:
  pushl $0
80107281:	6a 00                	push   $0x0
  pushl $175
80107283:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107288:	e9 06 f3 ff ff       	jmp    80106593 <alltraps>

8010728d <vector176>:
.globl vector176
vector176:
  pushl $0
8010728d:	6a 00                	push   $0x0
  pushl $176
8010728f:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107294:	e9 fa f2 ff ff       	jmp    80106593 <alltraps>

80107299 <vector177>:
.globl vector177
vector177:
  pushl $0
80107299:	6a 00                	push   $0x0
  pushl $177
8010729b:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801072a0:	e9 ee f2 ff ff       	jmp    80106593 <alltraps>

801072a5 <vector178>:
.globl vector178
vector178:
  pushl $0
801072a5:	6a 00                	push   $0x0
  pushl $178
801072a7:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801072ac:	e9 e2 f2 ff ff       	jmp    80106593 <alltraps>

801072b1 <vector179>:
.globl vector179
vector179:
  pushl $0
801072b1:	6a 00                	push   $0x0
  pushl $179
801072b3:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801072b8:	e9 d6 f2 ff ff       	jmp    80106593 <alltraps>

801072bd <vector180>:
.globl vector180
vector180:
  pushl $0
801072bd:	6a 00                	push   $0x0
  pushl $180
801072bf:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801072c4:	e9 ca f2 ff ff       	jmp    80106593 <alltraps>

801072c9 <vector181>:
.globl vector181
vector181:
  pushl $0
801072c9:	6a 00                	push   $0x0
  pushl $181
801072cb:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801072d0:	e9 be f2 ff ff       	jmp    80106593 <alltraps>

801072d5 <vector182>:
.globl vector182
vector182:
  pushl $0
801072d5:	6a 00                	push   $0x0
  pushl $182
801072d7:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801072dc:	e9 b2 f2 ff ff       	jmp    80106593 <alltraps>

801072e1 <vector183>:
.globl vector183
vector183:
  pushl $0
801072e1:	6a 00                	push   $0x0
  pushl $183
801072e3:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801072e8:	e9 a6 f2 ff ff       	jmp    80106593 <alltraps>

801072ed <vector184>:
.globl vector184
vector184:
  pushl $0
801072ed:	6a 00                	push   $0x0
  pushl $184
801072ef:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801072f4:	e9 9a f2 ff ff       	jmp    80106593 <alltraps>

801072f9 <vector185>:
.globl vector185
vector185:
  pushl $0
801072f9:	6a 00                	push   $0x0
  pushl $185
801072fb:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107300:	e9 8e f2 ff ff       	jmp    80106593 <alltraps>

80107305 <vector186>:
.globl vector186
vector186:
  pushl $0
80107305:	6a 00                	push   $0x0
  pushl $186
80107307:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
8010730c:	e9 82 f2 ff ff       	jmp    80106593 <alltraps>

80107311 <vector187>:
.globl vector187
vector187:
  pushl $0
80107311:	6a 00                	push   $0x0
  pushl $187
80107313:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107318:	e9 76 f2 ff ff       	jmp    80106593 <alltraps>

8010731d <vector188>:
.globl vector188
vector188:
  pushl $0
8010731d:	6a 00                	push   $0x0
  pushl $188
8010731f:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107324:	e9 6a f2 ff ff       	jmp    80106593 <alltraps>

80107329 <vector189>:
.globl vector189
vector189:
  pushl $0
80107329:	6a 00                	push   $0x0
  pushl $189
8010732b:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107330:	e9 5e f2 ff ff       	jmp    80106593 <alltraps>

80107335 <vector190>:
.globl vector190
vector190:
  pushl $0
80107335:	6a 00                	push   $0x0
  pushl $190
80107337:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
8010733c:	e9 52 f2 ff ff       	jmp    80106593 <alltraps>

80107341 <vector191>:
.globl vector191
vector191:
  pushl $0
80107341:	6a 00                	push   $0x0
  pushl $191
80107343:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107348:	e9 46 f2 ff ff       	jmp    80106593 <alltraps>

8010734d <vector192>:
.globl vector192
vector192:
  pushl $0
8010734d:	6a 00                	push   $0x0
  pushl $192
8010734f:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107354:	e9 3a f2 ff ff       	jmp    80106593 <alltraps>

80107359 <vector193>:
.globl vector193
vector193:
  pushl $0
80107359:	6a 00                	push   $0x0
  pushl $193
8010735b:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107360:	e9 2e f2 ff ff       	jmp    80106593 <alltraps>

80107365 <vector194>:
.globl vector194
vector194:
  pushl $0
80107365:	6a 00                	push   $0x0
  pushl $194
80107367:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
8010736c:	e9 22 f2 ff ff       	jmp    80106593 <alltraps>

80107371 <vector195>:
.globl vector195
vector195:
  pushl $0
80107371:	6a 00                	push   $0x0
  pushl $195
80107373:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107378:	e9 16 f2 ff ff       	jmp    80106593 <alltraps>

8010737d <vector196>:
.globl vector196
vector196:
  pushl $0
8010737d:	6a 00                	push   $0x0
  pushl $196
8010737f:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107384:	e9 0a f2 ff ff       	jmp    80106593 <alltraps>

80107389 <vector197>:
.globl vector197
vector197:
  pushl $0
80107389:	6a 00                	push   $0x0
  pushl $197
8010738b:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107390:	e9 fe f1 ff ff       	jmp    80106593 <alltraps>

80107395 <vector198>:
.globl vector198
vector198:
  pushl $0
80107395:	6a 00                	push   $0x0
  pushl $198
80107397:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
8010739c:	e9 f2 f1 ff ff       	jmp    80106593 <alltraps>

801073a1 <vector199>:
.globl vector199
vector199:
  pushl $0
801073a1:	6a 00                	push   $0x0
  pushl $199
801073a3:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801073a8:	e9 e6 f1 ff ff       	jmp    80106593 <alltraps>

801073ad <vector200>:
.globl vector200
vector200:
  pushl $0
801073ad:	6a 00                	push   $0x0
  pushl $200
801073af:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801073b4:	e9 da f1 ff ff       	jmp    80106593 <alltraps>

801073b9 <vector201>:
.globl vector201
vector201:
  pushl $0
801073b9:	6a 00                	push   $0x0
  pushl $201
801073bb:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801073c0:	e9 ce f1 ff ff       	jmp    80106593 <alltraps>

801073c5 <vector202>:
.globl vector202
vector202:
  pushl $0
801073c5:	6a 00                	push   $0x0
  pushl $202
801073c7:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801073cc:	e9 c2 f1 ff ff       	jmp    80106593 <alltraps>

801073d1 <vector203>:
.globl vector203
vector203:
  pushl $0
801073d1:	6a 00                	push   $0x0
  pushl $203
801073d3:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801073d8:	e9 b6 f1 ff ff       	jmp    80106593 <alltraps>

801073dd <vector204>:
.globl vector204
vector204:
  pushl $0
801073dd:	6a 00                	push   $0x0
  pushl $204
801073df:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801073e4:	e9 aa f1 ff ff       	jmp    80106593 <alltraps>

801073e9 <vector205>:
.globl vector205
vector205:
  pushl $0
801073e9:	6a 00                	push   $0x0
  pushl $205
801073eb:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801073f0:	e9 9e f1 ff ff       	jmp    80106593 <alltraps>

801073f5 <vector206>:
.globl vector206
vector206:
  pushl $0
801073f5:	6a 00                	push   $0x0
  pushl $206
801073f7:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801073fc:	e9 92 f1 ff ff       	jmp    80106593 <alltraps>

80107401 <vector207>:
.globl vector207
vector207:
  pushl $0
80107401:	6a 00                	push   $0x0
  pushl $207
80107403:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107408:	e9 86 f1 ff ff       	jmp    80106593 <alltraps>

8010740d <vector208>:
.globl vector208
vector208:
  pushl $0
8010740d:	6a 00                	push   $0x0
  pushl $208
8010740f:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107414:	e9 7a f1 ff ff       	jmp    80106593 <alltraps>

80107419 <vector209>:
.globl vector209
vector209:
  pushl $0
80107419:	6a 00                	push   $0x0
  pushl $209
8010741b:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107420:	e9 6e f1 ff ff       	jmp    80106593 <alltraps>

80107425 <vector210>:
.globl vector210
vector210:
  pushl $0
80107425:	6a 00                	push   $0x0
  pushl $210
80107427:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
8010742c:	e9 62 f1 ff ff       	jmp    80106593 <alltraps>

80107431 <vector211>:
.globl vector211
vector211:
  pushl $0
80107431:	6a 00                	push   $0x0
  pushl $211
80107433:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107438:	e9 56 f1 ff ff       	jmp    80106593 <alltraps>

8010743d <vector212>:
.globl vector212
vector212:
  pushl $0
8010743d:	6a 00                	push   $0x0
  pushl $212
8010743f:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107444:	e9 4a f1 ff ff       	jmp    80106593 <alltraps>

80107449 <vector213>:
.globl vector213
vector213:
  pushl $0
80107449:	6a 00                	push   $0x0
  pushl $213
8010744b:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107450:	e9 3e f1 ff ff       	jmp    80106593 <alltraps>

80107455 <vector214>:
.globl vector214
vector214:
  pushl $0
80107455:	6a 00                	push   $0x0
  pushl $214
80107457:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
8010745c:	e9 32 f1 ff ff       	jmp    80106593 <alltraps>

80107461 <vector215>:
.globl vector215
vector215:
  pushl $0
80107461:	6a 00                	push   $0x0
  pushl $215
80107463:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107468:	e9 26 f1 ff ff       	jmp    80106593 <alltraps>

8010746d <vector216>:
.globl vector216
vector216:
  pushl $0
8010746d:	6a 00                	push   $0x0
  pushl $216
8010746f:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107474:	e9 1a f1 ff ff       	jmp    80106593 <alltraps>

80107479 <vector217>:
.globl vector217
vector217:
  pushl $0
80107479:	6a 00                	push   $0x0
  pushl $217
8010747b:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107480:	e9 0e f1 ff ff       	jmp    80106593 <alltraps>

80107485 <vector218>:
.globl vector218
vector218:
  pushl $0
80107485:	6a 00                	push   $0x0
  pushl $218
80107487:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010748c:	e9 02 f1 ff ff       	jmp    80106593 <alltraps>

80107491 <vector219>:
.globl vector219
vector219:
  pushl $0
80107491:	6a 00                	push   $0x0
  pushl $219
80107493:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107498:	e9 f6 f0 ff ff       	jmp    80106593 <alltraps>

8010749d <vector220>:
.globl vector220
vector220:
  pushl $0
8010749d:	6a 00                	push   $0x0
  pushl $220
8010749f:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801074a4:	e9 ea f0 ff ff       	jmp    80106593 <alltraps>

801074a9 <vector221>:
.globl vector221
vector221:
  pushl $0
801074a9:	6a 00                	push   $0x0
  pushl $221
801074ab:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801074b0:	e9 de f0 ff ff       	jmp    80106593 <alltraps>

801074b5 <vector222>:
.globl vector222
vector222:
  pushl $0
801074b5:	6a 00                	push   $0x0
  pushl $222
801074b7:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801074bc:	e9 d2 f0 ff ff       	jmp    80106593 <alltraps>

801074c1 <vector223>:
.globl vector223
vector223:
  pushl $0
801074c1:	6a 00                	push   $0x0
  pushl $223
801074c3:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801074c8:	e9 c6 f0 ff ff       	jmp    80106593 <alltraps>

801074cd <vector224>:
.globl vector224
vector224:
  pushl $0
801074cd:	6a 00                	push   $0x0
  pushl $224
801074cf:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801074d4:	e9 ba f0 ff ff       	jmp    80106593 <alltraps>

801074d9 <vector225>:
.globl vector225
vector225:
  pushl $0
801074d9:	6a 00                	push   $0x0
  pushl $225
801074db:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801074e0:	e9 ae f0 ff ff       	jmp    80106593 <alltraps>

801074e5 <vector226>:
.globl vector226
vector226:
  pushl $0
801074e5:	6a 00                	push   $0x0
  pushl $226
801074e7:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801074ec:	e9 a2 f0 ff ff       	jmp    80106593 <alltraps>

801074f1 <vector227>:
.globl vector227
vector227:
  pushl $0
801074f1:	6a 00                	push   $0x0
  pushl $227
801074f3:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801074f8:	e9 96 f0 ff ff       	jmp    80106593 <alltraps>

801074fd <vector228>:
.globl vector228
vector228:
  pushl $0
801074fd:	6a 00                	push   $0x0
  pushl $228
801074ff:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107504:	e9 8a f0 ff ff       	jmp    80106593 <alltraps>

80107509 <vector229>:
.globl vector229
vector229:
  pushl $0
80107509:	6a 00                	push   $0x0
  pushl $229
8010750b:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107510:	e9 7e f0 ff ff       	jmp    80106593 <alltraps>

80107515 <vector230>:
.globl vector230
vector230:
  pushl $0
80107515:	6a 00                	push   $0x0
  pushl $230
80107517:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
8010751c:	e9 72 f0 ff ff       	jmp    80106593 <alltraps>

80107521 <vector231>:
.globl vector231
vector231:
  pushl $0
80107521:	6a 00                	push   $0x0
  pushl $231
80107523:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107528:	e9 66 f0 ff ff       	jmp    80106593 <alltraps>

8010752d <vector232>:
.globl vector232
vector232:
  pushl $0
8010752d:	6a 00                	push   $0x0
  pushl $232
8010752f:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107534:	e9 5a f0 ff ff       	jmp    80106593 <alltraps>

80107539 <vector233>:
.globl vector233
vector233:
  pushl $0
80107539:	6a 00                	push   $0x0
  pushl $233
8010753b:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107540:	e9 4e f0 ff ff       	jmp    80106593 <alltraps>

80107545 <vector234>:
.globl vector234
vector234:
  pushl $0
80107545:	6a 00                	push   $0x0
  pushl $234
80107547:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
8010754c:	e9 42 f0 ff ff       	jmp    80106593 <alltraps>

80107551 <vector235>:
.globl vector235
vector235:
  pushl $0
80107551:	6a 00                	push   $0x0
  pushl $235
80107553:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107558:	e9 36 f0 ff ff       	jmp    80106593 <alltraps>

8010755d <vector236>:
.globl vector236
vector236:
  pushl $0
8010755d:	6a 00                	push   $0x0
  pushl $236
8010755f:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107564:	e9 2a f0 ff ff       	jmp    80106593 <alltraps>

80107569 <vector237>:
.globl vector237
vector237:
  pushl $0
80107569:	6a 00                	push   $0x0
  pushl $237
8010756b:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107570:	e9 1e f0 ff ff       	jmp    80106593 <alltraps>

80107575 <vector238>:
.globl vector238
vector238:
  pushl $0
80107575:	6a 00                	push   $0x0
  pushl $238
80107577:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
8010757c:	e9 12 f0 ff ff       	jmp    80106593 <alltraps>

80107581 <vector239>:
.globl vector239
vector239:
  pushl $0
80107581:	6a 00                	push   $0x0
  pushl $239
80107583:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107588:	e9 06 f0 ff ff       	jmp    80106593 <alltraps>

8010758d <vector240>:
.globl vector240
vector240:
  pushl $0
8010758d:	6a 00                	push   $0x0
  pushl $240
8010758f:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107594:	e9 fa ef ff ff       	jmp    80106593 <alltraps>

80107599 <vector241>:
.globl vector241
vector241:
  pushl $0
80107599:	6a 00                	push   $0x0
  pushl $241
8010759b:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801075a0:	e9 ee ef ff ff       	jmp    80106593 <alltraps>

801075a5 <vector242>:
.globl vector242
vector242:
  pushl $0
801075a5:	6a 00                	push   $0x0
  pushl $242
801075a7:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801075ac:	e9 e2 ef ff ff       	jmp    80106593 <alltraps>

801075b1 <vector243>:
.globl vector243
vector243:
  pushl $0
801075b1:	6a 00                	push   $0x0
  pushl $243
801075b3:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801075b8:	e9 d6 ef ff ff       	jmp    80106593 <alltraps>

801075bd <vector244>:
.globl vector244
vector244:
  pushl $0
801075bd:	6a 00                	push   $0x0
  pushl $244
801075bf:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801075c4:	e9 ca ef ff ff       	jmp    80106593 <alltraps>

801075c9 <vector245>:
.globl vector245
vector245:
  pushl $0
801075c9:	6a 00                	push   $0x0
  pushl $245
801075cb:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801075d0:	e9 be ef ff ff       	jmp    80106593 <alltraps>

801075d5 <vector246>:
.globl vector246
vector246:
  pushl $0
801075d5:	6a 00                	push   $0x0
  pushl $246
801075d7:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801075dc:	e9 b2 ef ff ff       	jmp    80106593 <alltraps>

801075e1 <vector247>:
.globl vector247
vector247:
  pushl $0
801075e1:	6a 00                	push   $0x0
  pushl $247
801075e3:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801075e8:	e9 a6 ef ff ff       	jmp    80106593 <alltraps>

801075ed <vector248>:
.globl vector248
vector248:
  pushl $0
801075ed:	6a 00                	push   $0x0
  pushl $248
801075ef:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801075f4:	e9 9a ef ff ff       	jmp    80106593 <alltraps>

801075f9 <vector249>:
.globl vector249
vector249:
  pushl $0
801075f9:	6a 00                	push   $0x0
  pushl $249
801075fb:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107600:	e9 8e ef ff ff       	jmp    80106593 <alltraps>

80107605 <vector250>:
.globl vector250
vector250:
  pushl $0
80107605:	6a 00                	push   $0x0
  pushl $250
80107607:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010760c:	e9 82 ef ff ff       	jmp    80106593 <alltraps>

80107611 <vector251>:
.globl vector251
vector251:
  pushl $0
80107611:	6a 00                	push   $0x0
  pushl $251
80107613:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107618:	e9 76 ef ff ff       	jmp    80106593 <alltraps>

8010761d <vector252>:
.globl vector252
vector252:
  pushl $0
8010761d:	6a 00                	push   $0x0
  pushl $252
8010761f:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107624:	e9 6a ef ff ff       	jmp    80106593 <alltraps>

80107629 <vector253>:
.globl vector253
vector253:
  pushl $0
80107629:	6a 00                	push   $0x0
  pushl $253
8010762b:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107630:	e9 5e ef ff ff       	jmp    80106593 <alltraps>

80107635 <vector254>:
.globl vector254
vector254:
  pushl $0
80107635:	6a 00                	push   $0x0
  pushl $254
80107637:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
8010763c:	e9 52 ef ff ff       	jmp    80106593 <alltraps>

80107641 <vector255>:
.globl vector255
vector255:
  pushl $0
80107641:	6a 00                	push   $0x0
  pushl $255
80107643:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107648:	e9 46 ef ff ff       	jmp    80106593 <alltraps>

8010764d <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
8010764d:	55                   	push   %ebp
8010764e:	89 e5                	mov    %esp,%ebp
80107650:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107653:	8b 45 0c             	mov    0xc(%ebp),%eax
80107656:	83 e8 01             	sub    $0x1,%eax
80107659:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010765d:	8b 45 08             	mov    0x8(%ebp),%eax
80107660:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107664:	8b 45 08             	mov    0x8(%ebp),%eax
80107667:	c1 e8 10             	shr    $0x10,%eax
8010766a:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
8010766e:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107671:	0f 01 10             	lgdtl  (%eax)
}
80107674:	c9                   	leave  
80107675:	c3                   	ret    

80107676 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107676:	55                   	push   %ebp
80107677:	89 e5                	mov    %esp,%ebp
80107679:	83 ec 04             	sub    $0x4,%esp
8010767c:	8b 45 08             	mov    0x8(%ebp),%eax
8010767f:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107683:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107687:	0f 00 d8             	ltr    %ax
}
8010768a:	c9                   	leave  
8010768b:	c3                   	ret    

8010768c <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
8010768c:	55                   	push   %ebp
8010768d:	89 e5                	mov    %esp,%ebp
8010768f:	83 ec 04             	sub    $0x4,%esp
80107692:	8b 45 08             	mov    0x8(%ebp),%eax
80107695:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107699:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010769d:	8e e8                	mov    %eax,%gs
}
8010769f:	c9                   	leave  
801076a0:	c3                   	ret    

801076a1 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
801076a1:	55                   	push   %ebp
801076a2:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
801076a4:	8b 45 08             	mov    0x8(%ebp),%eax
801076a7:	0f 22 d8             	mov    %eax,%cr3
}
801076aa:	5d                   	pop    %ebp
801076ab:	c3                   	ret    

801076ac <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
801076ac:	55                   	push   %ebp
801076ad:	89 e5                	mov    %esp,%ebp
801076af:	8b 45 08             	mov    0x8(%ebp),%eax
801076b2:	05 00 00 00 80       	add    $0x80000000,%eax
801076b7:	5d                   	pop    %ebp
801076b8:	c3                   	ret    

801076b9 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
801076b9:	55                   	push   %ebp
801076ba:	89 e5                	mov    %esp,%ebp
801076bc:	8b 45 08             	mov    0x8(%ebp),%eax
801076bf:	05 00 00 00 80       	add    $0x80000000,%eax
801076c4:	5d                   	pop    %ebp
801076c5:	c3                   	ret    

801076c6 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801076c6:	55                   	push   %ebp
801076c7:	89 e5                	mov    %esp,%ebp
801076c9:	53                   	push   %ebx
801076ca:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
801076cd:	e8 98 b8 ff ff       	call   80102f6a <cpunum>
801076d2:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801076d8:	05 80 24 11 80       	add    $0x80112480,%eax
801076dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801076e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076e3:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
801076e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076ec:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
801076f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076f5:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
801076f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076fc:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107700:	83 e2 f0             	and    $0xfffffff0,%edx
80107703:	83 ca 0a             	or     $0xa,%edx
80107706:	88 50 7d             	mov    %dl,0x7d(%eax)
80107709:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010770c:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107710:	83 ca 10             	or     $0x10,%edx
80107713:	88 50 7d             	mov    %dl,0x7d(%eax)
80107716:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107719:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010771d:	83 e2 9f             	and    $0xffffff9f,%edx
80107720:	88 50 7d             	mov    %dl,0x7d(%eax)
80107723:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107726:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010772a:	83 ca 80             	or     $0xffffff80,%edx
8010772d:	88 50 7d             	mov    %dl,0x7d(%eax)
80107730:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107733:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107737:	83 ca 0f             	or     $0xf,%edx
8010773a:	88 50 7e             	mov    %dl,0x7e(%eax)
8010773d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107740:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107744:	83 e2 ef             	and    $0xffffffef,%edx
80107747:	88 50 7e             	mov    %dl,0x7e(%eax)
8010774a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010774d:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107751:	83 e2 df             	and    $0xffffffdf,%edx
80107754:	88 50 7e             	mov    %dl,0x7e(%eax)
80107757:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010775a:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010775e:	83 ca 40             	or     $0x40,%edx
80107761:	88 50 7e             	mov    %dl,0x7e(%eax)
80107764:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107767:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010776b:	83 ca 80             	or     $0xffffff80,%edx
8010776e:	88 50 7e             	mov    %dl,0x7e(%eax)
80107771:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107774:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107778:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010777b:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107782:	ff ff 
80107784:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107787:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
8010778e:	00 00 
80107790:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107793:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
8010779a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010779d:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801077a4:	83 e2 f0             	and    $0xfffffff0,%edx
801077a7:	83 ca 02             	or     $0x2,%edx
801077aa:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801077b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077b3:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801077ba:	83 ca 10             	or     $0x10,%edx
801077bd:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801077c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077c6:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801077cd:	83 e2 9f             	and    $0xffffff9f,%edx
801077d0:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801077d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077d9:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801077e0:	83 ca 80             	or     $0xffffff80,%edx
801077e3:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801077e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077ec:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801077f3:	83 ca 0f             	or     $0xf,%edx
801077f6:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801077fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077ff:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107806:	83 e2 ef             	and    $0xffffffef,%edx
80107809:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010780f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107812:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107819:	83 e2 df             	and    $0xffffffdf,%edx
8010781c:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107822:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107825:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010782c:	83 ca 40             	or     $0x40,%edx
8010782f:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107835:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107838:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010783f:	83 ca 80             	or     $0xffffff80,%edx
80107842:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107848:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010784b:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107852:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107855:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
8010785c:	ff ff 
8010785e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107861:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107868:	00 00 
8010786a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010786d:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107874:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107877:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010787e:	83 e2 f0             	and    $0xfffffff0,%edx
80107881:	83 ca 0a             	or     $0xa,%edx
80107884:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010788a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010788d:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107894:	83 ca 10             	or     $0x10,%edx
80107897:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010789d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078a0:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801078a7:	83 ca 60             	or     $0x60,%edx
801078aa:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801078b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078b3:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801078ba:	83 ca 80             	or     $0xffffff80,%edx
801078bd:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801078c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078c6:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801078cd:	83 ca 0f             	or     $0xf,%edx
801078d0:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801078d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078d9:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801078e0:	83 e2 ef             	and    $0xffffffef,%edx
801078e3:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801078e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078ec:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801078f3:	83 e2 df             	and    $0xffffffdf,%edx
801078f6:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801078fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078ff:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107906:	83 ca 40             	or     $0x40,%edx
80107909:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010790f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107912:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107919:	83 ca 80             	or     $0xffffff80,%edx
8010791c:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107922:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107925:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010792c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010792f:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80107936:	ff ff 
80107938:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010793b:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80107942:	00 00 
80107944:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107947:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
8010794e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107951:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107958:	83 e2 f0             	and    $0xfffffff0,%edx
8010795b:	83 ca 02             	or     $0x2,%edx
8010795e:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107964:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107967:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010796e:	83 ca 10             	or     $0x10,%edx
80107971:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107977:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010797a:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107981:	83 ca 60             	or     $0x60,%edx
80107984:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010798a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010798d:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107994:	83 ca 80             	or     $0xffffff80,%edx
80107997:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010799d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079a0:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801079a7:	83 ca 0f             	or     $0xf,%edx
801079aa:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801079b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079b3:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801079ba:	83 e2 ef             	and    $0xffffffef,%edx
801079bd:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801079c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079c6:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801079cd:	83 e2 df             	and    $0xffffffdf,%edx
801079d0:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801079d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079d9:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801079e0:	83 ca 40             	or     $0x40,%edx
801079e3:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801079e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079ec:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801079f3:	83 ca 80             	or     $0xffffff80,%edx
801079f6:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801079fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079ff:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80107a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a09:	05 b4 00 00 00       	add    $0xb4,%eax
80107a0e:	89 c3                	mov    %eax,%ebx
80107a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a13:	05 b4 00 00 00       	add    $0xb4,%eax
80107a18:	c1 e8 10             	shr    $0x10,%eax
80107a1b:	89 c2                	mov    %eax,%edx
80107a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a20:	05 b4 00 00 00       	add    $0xb4,%eax
80107a25:	c1 e8 18             	shr    $0x18,%eax
80107a28:	89 c1                	mov    %eax,%ecx
80107a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a2d:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80107a34:	00 00 
80107a36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a39:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80107a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a43:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
80107a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a4c:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107a53:	83 e2 f0             	and    $0xfffffff0,%edx
80107a56:	83 ca 02             	or     $0x2,%edx
80107a59:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a62:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107a69:	83 ca 10             	or     $0x10,%edx
80107a6c:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a75:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107a7c:	83 e2 9f             	and    $0xffffff9f,%edx
80107a7f:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a88:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107a8f:	83 ca 80             	or     $0xffffff80,%edx
80107a92:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a9b:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107aa2:	83 e2 f0             	and    $0xfffffff0,%edx
80107aa5:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aae:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107ab5:	83 e2 ef             	and    $0xffffffef,%edx
80107ab8:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ac1:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107ac8:	83 e2 df             	and    $0xffffffdf,%edx
80107acb:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ad4:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107adb:	83 ca 40             	or     $0x40,%edx
80107ade:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ae7:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107aee:	83 ca 80             	or     $0xffffff80,%edx
80107af1:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107afa:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80107b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b03:	83 c0 70             	add    $0x70,%eax
80107b06:	83 ec 08             	sub    $0x8,%esp
80107b09:	6a 38                	push   $0x38
80107b0b:	50                   	push   %eax
80107b0c:	e8 3c fb ff ff       	call   8010764d <lgdt>
80107b11:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
80107b14:	83 ec 0c             	sub    $0xc,%esp
80107b17:	6a 18                	push   $0x18
80107b19:	e8 6e fb ff ff       	call   8010768c <loadgs>
80107b1e:	83 c4 10             	add    $0x10,%esp
  
  // Initialize cpu-local storage.
  cpu = c;
80107b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b24:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80107b2a:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80107b31:	00 00 00 00 
}
80107b35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107b38:	c9                   	leave  
80107b39:	c3                   	ret    

80107b3a <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107b3a:	55                   	push   %ebp
80107b3b:	89 e5                	mov    %esp,%ebp
80107b3d:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107b40:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b43:	c1 e8 16             	shr    $0x16,%eax
80107b46:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107b4d:	8b 45 08             	mov    0x8(%ebp),%eax
80107b50:	01 d0                	add    %edx,%eax
80107b52:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80107b55:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b58:	8b 00                	mov    (%eax),%eax
80107b5a:	83 e0 01             	and    $0x1,%eax
80107b5d:	85 c0                	test   %eax,%eax
80107b5f:	74 18                	je     80107b79 <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80107b61:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b64:	8b 00                	mov    (%eax),%eax
80107b66:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107b6b:	50                   	push   %eax
80107b6c:	e8 48 fb ff ff       	call   801076b9 <p2v>
80107b71:	83 c4 04             	add    $0x4,%esp
80107b74:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107b77:	eb 48                	jmp    80107bc1 <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107b79:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80107b7d:	74 0e                	je     80107b8d <walkpgdir+0x53>
80107b7f:	e8 85 b0 ff ff       	call   80102c09 <kalloc>
80107b84:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107b87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107b8b:	75 07                	jne    80107b94 <walkpgdir+0x5a>
      return 0;
80107b8d:	b8 00 00 00 00       	mov    $0x0,%eax
80107b92:	eb 44                	jmp    80107bd8 <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80107b94:	83 ec 04             	sub    $0x4,%esp
80107b97:	68 00 10 00 00       	push   $0x1000
80107b9c:	6a 00                	push   $0x0
80107b9e:	ff 75 f4             	pushl  -0xc(%ebp)
80107ba1:	e8 31 d6 ff ff       	call   801051d7 <memset>
80107ba6:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80107ba9:	83 ec 0c             	sub    $0xc,%esp
80107bac:	ff 75 f4             	pushl  -0xc(%ebp)
80107baf:	e8 f8 fa ff ff       	call   801076ac <v2p>
80107bb4:	83 c4 10             	add    $0x10,%esp
80107bb7:	83 c8 07             	or     $0x7,%eax
80107bba:	89 c2                	mov    %eax,%edx
80107bbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107bbf:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80107bc1:	8b 45 0c             	mov    0xc(%ebp),%eax
80107bc4:	c1 e8 0c             	shr    $0xc,%eax
80107bc7:	25 ff 03 00 00       	and    $0x3ff,%eax
80107bcc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bd6:	01 d0                	add    %edx,%eax
}
80107bd8:	c9                   	leave  
80107bd9:	c3                   	ret    

80107bda <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107bda:	55                   	push   %ebp
80107bdb:	89 e5                	mov    %esp,%ebp
80107bdd:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80107be0:	8b 45 0c             	mov    0xc(%ebp),%eax
80107be3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107be8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107beb:	8b 55 0c             	mov    0xc(%ebp),%edx
80107bee:	8b 45 10             	mov    0x10(%ebp),%eax
80107bf1:	01 d0                	add    %edx,%eax
80107bf3:	83 e8 01             	sub    $0x1,%eax
80107bf6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107bfb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107bfe:	83 ec 04             	sub    $0x4,%esp
80107c01:	6a 01                	push   $0x1
80107c03:	ff 75 f4             	pushl  -0xc(%ebp)
80107c06:	ff 75 08             	pushl  0x8(%ebp)
80107c09:	e8 2c ff ff ff       	call   80107b3a <walkpgdir>
80107c0e:	83 c4 10             	add    $0x10,%esp
80107c11:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107c14:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107c18:	75 07                	jne    80107c21 <mappages+0x47>
      return -1;
80107c1a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107c1f:	eb 49                	jmp    80107c6a <mappages+0x90>
    if(*pte & PTE_P)
80107c21:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107c24:	8b 00                	mov    (%eax),%eax
80107c26:	83 e0 01             	and    $0x1,%eax
80107c29:	85 c0                	test   %eax,%eax
80107c2b:	74 0d                	je     80107c3a <mappages+0x60>
      panic("remap");
80107c2d:	83 ec 0c             	sub    $0xc,%esp
80107c30:	68 7c 8a 10 80       	push   $0x80108a7c
80107c35:	e8 22 89 ff ff       	call   8010055c <panic>
    *pte = pa | perm | PTE_P;
80107c3a:	8b 45 18             	mov    0x18(%ebp),%eax
80107c3d:	0b 45 14             	or     0x14(%ebp),%eax
80107c40:	83 c8 01             	or     $0x1,%eax
80107c43:	89 c2                	mov    %eax,%edx
80107c45:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107c48:	89 10                	mov    %edx,(%eax)
    if(a == last)
80107c4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c4d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107c50:	75 08                	jne    80107c5a <mappages+0x80>
      break;
80107c52:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80107c53:	b8 00 00 00 00       	mov    $0x0,%eax
80107c58:	eb 10                	jmp    80107c6a <mappages+0x90>
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
80107c5a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80107c61:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80107c68:	eb 94                	jmp    80107bfe <mappages+0x24>
  return 0;
}
80107c6a:	c9                   	leave  
80107c6b:	c3                   	ret    

80107c6c <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107c6c:	55                   	push   %ebp
80107c6d:	89 e5                	mov    %esp,%ebp
80107c6f:	53                   	push   %ebx
80107c70:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107c73:	e8 91 af ff ff       	call   80102c09 <kalloc>
80107c78:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107c7b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107c7f:	75 0a                	jne    80107c8b <setupkvm+0x1f>
    return 0;
80107c81:	b8 00 00 00 00       	mov    $0x0,%eax
80107c86:	e9 8e 00 00 00       	jmp    80107d19 <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
80107c8b:	83 ec 04             	sub    $0x4,%esp
80107c8e:	68 00 10 00 00       	push   $0x1000
80107c93:	6a 00                	push   $0x0
80107c95:	ff 75 f0             	pushl  -0x10(%ebp)
80107c98:	e8 3a d5 ff ff       	call   801051d7 <memset>
80107c9d:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80107ca0:	83 ec 0c             	sub    $0xc,%esp
80107ca3:	68 00 00 00 0e       	push   $0xe000000
80107ca8:	e8 0c fa ff ff       	call   801076b9 <p2v>
80107cad:	83 c4 10             	add    $0x10,%esp
80107cb0:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80107cb5:	76 0d                	jbe    80107cc4 <setupkvm+0x58>
    panic("PHYSTOP too high");
80107cb7:	83 ec 0c             	sub    $0xc,%esp
80107cba:	68 82 8a 10 80       	push   $0x80108a82
80107cbf:	e8 98 88 ff ff       	call   8010055c <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107cc4:	c7 45 f4 c0 b4 10 80 	movl   $0x8010b4c0,-0xc(%ebp)
80107ccb:	eb 40                	jmp    80107d0d <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80107ccd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cd0:	8b 48 0c             	mov    0xc(%eax),%ecx
80107cd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cd6:	8b 50 04             	mov    0x4(%eax),%edx
80107cd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cdc:	8b 58 08             	mov    0x8(%eax),%ebx
80107cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ce2:	8b 40 04             	mov    0x4(%eax),%eax
80107ce5:	29 c3                	sub    %eax,%ebx
80107ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cea:	8b 00                	mov    (%eax),%eax
80107cec:	83 ec 0c             	sub    $0xc,%esp
80107cef:	51                   	push   %ecx
80107cf0:	52                   	push   %edx
80107cf1:	53                   	push   %ebx
80107cf2:	50                   	push   %eax
80107cf3:	ff 75 f0             	pushl  -0x10(%ebp)
80107cf6:	e8 df fe ff ff       	call   80107bda <mappages>
80107cfb:	83 c4 20             	add    $0x20,%esp
80107cfe:	85 c0                	test   %eax,%eax
80107d00:	79 07                	jns    80107d09 <setupkvm+0x9d>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80107d02:	b8 00 00 00 00       	mov    $0x0,%eax
80107d07:	eb 10                	jmp    80107d19 <setupkvm+0xad>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107d09:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80107d0d:	81 7d f4 00 b5 10 80 	cmpl   $0x8010b500,-0xc(%ebp)
80107d14:	72 b7                	jb     80107ccd <setupkvm+0x61>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80107d16:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107d19:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107d1c:	c9                   	leave  
80107d1d:	c3                   	ret    

80107d1e <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107d1e:	55                   	push   %ebp
80107d1f:	89 e5                	mov    %esp,%ebp
80107d21:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107d24:	e8 43 ff ff ff       	call   80107c6c <setupkvm>
80107d29:	a3 58 52 11 80       	mov    %eax,0x80115258
  switchkvm();
80107d2e:	e8 02 00 00 00       	call   80107d35 <switchkvm>
}
80107d33:	c9                   	leave  
80107d34:	c3                   	ret    

80107d35 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107d35:	55                   	push   %ebp
80107d36:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80107d38:	a1 58 52 11 80       	mov    0x80115258,%eax
80107d3d:	50                   	push   %eax
80107d3e:	e8 69 f9 ff ff       	call   801076ac <v2p>
80107d43:	83 c4 04             	add    $0x4,%esp
80107d46:	50                   	push   %eax
80107d47:	e8 55 f9 ff ff       	call   801076a1 <lcr3>
80107d4c:	83 c4 04             	add    $0x4,%esp
}
80107d4f:	c9                   	leave  
80107d50:	c3                   	ret    

80107d51 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107d51:	55                   	push   %ebp
80107d52:	89 e5                	mov    %esp,%ebp
80107d54:	56                   	push   %esi
80107d55:	53                   	push   %ebx
  pushcli();
80107d56:	e8 7a d3 ff ff       	call   801050d5 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80107d5b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107d61:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107d68:	83 c2 08             	add    $0x8,%edx
80107d6b:	89 d6                	mov    %edx,%esi
80107d6d:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107d74:	83 c2 08             	add    $0x8,%edx
80107d77:	c1 ea 10             	shr    $0x10,%edx
80107d7a:	89 d3                	mov    %edx,%ebx
80107d7c:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107d83:	83 c2 08             	add    $0x8,%edx
80107d86:	c1 ea 18             	shr    $0x18,%edx
80107d89:	89 d1                	mov    %edx,%ecx
80107d8b:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80107d92:	67 00 
80107d94:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
80107d9b:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
80107da1:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107da8:	83 e2 f0             	and    $0xfffffff0,%edx
80107dab:	83 ca 09             	or     $0x9,%edx
80107dae:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107db4:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107dbb:	83 ca 10             	or     $0x10,%edx
80107dbe:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107dc4:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107dcb:	83 e2 9f             	and    $0xffffff9f,%edx
80107dce:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107dd4:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107ddb:	83 ca 80             	or     $0xffffff80,%edx
80107dde:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107de4:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80107deb:	83 e2 f0             	and    $0xfffffff0,%edx
80107dee:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107df4:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80107dfb:	83 e2 ef             	and    $0xffffffef,%edx
80107dfe:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107e04:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80107e0b:	83 e2 df             	and    $0xffffffdf,%edx
80107e0e:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107e14:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80107e1b:	83 ca 40             	or     $0x40,%edx
80107e1e:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107e24:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80107e2b:	83 e2 7f             	and    $0x7f,%edx
80107e2e:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107e34:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80107e3a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107e40:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107e47:	83 e2 ef             	and    $0xffffffef,%edx
80107e4a:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80107e50:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107e56:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80107e5c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107e62:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80107e69:	8b 52 08             	mov    0x8(%edx),%edx
80107e6c:	81 c2 00 10 00 00    	add    $0x1000,%edx
80107e72:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80107e75:	83 ec 0c             	sub    $0xc,%esp
80107e78:	6a 30                	push   $0x30
80107e7a:	e8 f7 f7 ff ff       	call   80107676 <ltr>
80107e7f:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
80107e82:	8b 45 08             	mov    0x8(%ebp),%eax
80107e85:	8b 40 04             	mov    0x4(%eax),%eax
80107e88:	85 c0                	test   %eax,%eax
80107e8a:	75 0d                	jne    80107e99 <switchuvm+0x148>
    panic("switchuvm: no pgdir");
80107e8c:	83 ec 0c             	sub    $0xc,%esp
80107e8f:	68 93 8a 10 80       	push   $0x80108a93
80107e94:	e8 c3 86 ff ff       	call   8010055c <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80107e99:	8b 45 08             	mov    0x8(%ebp),%eax
80107e9c:	8b 40 04             	mov    0x4(%eax),%eax
80107e9f:	83 ec 0c             	sub    $0xc,%esp
80107ea2:	50                   	push   %eax
80107ea3:	e8 04 f8 ff ff       	call   801076ac <v2p>
80107ea8:	83 c4 10             	add    $0x10,%esp
80107eab:	83 ec 0c             	sub    $0xc,%esp
80107eae:	50                   	push   %eax
80107eaf:	e8 ed f7 ff ff       	call   801076a1 <lcr3>
80107eb4:	83 c4 10             	add    $0x10,%esp
  popcli();
80107eb7:	e8 5d d2 ff ff       	call   80105119 <popcli>
}
80107ebc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107ebf:	5b                   	pop    %ebx
80107ec0:	5e                   	pop    %esi
80107ec1:	5d                   	pop    %ebp
80107ec2:	c3                   	ret    

80107ec3 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107ec3:	55                   	push   %ebp
80107ec4:	89 e5                	mov    %esp,%ebp
80107ec6:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80107ec9:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80107ed0:	76 0d                	jbe    80107edf <inituvm+0x1c>
    panic("inituvm: more than a page");
80107ed2:	83 ec 0c             	sub    $0xc,%esp
80107ed5:	68 a7 8a 10 80       	push   $0x80108aa7
80107eda:	e8 7d 86 ff ff       	call   8010055c <panic>
  mem = kalloc();
80107edf:	e8 25 ad ff ff       	call   80102c09 <kalloc>
80107ee4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80107ee7:	83 ec 04             	sub    $0x4,%esp
80107eea:	68 00 10 00 00       	push   $0x1000
80107eef:	6a 00                	push   $0x0
80107ef1:	ff 75 f4             	pushl  -0xc(%ebp)
80107ef4:	e8 de d2 ff ff       	call   801051d7 <memset>
80107ef9:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80107efc:	83 ec 0c             	sub    $0xc,%esp
80107eff:	ff 75 f4             	pushl  -0xc(%ebp)
80107f02:	e8 a5 f7 ff ff       	call   801076ac <v2p>
80107f07:	83 c4 10             	add    $0x10,%esp
80107f0a:	83 ec 0c             	sub    $0xc,%esp
80107f0d:	6a 06                	push   $0x6
80107f0f:	50                   	push   %eax
80107f10:	68 00 10 00 00       	push   $0x1000
80107f15:	6a 00                	push   $0x0
80107f17:	ff 75 08             	pushl  0x8(%ebp)
80107f1a:	e8 bb fc ff ff       	call   80107bda <mappages>
80107f1f:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
80107f22:	83 ec 04             	sub    $0x4,%esp
80107f25:	ff 75 10             	pushl  0x10(%ebp)
80107f28:	ff 75 0c             	pushl  0xc(%ebp)
80107f2b:	ff 75 f4             	pushl  -0xc(%ebp)
80107f2e:	e8 63 d3 ff ff       	call   80105296 <memmove>
80107f33:	83 c4 10             	add    $0x10,%esp
}
80107f36:	c9                   	leave  
80107f37:	c3                   	ret    

80107f38 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107f38:	55                   	push   %ebp
80107f39:	89 e5                	mov    %esp,%ebp
80107f3b:	53                   	push   %ebx
80107f3c:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107f3f:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f42:	25 ff 0f 00 00       	and    $0xfff,%eax
80107f47:	85 c0                	test   %eax,%eax
80107f49:	74 0d                	je     80107f58 <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
80107f4b:	83 ec 0c             	sub    $0xc,%esp
80107f4e:	68 c4 8a 10 80       	push   $0x80108ac4
80107f53:	e8 04 86 ff ff       	call   8010055c <panic>
  for(i = 0; i < sz; i += PGSIZE){
80107f58:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107f5f:	e9 95 00 00 00       	jmp    80107ff9 <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107f64:	8b 55 0c             	mov    0xc(%ebp),%edx
80107f67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f6a:	01 d0                	add    %edx,%eax
80107f6c:	83 ec 04             	sub    $0x4,%esp
80107f6f:	6a 00                	push   $0x0
80107f71:	50                   	push   %eax
80107f72:	ff 75 08             	pushl  0x8(%ebp)
80107f75:	e8 c0 fb ff ff       	call   80107b3a <walkpgdir>
80107f7a:	83 c4 10             	add    $0x10,%esp
80107f7d:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107f80:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107f84:	75 0d                	jne    80107f93 <loaduvm+0x5b>
      panic("loaduvm: address should exist");
80107f86:	83 ec 0c             	sub    $0xc,%esp
80107f89:	68 e7 8a 10 80       	push   $0x80108ae7
80107f8e:	e8 c9 85 ff ff       	call   8010055c <panic>
    pa = PTE_ADDR(*pte);
80107f93:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107f96:	8b 00                	mov    (%eax),%eax
80107f98:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107f9d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80107fa0:	8b 45 18             	mov    0x18(%ebp),%eax
80107fa3:	2b 45 f4             	sub    -0xc(%ebp),%eax
80107fa6:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80107fab:	77 0b                	ja     80107fb8 <loaduvm+0x80>
      n = sz - i;
80107fad:	8b 45 18             	mov    0x18(%ebp),%eax
80107fb0:	2b 45 f4             	sub    -0xc(%ebp),%eax
80107fb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107fb6:	eb 07                	jmp    80107fbf <loaduvm+0x87>
    else
      n = PGSIZE;
80107fb8:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80107fbf:	8b 55 14             	mov    0x14(%ebp),%edx
80107fc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fc5:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80107fc8:	83 ec 0c             	sub    $0xc,%esp
80107fcb:	ff 75 e8             	pushl  -0x18(%ebp)
80107fce:	e8 e6 f6 ff ff       	call   801076b9 <p2v>
80107fd3:	83 c4 10             	add    $0x10,%esp
80107fd6:	ff 75 f0             	pushl  -0x10(%ebp)
80107fd9:	53                   	push   %ebx
80107fda:	50                   	push   %eax
80107fdb:	ff 75 10             	pushl  0x10(%ebp)
80107fde:	e8 a3 9e ff ff       	call   80101e86 <readi>
80107fe3:	83 c4 10             	add    $0x10,%esp
80107fe6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107fe9:	74 07                	je     80107ff2 <loaduvm+0xba>
      return -1;
80107feb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107ff0:	eb 18                	jmp    8010800a <loaduvm+0xd2>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80107ff2:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ffc:	3b 45 18             	cmp    0x18(%ebp),%eax
80107fff:	0f 82 5f ff ff ff    	jb     80107f64 <loaduvm+0x2c>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80108005:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010800a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010800d:	c9                   	leave  
8010800e:	c3                   	ret    

8010800f <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010800f:	55                   	push   %ebp
80108010:	89 e5                	mov    %esp,%ebp
80108012:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80108015:	8b 45 10             	mov    0x10(%ebp),%eax
80108018:	85 c0                	test   %eax,%eax
8010801a:	79 0a                	jns    80108026 <allocuvm+0x17>
    return 0;
8010801c:	b8 00 00 00 00       	mov    $0x0,%eax
80108021:	e9 b0 00 00 00       	jmp    801080d6 <allocuvm+0xc7>
  if(newsz < oldsz)
80108026:	8b 45 10             	mov    0x10(%ebp),%eax
80108029:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010802c:	73 08                	jae    80108036 <allocuvm+0x27>
    return oldsz;
8010802e:	8b 45 0c             	mov    0xc(%ebp),%eax
80108031:	e9 a0 00 00 00       	jmp    801080d6 <allocuvm+0xc7>

  a = PGROUNDUP(oldsz);
80108036:	8b 45 0c             	mov    0xc(%ebp),%eax
80108039:	05 ff 0f 00 00       	add    $0xfff,%eax
8010803e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108043:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80108046:	eb 7f                	jmp    801080c7 <allocuvm+0xb8>
    mem = kalloc();
80108048:	e8 bc ab ff ff       	call   80102c09 <kalloc>
8010804d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80108050:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108054:	75 2b                	jne    80108081 <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
80108056:	83 ec 0c             	sub    $0xc,%esp
80108059:	68 05 8b 10 80       	push   $0x80108b05
8010805e:	e8 5c 83 ff ff       	call   801003bf <cprintf>
80108063:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80108066:	83 ec 04             	sub    $0x4,%esp
80108069:	ff 75 0c             	pushl  0xc(%ebp)
8010806c:	ff 75 10             	pushl  0x10(%ebp)
8010806f:	ff 75 08             	pushl  0x8(%ebp)
80108072:	e8 61 00 00 00       	call   801080d8 <deallocuvm>
80108077:	83 c4 10             	add    $0x10,%esp
      return 0;
8010807a:	b8 00 00 00 00       	mov    $0x0,%eax
8010807f:	eb 55                	jmp    801080d6 <allocuvm+0xc7>
    }
    memset(mem, 0, PGSIZE);
80108081:	83 ec 04             	sub    $0x4,%esp
80108084:	68 00 10 00 00       	push   $0x1000
80108089:	6a 00                	push   $0x0
8010808b:	ff 75 f0             	pushl  -0x10(%ebp)
8010808e:	e8 44 d1 ff ff       	call   801051d7 <memset>
80108093:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108096:	83 ec 0c             	sub    $0xc,%esp
80108099:	ff 75 f0             	pushl  -0x10(%ebp)
8010809c:	e8 0b f6 ff ff       	call   801076ac <v2p>
801080a1:	83 c4 10             	add    $0x10,%esp
801080a4:	89 c2                	mov    %eax,%edx
801080a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080a9:	83 ec 0c             	sub    $0xc,%esp
801080ac:	6a 06                	push   $0x6
801080ae:	52                   	push   %edx
801080af:	68 00 10 00 00       	push   $0x1000
801080b4:	50                   	push   %eax
801080b5:	ff 75 08             	pushl  0x8(%ebp)
801080b8:	e8 1d fb ff ff       	call   80107bda <mappages>
801080bd:	83 c4 20             	add    $0x20,%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
801080c0:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801080c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080ca:	3b 45 10             	cmp    0x10(%ebp),%eax
801080cd:	0f 82 75 ff ff ff    	jb     80108048 <allocuvm+0x39>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
801080d3:	8b 45 10             	mov    0x10(%ebp),%eax
}
801080d6:	c9                   	leave  
801080d7:	c3                   	ret    

801080d8 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801080d8:	55                   	push   %ebp
801080d9:	89 e5                	mov    %esp,%ebp
801080db:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801080de:	8b 45 10             	mov    0x10(%ebp),%eax
801080e1:	3b 45 0c             	cmp    0xc(%ebp),%eax
801080e4:	72 08                	jb     801080ee <deallocuvm+0x16>
    return oldsz;
801080e6:	8b 45 0c             	mov    0xc(%ebp),%eax
801080e9:	e9 a5 00 00 00       	jmp    80108193 <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
801080ee:	8b 45 10             	mov    0x10(%ebp),%eax
801080f1:	05 ff 0f 00 00       	add    $0xfff,%eax
801080f6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801080fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801080fe:	e9 81 00 00 00       	jmp    80108184 <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
80108103:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108106:	83 ec 04             	sub    $0x4,%esp
80108109:	6a 00                	push   $0x0
8010810b:	50                   	push   %eax
8010810c:	ff 75 08             	pushl  0x8(%ebp)
8010810f:	e8 26 fa ff ff       	call   80107b3a <walkpgdir>
80108114:	83 c4 10             	add    $0x10,%esp
80108117:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
8010811a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010811e:	75 09                	jne    80108129 <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
80108120:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80108127:	eb 54                	jmp    8010817d <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
80108129:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010812c:	8b 00                	mov    (%eax),%eax
8010812e:	83 e0 01             	and    $0x1,%eax
80108131:	85 c0                	test   %eax,%eax
80108133:	74 48                	je     8010817d <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
80108135:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108138:	8b 00                	mov    (%eax),%eax
8010813a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010813f:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80108142:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108146:	75 0d                	jne    80108155 <deallocuvm+0x7d>
        panic("kfree");
80108148:	83 ec 0c             	sub    $0xc,%esp
8010814b:	68 1d 8b 10 80       	push   $0x80108b1d
80108150:	e8 07 84 ff ff       	call   8010055c <panic>
      char *v = p2v(pa);
80108155:	83 ec 0c             	sub    $0xc,%esp
80108158:	ff 75 ec             	pushl  -0x14(%ebp)
8010815b:	e8 59 f5 ff ff       	call   801076b9 <p2v>
80108160:	83 c4 10             	add    $0x10,%esp
80108163:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80108166:	83 ec 0c             	sub    $0xc,%esp
80108169:	ff 75 e8             	pushl  -0x18(%ebp)
8010816c:	e8 fc a9 ff ff       	call   80102b6d <kfree>
80108171:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80108174:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108177:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010817d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108184:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108187:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010818a:	0f 82 73 ff ff ff    	jb     80108103 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80108190:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108193:	c9                   	leave  
80108194:	c3                   	ret    

80108195 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108195:	55                   	push   %ebp
80108196:	89 e5                	mov    %esp,%ebp
80108198:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
8010819b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010819f:	75 0d                	jne    801081ae <freevm+0x19>
    panic("freevm: no pgdir");
801081a1:	83 ec 0c             	sub    $0xc,%esp
801081a4:	68 23 8b 10 80       	push   $0x80108b23
801081a9:	e8 ae 83 ff ff       	call   8010055c <panic>
  deallocuvm(pgdir, KERNBASE, 0);
801081ae:	83 ec 04             	sub    $0x4,%esp
801081b1:	6a 00                	push   $0x0
801081b3:	68 00 00 00 80       	push   $0x80000000
801081b8:	ff 75 08             	pushl  0x8(%ebp)
801081bb:	e8 18 ff ff ff       	call   801080d8 <deallocuvm>
801081c0:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801081c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801081ca:	eb 4f                	jmp    8010821b <freevm+0x86>
    if(pgdir[i] & PTE_P){
801081cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801081d6:	8b 45 08             	mov    0x8(%ebp),%eax
801081d9:	01 d0                	add    %edx,%eax
801081db:	8b 00                	mov    (%eax),%eax
801081dd:	83 e0 01             	and    $0x1,%eax
801081e0:	85 c0                	test   %eax,%eax
801081e2:	74 33                	je     80108217 <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
801081e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081e7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801081ee:	8b 45 08             	mov    0x8(%ebp),%eax
801081f1:	01 d0                	add    %edx,%eax
801081f3:	8b 00                	mov    (%eax),%eax
801081f5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801081fa:	83 ec 0c             	sub    $0xc,%esp
801081fd:	50                   	push   %eax
801081fe:	e8 b6 f4 ff ff       	call   801076b9 <p2v>
80108203:	83 c4 10             	add    $0x10,%esp
80108206:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80108209:	83 ec 0c             	sub    $0xc,%esp
8010820c:	ff 75 f0             	pushl  -0x10(%ebp)
8010820f:	e8 59 a9 ff ff       	call   80102b6d <kfree>
80108214:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80108217:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010821b:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80108222:	76 a8                	jbe    801081cc <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80108224:	83 ec 0c             	sub    $0xc,%esp
80108227:	ff 75 08             	pushl  0x8(%ebp)
8010822a:	e8 3e a9 ff ff       	call   80102b6d <kfree>
8010822f:	83 c4 10             	add    $0x10,%esp
}
80108232:	c9                   	leave  
80108233:	c3                   	ret    

80108234 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108234:	55                   	push   %ebp
80108235:	89 e5                	mov    %esp,%ebp
80108237:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010823a:	83 ec 04             	sub    $0x4,%esp
8010823d:	6a 00                	push   $0x0
8010823f:	ff 75 0c             	pushl  0xc(%ebp)
80108242:	ff 75 08             	pushl  0x8(%ebp)
80108245:	e8 f0 f8 ff ff       	call   80107b3a <walkpgdir>
8010824a:	83 c4 10             	add    $0x10,%esp
8010824d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108250:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108254:	75 0d                	jne    80108263 <clearpteu+0x2f>
    panic("clearpteu");
80108256:	83 ec 0c             	sub    $0xc,%esp
80108259:	68 34 8b 10 80       	push   $0x80108b34
8010825e:	e8 f9 82 ff ff       	call   8010055c <panic>
  *pte &= ~PTE_U;
80108263:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108266:	8b 00                	mov    (%eax),%eax
80108268:	83 e0 fb             	and    $0xfffffffb,%eax
8010826b:	89 c2                	mov    %eax,%edx
8010826d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108270:	89 10                	mov    %edx,(%eax)
}
80108272:	c9                   	leave  
80108273:	c3                   	ret    

80108274 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108274:	55                   	push   %ebp
80108275:	89 e5                	mov    %esp,%ebp
80108277:	53                   	push   %ebx
80108278:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010827b:	e8 ec f9 ff ff       	call   80107c6c <setupkvm>
80108280:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108283:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108287:	75 0a                	jne    80108293 <copyuvm+0x1f>
    return 0;
80108289:	b8 00 00 00 00       	mov    $0x0,%eax
8010828e:	e9 f8 00 00 00       	jmp    8010838b <copyuvm+0x117>
  for(i = 0; i < sz; i += PGSIZE){
80108293:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010829a:	e9 c8 00 00 00       	jmp    80108367 <copyuvm+0xf3>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
8010829f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082a2:	83 ec 04             	sub    $0x4,%esp
801082a5:	6a 00                	push   $0x0
801082a7:	50                   	push   %eax
801082a8:	ff 75 08             	pushl  0x8(%ebp)
801082ab:	e8 8a f8 ff ff       	call   80107b3a <walkpgdir>
801082b0:	83 c4 10             	add    $0x10,%esp
801082b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
801082b6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801082ba:	75 0d                	jne    801082c9 <copyuvm+0x55>
      panic("copyuvm: pte should exist");
801082bc:	83 ec 0c             	sub    $0xc,%esp
801082bf:	68 3e 8b 10 80       	push   $0x80108b3e
801082c4:	e8 93 82 ff ff       	call   8010055c <panic>
    if(!(*pte & PTE_P))
801082c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801082cc:	8b 00                	mov    (%eax),%eax
801082ce:	83 e0 01             	and    $0x1,%eax
801082d1:	85 c0                	test   %eax,%eax
801082d3:	75 0d                	jne    801082e2 <copyuvm+0x6e>
      panic("copyuvm: page not present");
801082d5:	83 ec 0c             	sub    $0xc,%esp
801082d8:	68 58 8b 10 80       	push   $0x80108b58
801082dd:	e8 7a 82 ff ff       	call   8010055c <panic>
    pa = PTE_ADDR(*pte);
801082e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801082e5:	8b 00                	mov    (%eax),%eax
801082e7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801082ec:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
801082ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
801082f2:	8b 00                	mov    (%eax),%eax
801082f4:	25 ff 0f 00 00       	and    $0xfff,%eax
801082f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
801082fc:	e8 08 a9 ff ff       	call   80102c09 <kalloc>
80108301:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108304:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80108308:	75 02                	jne    8010830c <copyuvm+0x98>
      goto bad;
8010830a:	eb 6c                	jmp    80108378 <copyuvm+0x104>
    memmove(mem, (char*)p2v(pa), PGSIZE);
8010830c:	83 ec 0c             	sub    $0xc,%esp
8010830f:	ff 75 e8             	pushl  -0x18(%ebp)
80108312:	e8 a2 f3 ff ff       	call   801076b9 <p2v>
80108317:	83 c4 10             	add    $0x10,%esp
8010831a:	83 ec 04             	sub    $0x4,%esp
8010831d:	68 00 10 00 00       	push   $0x1000
80108322:	50                   	push   %eax
80108323:	ff 75 e0             	pushl  -0x20(%ebp)
80108326:	e8 6b cf ff ff       	call   80105296 <memmove>
8010832b:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
8010832e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80108331:	83 ec 0c             	sub    $0xc,%esp
80108334:	ff 75 e0             	pushl  -0x20(%ebp)
80108337:	e8 70 f3 ff ff       	call   801076ac <v2p>
8010833c:	83 c4 10             	add    $0x10,%esp
8010833f:	89 c2                	mov    %eax,%edx
80108341:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108344:	83 ec 0c             	sub    $0xc,%esp
80108347:	53                   	push   %ebx
80108348:	52                   	push   %edx
80108349:	68 00 10 00 00       	push   $0x1000
8010834e:	50                   	push   %eax
8010834f:	ff 75 f0             	pushl  -0x10(%ebp)
80108352:	e8 83 f8 ff ff       	call   80107bda <mappages>
80108357:	83 c4 20             	add    $0x20,%esp
8010835a:	85 c0                	test   %eax,%eax
8010835c:	79 02                	jns    80108360 <copyuvm+0xec>
      goto bad;
8010835e:	eb 18                	jmp    80108378 <copyuvm+0x104>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108360:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108367:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010836a:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010836d:	0f 82 2c ff ff ff    	jb     8010829f <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
80108373:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108376:	eb 13                	jmp    8010838b <copyuvm+0x117>

bad:
  freevm(d);
80108378:	83 ec 0c             	sub    $0xc,%esp
8010837b:	ff 75 f0             	pushl  -0x10(%ebp)
8010837e:	e8 12 fe ff ff       	call   80108195 <freevm>
80108383:	83 c4 10             	add    $0x10,%esp
  return 0;
80108386:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010838b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010838e:	c9                   	leave  
8010838f:	c3                   	ret    

80108390 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108390:	55                   	push   %ebp
80108391:	89 e5                	mov    %esp,%ebp
80108393:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108396:	83 ec 04             	sub    $0x4,%esp
80108399:	6a 00                	push   $0x0
8010839b:	ff 75 0c             	pushl  0xc(%ebp)
8010839e:	ff 75 08             	pushl  0x8(%ebp)
801083a1:	e8 94 f7 ff ff       	call   80107b3a <walkpgdir>
801083a6:	83 c4 10             	add    $0x10,%esp
801083a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
801083ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083af:	8b 00                	mov    (%eax),%eax
801083b1:	83 e0 01             	and    $0x1,%eax
801083b4:	85 c0                	test   %eax,%eax
801083b6:	75 07                	jne    801083bf <uva2ka+0x2f>
    return 0;
801083b8:	b8 00 00 00 00       	mov    $0x0,%eax
801083bd:	eb 29                	jmp    801083e8 <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
801083bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083c2:	8b 00                	mov    (%eax),%eax
801083c4:	83 e0 04             	and    $0x4,%eax
801083c7:	85 c0                	test   %eax,%eax
801083c9:	75 07                	jne    801083d2 <uva2ka+0x42>
    return 0;
801083cb:	b8 00 00 00 00       	mov    $0x0,%eax
801083d0:	eb 16                	jmp    801083e8 <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
801083d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083d5:	8b 00                	mov    (%eax),%eax
801083d7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801083dc:	83 ec 0c             	sub    $0xc,%esp
801083df:	50                   	push   %eax
801083e0:	e8 d4 f2 ff ff       	call   801076b9 <p2v>
801083e5:	83 c4 10             	add    $0x10,%esp
}
801083e8:	c9                   	leave  
801083e9:	c3                   	ret    

801083ea <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801083ea:	55                   	push   %ebp
801083eb:	89 e5                	mov    %esp,%ebp
801083ed:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
801083f0:	8b 45 10             	mov    0x10(%ebp),%eax
801083f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
801083f6:	eb 7f                	jmp    80108477 <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
801083f8:	8b 45 0c             	mov    0xc(%ebp),%eax
801083fb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108400:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108403:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108406:	83 ec 08             	sub    $0x8,%esp
80108409:	50                   	push   %eax
8010840a:	ff 75 08             	pushl  0x8(%ebp)
8010840d:	e8 7e ff ff ff       	call   80108390 <uva2ka>
80108412:	83 c4 10             	add    $0x10,%esp
80108415:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108418:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010841c:	75 07                	jne    80108425 <copyout+0x3b>
      return -1;
8010841e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108423:	eb 61                	jmp    80108486 <copyout+0x9c>
    n = PGSIZE - (va - va0);
80108425:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108428:	2b 45 0c             	sub    0xc(%ebp),%eax
8010842b:	05 00 10 00 00       	add    $0x1000,%eax
80108430:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108433:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108436:	3b 45 14             	cmp    0x14(%ebp),%eax
80108439:	76 06                	jbe    80108441 <copyout+0x57>
      n = len;
8010843b:	8b 45 14             	mov    0x14(%ebp),%eax
8010843e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108441:	8b 45 0c             	mov    0xc(%ebp),%eax
80108444:	2b 45 ec             	sub    -0x14(%ebp),%eax
80108447:	89 c2                	mov    %eax,%edx
80108449:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010844c:	01 d0                	add    %edx,%eax
8010844e:	83 ec 04             	sub    $0x4,%esp
80108451:	ff 75 f0             	pushl  -0x10(%ebp)
80108454:	ff 75 f4             	pushl  -0xc(%ebp)
80108457:	50                   	push   %eax
80108458:	e8 39 ce ff ff       	call   80105296 <memmove>
8010845d:	83 c4 10             	add    $0x10,%esp
    len -= n;
80108460:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108463:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108466:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108469:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
8010846c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010846f:	05 00 10 00 00       	add    $0x1000,%eax
80108474:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108477:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010847b:	0f 85 77 ff ff ff    	jne    801083f8 <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80108481:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108486:	c9                   	leave  
80108487:	c3                   	ret    
