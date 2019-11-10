; Ramdisk for The!Cart and SparatDOS X
; compile with MADS
; written by Eric Bacher and Holger Janz
; based on a ramdisk skeleton provided by Trub
;

; OS equ


TRAMSZ   EQU $06
WARMST   EQU $08
BOOT_    EQU $09
DOSINI   EQU $0C
APPMHI   EQU $0E
IRQENS   EQU $10
IRQSTAT  EQU $11
RTCLOK   EQU $12

ichidz   EQU $20
ICDNOZ   EQU $21
ICCOMZ   EQU $22
ICSTZ    EQU $23
ICBAZ    EQU $24
ICPTZ    EQU $26
ICBLZ    EQU $28
ICAX1Z   EQU $2A
ICAX2Z   EQU $2B
ICAX3Z   EQU $2C
ICAX5Z   EQU $2E
ICAX6Z   EQU $2F
SIOSTAT  EQU $30
CHKSUM   EQU $31
BUFR     EQU $32
BUFEN    EQU $34
IOSNDEN  EQU $41
CRITIC   EQU $42
ZBUFA    EQU $43
ZDRVA    EQU $45
INIFLG   EQU $47
ATRACT   EQU $4D
LMARGN   EQU $52
RMARGN   EQU $53
VCP      EQU $54
HCP      EQU $55
SAVMSC   EQU $58

LOGCOL   EQU $63
RAMTOP   EQU $6A

TIMCNT1  equ $218
VVBLKI   EQU $222
TIMVEC1  EQU $226
DMACTLS  EQU $22F
DLPTRS   EQU $230
CDEVIC   EQU $23A
CCMND    EQU $23B
CAUX1    EQU $23C
CAUX2    EQU $23D
COLDST   EQU $244
PDVMSK   EQU $247
PDVRS    EQU $248
CRETRY   EQU $29C
INVFLG   EQU $2B6
DRETRY   EQU $2BD
SHFLOK   EQU $2BE
COLPF1S  EQU $2C5
COLPF2S  EQU $2C6
COLPF3S  EQU $2C7
COLBAKS  EQU $2C8
KRPDEL   EQU $2D9
KEYREP   EQU $2DA
NOCLIK   EQU $2DB
hlpflg   equ $02dc
RUNAD    EQU $2E0
INITAD   EQU $2E2
MEMTOP   EQU $2E5
MEMLO    EQU $2E7
dvstat   EQU $2ea
CRSINH   EQU $2F0
oldkbc   equ $02f2
CHBAS    EQU $2F4
ATACHR   EQU $2FB
KBCODES  EQU $2FC
DSPFLG   EQU $2FE
SSFLAG   EQU $2FF

DCB      EQU $300
DDEVIC   EQU $300
DUNIT    EQU $301
DCMND    EQU $302
DSTATS   EQU $303
DBUFA    EQU $304
DBUFAL   EQU $304
DBUFAH   EQU $305
DTIMLO   EQU $306
DBYT     EQU $308
DBYTL    EQU $308
DBYTH    EQU $309
DAUX     EQU $30A
DAUX1    EQU $30A
DAUX2    EQU $30B
CASFLG   EQU $30F
STACKP   EQU $318
TSTAT    EQU $319
HATABS   EQU $31A
ICDNO    EQU $341
ICCMD    EQU $342
ICBUFA   EQU $344
ICPUTB   EQU $346
ICBUFL   EQU $348
ICAX1    EQU $34A
ICAX2    EQU $34B
ICAX3    EQU $34C
ICAX4    EQU $34D
ICAX5    EQU $34E
ICAX6    EQU $34F
CARTCK   EQU $3EB
BASICF   EQU $3F8
GINTLK   EQU $3FA

BUF580   EQU $580


CART     EQU $BFF0
CARTRUN  EQU $BFFA

ABANK    EQU $CFFF

TRIG3    EQU $D013
PAL      EQU $D014
CONSOL   EQU $D01F
GTIA     EQU $D000
PDVREG   EQU $D1FF
AUDC1    EQU $D201
AUDC2    EQU $D203
AUDF3    EQU $D204
AUDC3    EQU $D205
AUDF4    EQU $D206
AUDC4    EQU $D207
AUDCTL   EQU $D208
KBCODE   EQU $D209
RANDOM   EQU $D20A
SKSTRES  EQU $D20A
SEROUT   EQU $D20D
SERIN    EQU $D20D
IRQST    EQU $D20E
IRQEN    EQU $D20E
SKCTL    EQU $D20F
SKSTAT   EQU $D20F
PORTA    EQU $D300
PORTB    EQU $D301
PACTL    EQU $D302
PBCTL    EQU $D303
DMACTL   EQU $D400
DLPTR    EQU $D402
WSYNC    EQU $D40A
VCOUNT   EQU $D40B
NMIEN    EQU $D40E
NMIST    EQU $D40F

CART_ON  EQU $D500
CART_OF  EQU $D508

PDIOR    EQU $D805

CHARSET1 EQU $E000
DEVHAT   EQU $E400
KBDVEC   EQU $E420
VKBGBYT  EQU $E424
JCIOMAIN EQU $E456
JSIOINT  EQU $E459
SETVBLV  EQU $E45C
JRESETCD EQU $E477
JNMIENBL EQU $E46B

SIOV     EQU $E459
JSYSVBL  EQU $E45F
JEXITVBL EQU $E462
JNEWDEVC EQU $E486

NMIVEC   EQU $FFFA
RESETVEC EQU $FFFC
IRQVEC   EQU $FFFE

; SDX equ

bufadr   equ $15
dskfms   equ $18
dskutl   equ $1A

S_FLAG   EQU $700
SDXVER   EQU $701
SDXREV   EQU $702
JKERNEL  EQU $703
BLOCK_IO EQU $706
JMISC    EQU $709
JLSIO    EQU $70C
;SIOIDX   EQU $70F  ;Sector IO InDeX.
JHWCTRL  EQU $715
SIOHAND  EQU $718
SLVTAB   EQU $720
LDFTAB   EQU $730
DEVTAB   EQU $740
HANDTAB  EQU $750
fhandle equ $0760
SIOCBIDX EQU $760
DEVICE   EQU $761
NAME     EQU $762
NAMES    EQU $76D
fmode   equ $778
OPMODE   EQU $778
FATR1    EQU $779
FATR2    EQU $77A
DATE     EQU $77B
TIME     EQU $77E
DATESET  EQU $781
FAUX1    EQU $782
FAUX2    EQU $783
FAUX3    EQU $784
FAUX4    EQU $785
FAUX5    EQU $786
SYSCALL  EQU $787
DIRBUF   EQU $789
DIRFATR  EQU $789
DIRF1SEC EQU $78A
DIRFLEN  EQU $78C
DIRFNAME EQU $78F
DIRFDATE EQU $79A
DIRFTIME EQU $79D
PATH     EQU $7A0
DOSVECT  EQU $7E0
JHDOSINI EQU $7E0
VDOS     EQU $7E3
VCIO     EQU $7E5
VEDIT    EQU $7E7
VCRUNCH  EQU $7E9   
;JTEMP    EQU $7EB
JFSYMBOL EQU $7EB
JMDVECT  EQU $7EE
JEXT_ON  EQU $7F1
JEXT_OFF EQU $7F4
JEXT_SW  EQU $7F7
JCAR_SW  EQU $7FA
JCAR_OLD EQU $7FD

;******************
BANKSIZE EQU 8192

        
;******************
;* Vectors under ROM

highvect equ $FFC0
jgettd   equ $ffc0
jsettd   equ $ffc3
jtdon    equ $ffc6
jfmttd   equ $ffc9
jxcomli  equ $ffd2
jkeyon   equ $ffd5

;******************
_err_memory_conflict    equ $b3
_err_disk_corrupt       equ $b5


; SDX Symbols

_CIO     SMB '_CIO'
_CRUNCH  SMB '_CRUNCH'
_DOS     SMB '_DOS'
_EDIT    SMB '_EDIT'
_INITZ   SMB '_INITZ'
__MISC   smb '__MISC'
BUILDDIR SMB 'BUILDDIR'
CARVARS  SMB 'CARVARS'  ;as of SDX 4.30
CHDIR    SMB 'CHDIR'
CHMOD    SMB 'CHMOD'
CKSPEC   SMB 'CKSPEC'
COMTAB   SMB 'COMTAB'
COMTAB2  SMB 'COMTAB2'  ;as of SDX 4.30
CURDEV   SMB 'CURDEV'
DEVSPEC  SMB 'DEVSPEC'  ;as of SDX 4.30
DEVNAME  SMB 'DEVNAME'  ;as of SDX 4.30
DIV_32   SMB 'DIV_32'
DIVIO    SMB 'DIVIO'
ENV_P    SMB 'ENV_P'
ERRNO    smb 'ERRNO'
EXTENDED SMB 'EXTENDED'
FCLEVEL  SMB 'FCLEVEL'
FCLOSE   SMB 'FCLOSE'
FCLOSEAL SMB 'FCLOSEAL'
FDCLOSE  SMB 'FDCLOSE'
FDGETC   SMB 'FDGETC'
FDOPEN   SMB 'FDOPEN'
FFIRST   SMB 'FFIRST'
FGETC    SMB 'FGETC'
FGETS    SMB 'FGETS'
FILE_P   SMB 'FILE_P'
FILELENG SMB 'FILELENG'
FLAG     SMB 'FLAG'
FNEXT    SMB 'FNEXT'
FOPEN    SMB 'FOPEN'
FORMAT   SMB 'FORMAT'
FPRINTF  SMB 'FPRINTF'
FPUTC    SMB 'FPUTC'
FPUTS    SMB 'FPUTS'
FREAD    SMB 'FREAD'
FSEEK    SMB 'FSEEK'
FTELL    SMB 'FTELL'
FWRITE   SMB 'FWRITE'
GETC     SMB 'GETC'
GETCWD   SMB 'GETCWD'
GETDFREE SMB 'GETDFREE'
GETENV   SMB 'GETENV'
GETS     SMB 'GETS'
H_FENCE  SMB 'H_FENCE'
I_GETTD  SMB 'I_GETTD'
I_SETTD  SMB 'I_SETTD'
INSTALL  SMB 'INSTALL'
MALLOC   SMB 'MALLOC'
MKDIR    SMB 'MKDIR'
MUL_32   SMB 'MUL_32'
NUMENV   SMB 'NUMENV'
PRINTF   SMB 'PRINTF'
PRO_NAME SMB 'PRO_NAME'
PUT_V    SMB 'PUT_V'
PUTC     SMB 'PUTC'
PUTENV   SMB 'PUTENV'
PUTS     SMB 'PUTS'
REMOVE   SMB 'REMOVE'
RENAME   SMB 'RENAME'
RENDIR   smb 'RENDIR'
RMDIR    SMB 'RMDIR'
S_ADD    SMB 'S_ADD'
S_ADDIZ  SMB 'S_ADDIZ'
S_CLEAR  SMB 'S_CLEAR'
S_LOOKUP SMB 'S_LOOKUP'
S_NEXT   SMB 'S_NEXT'
SETBOOT  SMB 'SETBOOT'
STATUS   SMB 'STATUS'
SYMBOL   SMB 'SYMBOL'
SYSLEVEL SMB 'SYSLEVEL'
T_       SMB 'T_'
TOUPPER  SMB 'TOUPPER'
U_ERROR  SMB 'U_ERROR'
U_EXPAND SMB 'U_EXPAND'
U_FAIL   SMB 'U_FAIL'
U_FSPEC  SMB 'U_FSPEC'
U_GEFINA SMB 'U_GEFINA'
U_GEPATH SMB 'U_GEPATH'
U_GETATR SMB 'U_GETATR'
U_GETFLG SMB 'U_GETFLG'
U_GETKEY SMB 'U_GETKEY' ;as of SDX 4.30
U_GETNUM SMB 'U_GETNUM'
U_GETPAR SMB 'U_GETPAR'
U_GONOFF SMB 'U_GONOFF'
U_LOAD   SMB 'U_LOAD'
U_PARAM  SMB 'U_PARAM'
U_SFAIL  SMB 'U_SFAIL'
U_SLASH  SMB 'U_SLASH'
U_TOKEN  SMB 'U_TOKEN'
U_UNLOAD SMB 'U_UNLOAD'
U_XFAIL  SMB 'U_XFAIL'
VALIDATE SMB 'VALIDATE'
VPRINTF  SMB 'VPRINTF'
XDIVIO   SMB 'XDIVIO'
_XHDIR   SMB '_XHDIR'
_XPROC   SMB '_XPROC'


; 
; The!Cart Register (from-to,default)
;

; Mode Select
TCMOSL = $d5a6    ; mode ($00-$3d,$01)
; Cartridge mode is selected with bits 0-5 of $D5A6, values
; other than the ones listed here are reserved (and result
; in "cartridge off"):
; $00: off, cartridge disabled
; $01: 8k banks at $A000
; $02: AtariMax 1MBit / 128k
; $03: Atarimax 8MBit / 1MB
; $04: OSS M091
; $08: SDX 64k cart, $D5Ex banking
; $09: Diamond GOS 64k cart, $D5Dx banking
; $0A: Express 64k cart, $D57x banking
; $0C: Atrax 128k cart
; $0D: Williams 64k cart
; $20: flexi mode (separate 8k banks at $A000 and $8000)
; $21: standard 16k cart at $8000-$BFFF
; $22: MegaMax 16k mode (up to 2MB), AtariMax 8Mbit banking
; $23: Blizzard 16k
; $24: Sic!Cart 512k
; $28: 16k Mega cart
; $29: 32k Mega cart
; $2A: 64k Mega cart
; $2B: 128k Mega cart
; $2C: 256k Mega cart
; $2D: 512k Mega cart
; $2E: 1024k Mega cart
; $2F: 2048k Mega cart
; $30: 32k XEGS cart
; $31: 64k XEGS cart
; $32: 128k XEGS cart
; $33: 256k XEGS cart
; $34: 512k XEGS cart
; $35: 1024k XEGS cart
; $38: 32k SWXEGS cart
; $39: 64k SWXEGS cart
; $3A: 128k SWXEGS cart
; $3B: 256k SWXEGS cart
; $3C: 512k SWXEGS cart
; $3D: 1024k SWXEGS cart
TCMOSL.OFF   = $00    ; off, cartridge disabled
TCMOSL.8K    = $01    ; 8k banks at $A000
TCMOSL.AM1MB = $03
TCMOSL.FLEXI = $20    ; flexi mode, separate 8k banks at $A000 and $8000
TCMOSL.16K   = $21    ; standard 16k cart at $8000-$BFFF

; how to figure out that The!Cart is not active?
; If the address is not used then the XL returns $ff but
; the XE (and old 800) return $d5 (high byte of address,
; the value of the last bus cycle)
TCMOSL.XLLOCK  = $ff    ; config lock or not present
TCMOSL.XELOCK  = $d5    ; config lock or not present

; Mode Flash/RAM Select
TCMOFR = $d5a7    ;flash/RAM mode (0-15,0)
; bit 0: primary bank write enable (0=readOnly, 1=write)
; bit 1: primary bank source (0=flash, 1=RAM)
; bit 2: secondary bank write enable (0=readOnly, 1=write)
; bit 3: secondary bank source (0=flash, 1=RAM)
TCMOFR.PBRAM = $03    ; primary bank RAM
TCMOFR.SBRAM = $0C    ; secondary bank RAM

; Primary Bank
TCPBRL = $d5a0    ; register low byte (0-255,0)
TCPBRH = $d5a1    ; register high byte (0-63,0)
TCPBEN = $d5a2    ; enable (0=dis-1=en,1)

; Secondary Bank 
TCSBRL = $d5a3    ; register low byte (0-255,0)
TCSBRH = $d5a4  ; register high byte (0-63,0)
TCSBEN = $d5a5    ; enable (0=dis-1=en,0)

; SPI interface to EEPROM
TCINEP = $d5a8
; bit 0: SPI CLK
; bit 1: SPI CS
; bit 7: SPI data in (on reads), SPI data out (on writes)

; configuration lock
TCCOLO = $d5af
; Writing to this register disables "The!Cart" registers
; at $d5aX.


;
; Offset from COMTAB
;
TRAILS   = $1A
CONFNAM  = $21
;
; Ramdisk size in KB if not specified on command line
;
RAMDISK_SIZE = 512
;
; ******************************************************************************
;
;    
     blk sparta $3000
;
; check if we are running on THE!CART hardware
;
     lda TCMOSL
     cmp #TCMOSL.XLLOCK
     beq ?skipped
     cmp #TCMOSL.XELOCK
     bne ?thecart_hardware
?skipped
     jmp nocartram
;
; find the maximum drive number and store it in ramdisk_drive
;
?thecart_hardware
     lda DEVSPEC-2
     sta ramdisk_drive
     lda #<maxvar
     ldx #>maxvar
     jsr GETENV
     bmi ?nomxd
     lda BUF580
     sec
     sbc #$40
     bmi ?nomxd
     cmp ramdisk_drive
     bcs ?nomxd
     sta ramdisk_drive
?nomxd
;
; check if a drive number has been provided in the command
;
     jsr U_GETPAR
     beq ?no_parameters
     ldx #$00
?ppar1
     lda COMTAB+CONFNAM,x
     cmp #'0'
     bcc ?epar1
     cmp #'9'+1
     bcs ?epar1
     pha
     lda newdrvn
     asl
     sta multmp
     asl
     asl
     clc
     adc multmp
     sta newdrvn
     pla
     and #$0F
     adc newdrvn
     sta newdrvn
     inx
     cpx COMTAB+TRAILS
     bcc ?ppar1
?epar1
     lda newdrvn
     bne ?num
     lda COMTAB+CONFNAM
     and #$1f
?num
     cmp #16
     bcs ?no_parameters
     cmp ramdisk_drive
     bcs ?no_parameters
     sta ramdisk_drive
;
; use max size 
;
?no_parameters
     lda #<RAMDISK_SIZE
     sta ramdisk_sectors
     ldx #>RAMDISK_SIZE
     stx ramdisk_sectors+1
;
; convert ramdisk size (in Kb) into number of sectors (sector len = 128 bytes)
;
     lda ramdisk_sectors
     asl
     rol ramdisk_sectors+1
     asl
     rol ramdisk_sectors+1
     asl
     rol ramdisk_sectors+1
     sta ramdisk_sectors
;
; find a free entry in the SIO table
;
     ldx #$06
?next_sio_entry
     lda SIOHAND+1,x
     beq ?free_sio_entry
     dex
     dex
     bpl ?next_sio_entry
     jmp sio_full
;
; save SIO handler
;
?free_sio_entry
     lda prdsio
     sta SIOHAND,x
     lda prdsio+1
     sta SIOHAND+1,x
;
; set ramdisk name
;
     lda ramdisk_drive
     ora #$30
     sta rddrvch
     sta report_drive
     sta preserved_drive
;
; set max sector number
;
     lda ramdisk_sectors+1
     sta spt_hi
     lda ramdisk_sectors
     sta spt_lo
;
; check if there is a ramdisk content to preserve
; by looking at the magic bytes at the start of RAM
; Disable interrupts before switching to RAM because of
; cartridge lock and preserve THE!CART registers
;

     lda TCPBEN         ; save register
     pha
     lda TCMOFR
     pha
     lda TCPBRL
     pha
     lda TCPBRH
     pha
     lda TCMOSL
     pha

     lda #$FF           ; start critical
     sta CRITIC 
     lda RTCLOK+2
_wait1
     cmp RTCLOK+2
     beq _wait1

     sei                ; disable all interrupts
     lda #$00
     sta NMIEN

     lda #TCMOSL.16K    ; set 16k mode at $8000-$BFFF
     sta TCMOSL
     lda #TCMOFR.PBRAM  ; set to RAM
     sta TCMOFR
     lda #$00
     sta TCPBRL         ; get bank number from X
     sta TCPBRH         ; set high to $00
     lda #$01
     sta TCPBEN         ; enable

     lda #0
     sta no_magic       ; used to store if magic is found (0=yes)

     ldx #7
next_magic
     lda magic,x
     cmp $8000,x
     beq good_magic
     sta $8000,x
     dec no_magic
good_magic
     dex
     bpl next_magic

     pla                ; restore register
     sta TCMOSL
     pla
     sta TCPBRH
     pla
     sta TCPBRL
     pla
     sta TCMOFR
     pla
     sta TCPBEN

     lda #$E0           ; enable interrupts
     sta NMIEN
     cli

     lda #$00           ; reset crirical
     sta CRITIC 
;
; check if ramdisk is already initialized
;
     lda no_magic
     bmi ?erase_content
;
; ramdisk has a previous content
;
     jsr PRINTF
     .byte 'Ramcart ver47 preserved drive D'
preserved_drive
     .byte '?:',$9B,0
     jmp ?end
;
; ramdisk must be initialised because no previous content has been found
; Build SpartaDos disk structure
;
?erase_content
     lda #$31
     sta DDEVIC
     lda ramdisk_drive
     sta DUNIT
     lda #<rdname
     ldx #>rdname
     jsr BUILDDIR
;
; ramdisk is initialized
;
     jsr PRINTF
     .byte 'Ramcart ver47 init drive D'
report_drive
     .byte '?:',$9B,0
;
; mark the device as being installed
;
?end
     dec INSTALL
     rts
;
; Strings and variables
;
multmp
     .byte 0
prdsio
     .word rdsio
magic
     .byte "TCRAMHJX"
no_magic
     .byte 0
newdrvn
     .byte 0
rdname
     .byte 'RAMCART'
rddrvch
     .byte '1',$9B
maxvar
     .byte 'MAXDRV',$9B
;
; Display an error when SIO table is full
;
sio_full
     jsr PRINTF
     .byte 'Ramcart ver47 not installed:',$9b
     .byte '  SIO table full',$9B,0
     rts
;
; Cartridge ram not found
;
nocartram:
     jsr PRINTF
     .byte 'Ramcart ver47 The!Cart is locked:',$9B
     .byte '   Use SHIFT-RETURN or SHIFT-Fire in',$9B
     .byte '   The!Cart main menu to unlock RAM.',$9B,0
     rts

;
; ******************************************************************************
;
     blk reloc main  
;
; An I/O is requested
;
rdsio
     php
     jsr sio_handler
     tya
     plp
     cmp #$FF
     beq set_carry
     clc
     rts
set_carry
     sec
     rts
;
; Ramdisk SIO handler
;
sio_handler
     lda DDEVIC
     and #$f0
     cmp #$30
     bne ?nordsio
     lda DUNIT
     cmp #$10
     bcs ?isrddrv
;
; get drive number from new swap table
;
     tax
     lda COMTAB2+2-1,x
?isrddrv
     cmp ramdisk_drive
     bne ?nordsio
     ldx #$01
?sbb
     lda DBUFAL,x
     sta BUFEN,x
     sta _rtofast+1,x
     sta _wfromfast+1,x
     dex
     bpl ?sbb
     lda DCMND
     ldx #$04
?nextcmd
     cmp sio_cmds,x
     beq ?callcmd
     dex
     bpl ?nextcmd
?rwerr
     ldy #139 ;NAK
     rts
?nordsio
     ldy #$FF
     rts

;
; other commands (status, percom)
;
?jother
     cpx #$04
     beq ?go_percom
     jmp READSTATUS
?go_percom
     jmp READPERCOM

;
; check for read sector or write sector
;
?callcmd
     cpx #$03
     bcs ?jother
;
; we know that we have a read or write
;
     lda spt_lo
     cmp DAUX1
     lda spt_hi
     sbc DAUX2
     bcc ?rwerr
;
; compute buffer address in cartridge RAM
;
     lda DAUX1               ; get low byte of sector
     sec                     ; set Bit7
     ror                     ; save Bit0 in carry
     and #$bf                ; clear Bit6
     sta _wtofast+2
     sta _rfromfast+2
     lda #$00
     ror                     ; make carry Bit7
     sta _wtofast+1
     sta _rfromfast+1
;
; compute bank number in RAM.
; we have 128 sectors in a 16KB bank so we need
; to shift right DAUX1/2 by 6 (or left by 2)
;
     lda DAUX1               ; get low byte of sector
     asl                     ; save Bit8 in carry 
     lda DAUX2               ; get high byte of sector
     rol                     ; get Bit8 of low byte 
     asl                     ; get bank number with LSB 0
     tay
;
; save THE!CART registers and disable interrupts
;
     jsr save_cart_regs
     jsr set_cart_regs
;
; call read or write routine
;
     ldx #0
     bit DSTATS
     bpl ?jread

     jsr WRITESECTOR
     rts
     
?jread
     jsr READSECTOR
     rts
;
; save THE!CART registers into hide_cart_ram code
;
save_cart_regs

     lda TCMOSL
     sta _hpatchTCMOSL+1
     lda TCMOFR
     sta _hpatchTCMOFR+1
     lda TCPBRL
     sta _hpatchTCPBRL+1
     lda TCPBRH
     sta _hpatchTCPBRH+1
     lda TCPBEN
     sta _hpatchTCPBEN+1

     rts
;
; save THE!CART registers into show_cart_ram code
;
set_cart_regs

     lda #TCMOSL.16K
     sta _spatchTCMOSL+1
     lda #TCMOFR.PBRAM
     sta _spatchTCMOFR+1
     sty _spatchTCPBRL+1
     lda #$00
     sta _spatchTCPBRH+1
     lda #$01
     sta _spatchTCPBEN+1

     rts
;
; enable THE!CART ram
;
show_cart_ram
     
     lda #$FF
     sta CRITIC 
     lda RTCLOK+2
_wait2
     cmp RTCLOK+2
     beq _wait2

     sei
     lda #0
     sta NMIEN

_spatchTCMOSL
     ldy #0
     sty TCMOSL
_spatchTCMOFR
     ldy #0
     sty TCMOFR
_spatchTCPBRL
     ldy #0
     sty TCPBRL
_spatchTCPBRH
     ldy #0
     sty TCPBRH
_spatchTCPBEN
     ldy #0
     sty TCPBEN

     rts
;
; remove THE!CART ram
;
hide_cart_ram

_hpatchTCMOSL
     ldy #0
     sty TCMOSL
_hpatchTCPBRH
     ldy #0
     sty TCPBRH
_hpatchTCPBRL
     ldy #0
     sty TCPBRL
_hpatchTCMOFR
     ldy #0
     sty TCMOFR
_hpatchTCPBEN
     ldy #0
     sty TCPBEN

     lda #$E0
     sta NMIEN
     cli

     lda #$00
     sta CRITIC 

     rts
;
; Write sector command
;
WRITESECTOR

     lda SYSCALL
     jsr jext_on
     ldx #$7f
_wfromfast
     lda $FFFF,x
     sta ramdisk_buffer,x
     dex
;     cpx DBYT
     bpl _wfromfast
     jsr jext_off

     jsr show_cart_ram
     ldx #$7f
_wfromfast_buf
     lda ramdisk_buffer,x
_wtofast
     sta $FFFF,x
     dex
;     cpx DBYT
     bpl _wfromfast_buf
     jsr hide_cart_ram
     
     jmp ?operation_ok
     
;
; Read sector command
;
READSECTOR
     
     jsr show_cart_ram
     ldx #$7f
_rfromfast
     lda $FFFF,x
     sta ramdisk_buffer,x
     dex
;     cpx DBYT
     bpl _rfromfast     
     jsr hide_cart_ram

     lda SYSCALL
     jsr jext_on
     ldx #$7f
_rfromfast_buf
     lda ramdisk_buffer,x
_rtofast
     sta $FFFF,x
     dex
;     cpx DBYT
     bpl _rfromfast_buf
     jsr jext_off

?operation_ok
     lda #$01
     tay
     clc
     rts
;
; Read Status and Read Percom commands
;
READSTATUS
     ldx #$0f
     ldy #$03
     bne ?rdperc
READPERCOM
     ldx #$0b
     ldy #$0b
?rdperc
     lda SYSCALL
     jsr jext_on
?nxtpb
     lda tpercom,x
     sta (BUFEN),y
     dex
     dey
     bpl ?nxtpb
     jsr jext_off
     jmp ?operation_ok
;
; ramdisk drive number
;
ramdisk_drive
     .byte 15
;
; Read percom answer
;
tpercom
     .byte 1    ;no of tracks
     .byte 1    ;step rate
spt_hi
     .byte 0    ;sector per track hi - $0E for 470KB
spt_lo
     .byte 0    ;sector per track lo - $B0 for 470KB
     .byte 0    ;no of sides - 1
     .byte 4    ;record method (4=MFM)
     .byte 0    ;bytes per sector hi
     .byte $80  ;bytes per sector lo (128 bytes)
     .byte $FF  ;drive online
     .byte 0    ;unused
     .byte 0    ;unused
     .byte 0    ;unused
;
; Read status answer
;
tstatus
     .byte $10
     .byte $FF
     .byte $E0
;
; Number of sectors of this ramdisk (128 bytes)
;
ramdisk_sectors
     .word 0
sio_cmds
     .byte 'RWPSN'
ramdisk_buffer
:128 .byte 0

     end
     