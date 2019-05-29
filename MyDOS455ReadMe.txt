123456789_123456789_123456789_12345678

MyDOS 4.55beta4 TC
  MyDOS for The!Cart

IMPORTANT:
This MyDOS version has been modified
for using the RAM of The!Cart for
a ramdisk. DOS.SYS and DUP.SYS have
been modified. This version cannot
be used for other kinds of ramdisk,
e.g. XE, AXLON etc. Furthermore also
other ramdisk program like
RAMBOOT.COM, MYRD.COM, MYRD2.COM
cannot and must not be used with this
version of MyDOS because the RAM I/O
routines have heavily been modified.
Any use of other configuration
programs would destroy these routines
and crash the system.

HOW TO USE A RAMDISK WITH THE!CART

1. Create
Be sure The!Cart is connected and
started without configuration lock
(use always <shift>). After booting
MyDOS use the command O Change
Config:
  Drive number or RETURN: <return>
  Number of File Buffers? <return>
  Number of File Buffers? <return>
  RAM disk present? <Y>
  Use default config for 512K? <Y,N>
  Size(48-511K)? <number e.g. 128>
  RAM disk drive no? <number 1-8>
Now in the upper status line the
symbol 8R should appear depending
what drive number you have entered.

2. Initialize
To use the ramdisk it must be
formatted like any other disk. Use
the command I Initialize Disk:
  Disk to FORMAT: <number of ramdisk>
  (Press [A] for Enhanced Dns)
    Type [Y] to Format Drive x:<Y>
Now the ramdisk is ready to use.

3. Using DUP and MEM.SAV
Use command S Set RAMdisk # and set
the ramdisk to number 1. Copy DOS
and DUP using command H Write DOS
Files. If you want to enable MEM.SAV
use the command N Load MEM.SAV and
just press <return>. Now you can
use command S Set RAMdisk # and
the number 1 to make the ramdisk
the boot drive.

4. Disable Ramdisk
Use the command S Set RAMdisk # and
the number 0 to disable the ramdisk.
You can reenable it just using the
same command with a number other
than 0.

