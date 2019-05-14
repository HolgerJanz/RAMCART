;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 
; The!Ramdisk - Ramdisk for The!Cart

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Assembler Switches

; patchDOS:
;   assemble with (1) our without (0) DOS 2.5 patches 
; initRAMDISK
;   init RAMDISK (1), our without (0) 

; RAMCART.COM
patchDOS = 1
initRAMDISK = 1

; RAMDISK.COM
; patchDOS = 0
; initRAMDISK = 1

; PATCH.COM
; patchDOS = 1
; initRAMDISK = 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 
; The!Cart programming information
; (c) 2013 Matthias Reichl
;
; The!Cart is equipped with 128MB flash (Spansion S29GL01
; chip), 512k RAM and a 256-byte SPI EEPROM (Microchip
; 25AA020A). The memory is addressed using 16384 8k banks
; (64 8k banks when using RAM instead of flash).
; 
; The cartridge configuration registers are located at
; $D5A0-$D5A8. All registers are read/write unless noted
; otherwise. Unused bits shall be written as '0' and
; always read back as '0'.
; 
; Powerup configuration is 8k mode ($A000-$BFFF) using
; flash bank 0, writes to flash are disabled.
; 
; Depending on the selected cartridge mode additional
; registers are enabled at $D5xx.
; 
; The primary bank register also serves as a base bank
; register for the various sub-modes.
; 
; The secondary bank register is only used in "flexi mode".
;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
TCMOSL.FLEXI = $21    ; flexi mode,
                         ; separate 8k banks at $A000 and $8000
TCMOSL.16K   = $21    ; standard 16k cart at $8000-$BFFF
TCMOSL.LOCK  = $ff    ; config lock or not present

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Equates used to call CIO
;

XIO.FMTDD = 254 ; Format command
XIO.PRINT = 9   ; Print line
XIO.OPEN  = 3   ; Open
XIO.CLOSE = 12  ; Close
XIO.READ  = 4   ; Read
XIO.WRITE = 8   ; Write
XIO.GET   = 7   ; Get
XIO.PUT   = 11  ; Put

IOCB        =  $0340    ; address of first IOCB
IOCB.CMD    = IOCB+2    ; where command goes in IOCB
IOCB.BUF    = IOCB+4    ; buffer (or name) address
IOCB.BUFLEN = IOCB+8    ; max buffer length address
IOCB.AUX1   = IOCB+10   ; Auxilliary byte 1
IOCB.AUX2   = IOCB+11   ; Auxilliary byte 2

CIOV = $E456            ; the classic location

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; OS Equates
;

RTCLOKH = $12
RTCLOKM = $13
RTCLOKL = $14
CRITIC  = $42
NMIEN   = $d40e

DRVBYT  = $070a ; the infamous "1802" location
INITDOS = $07e0 ; same as DOS 2.0 and others

; DOS and DUP end pointer
NDOS    = $1D7C ; end of the system buffers and minidup
NDUP    = $3306 ; end of dup

FIXMDUP = $153f ; just before Mini-DUP
; Location that says which drive MEM.SAV and DUP.SYS
; are located on (contains ATASCII character--
; not just a byte value)

FIXXFMT = $105d ; Patch XFORMAT in FMS
; Max length of VTOC
;   $8a = dual density 10+(1024/8)
;   $64 = single density 10+(720/8)
;   $4a = ram disk 130XE 10+(512/8) (original)

FIXVTOC = $0b87 ; Patch RDVTOC in FMS
; Offset in VTOC header table
;   $00 = TYPE810 720 sectors
;   $06 = TYPE1050 1024 sectors
;   $0C = TYPERAM 512 sectores (originial)

DISKBUF = $0304 ; buffer address for read/write
DCBSEC  = $030a    ; DAUX1,DAUX2 contains sector number

RAMIO   = $1481 ; start of RAMIO of DOS 2.5, end $14e7 = $66
SETBANK = $12cb ; start of SETBANK of DOS 2.5, end $12ec = $21

VTOCSEC = $168           ; sector number of VTOC

DVDOTYP = 2              ; type in VTOC for DOS 2.5
DVMAXSC = 1024-14        ; max sector count Enhanced Density

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 
; Start
;

        org $4000 
start                   ; Start of code

.if patchDOS & initRAMDISK
; start message
        ldx #<msg.start
        ldy #>msg.start
        lda #msg.start.end-msg.start
        jsr print
.endif

.if initRAMDISK
; check for The!Cart
        lda TCMOSL
        cmp #TCMOSL.LOCK
        bne setup.ok
; not found message        
        ldx #<msg.notfound
        ldy #>msg.notfound
        lda #msg.notfound.end-msg.notfound
        jsr print
; finish
        rts             ; OK and we are done!
        
setup.ok
; found The!Cart, start setup
        ldx #<msg.setup
        ldy #>msg.setup
        lda #msg.setup.end-msg.setup
        jsr print        
.endif

.if patchDOS
; Patch FMS to use 1050 VTOC instead of 130XE VTOC
; and switch to D8: for MEM.SAV and DUP.SYS 
        lda #$06        ; offset 6 -> 1050
        sta FIXVTOC     ; set max VTOC length
        lda #$8a      
        sta FIXXFMT     ; set VTOC head
.endif

.if patchDOS & !initRAMDISK
; Patch DUP set 2.5TC invers
; do not patch for RAMDISK because DUP is loaded later
        lda #$b2
        sta $1f31
        lda #$ae
        sta $1f32
        lda #$b5
        sta $1f33
        lda #$d4
        sta $1f34
        lda #$c3
        sta $1f35
.endif

.if initRAMDISK
; activate RAMDISK at D8:
        lda DRVBYT      ; to active drives...
        ora #$80        ; ...include this drive
        sta DRVBYT      ; and update the mask
        jsr INITDOS     ; including the drive table,
                        ; alloc buffer, etc.
; check for preformat (maybe there is already a ram disk)
        jsr check.vtoc
        tya
        bne prepare.ramdisk ; no ram disk
; there seems to be already a ramdisk
; check file name DUP.SYS set to D8:
        lda #'8'
        sta file.dup.NAME+1
; check for DUP.SYS on D8:
        ldx #$70
        lda #XIO.OPEN   
        sta IOCB.CMD,X
        lda #XIO.READ
        sta IOCB.AUX1,X
        lda #<file.dup.name
        sta IOCB.BUF,X
        lda #>file.dup.name
        sta IOCB.BUF+1,X
        jsr CIOV
        bmi dup.notfound
        jsr close
        bmi dup.notfound
; switch to D8: for MEM.SAV and DUP.SYS
        lda #'8'
        sta FIXMDUP     ; set MEM.SAV and DUP.SYS drive
; finish 
dup.notfound
        rts             ; OK and we are done!

prepare.ramdisk
; *** (1) FORMAT
        ldx #<msg.format
        ldy #>msg.format
        lda #msg.format.end-msg.format
        jsr print
; format
        ldx #$70        ; we will use channel 7 for this
        lda #XIO.FMTDD  ; the format command
        sta IOCB.CMD,X  ; is first item on agenda!
        lda #<drv.name  ; LSB of address of drive name
        sta IOCB.BUF,X  ; to IOCB
        lda #>drv.name  ; then MSB
        sta IOCB.BUF+1,X ; also to IOCB
        jsr CIOV        ; call CIO to FORMAT the disk
        BMI oops1       ; but we can't handle an error! (do nothing)

;*** (2) COPY DUP.SYS TO D8:
        ldx #<msg.copy
        ldy #>msg.copy
        lda #msg.copy.end-msg.copy
        jsr print
; start copy of DUP.SYS
        ldx #$70
        lda #XIO.OPEN
        sta IOCB.CMD,X
        lda #XIO.READ
        sta IOCB.AUX1,X
        lda #<file.dup.name
        sta IOCB.BUF,X
        lda #>file.dup.name
        sta IOCB.BUF+1,X
        jsr CIOV
oops1
        bmi oops2           ;NO DUP(?)
; read it into buffer
        ldx #$70
        lda #XIO.GET
        sta IOCB.CMD,X
        lda #<file.dup.size
        sta IOCB.BUFLEN,X
        lda #>file.dup.size
        sta IOCB.BUFLEN+1,X
        lda #<file.dup.buffer
        sta IOCB.BUF,X
        lda #>file.dup.buffer
        sta IOCB.BUF+1,X
        jsr CIOV
oops2
        bmi oops3
        jsr close
        bmi oops3
; file name DUP.SYS set to D8:
        lda #'8' ;
        sta file.dup.NAME+1
; now open for write
        ldx #$70
        lda #XIO.OPEN
        sta IOCB.CMD,X
        lda #XIO.WRITE
        sta IOCB.AUX1,X
        lda #<file.dup.name
        sta IOCB.BUF,X
        lda #>file.dup.name
        sta IOCB.BUF+1,X
        jsr  CIOV
oops3
        bmi  oops4
; write dup.sys to D8:
        ldx #$70
        lda #XIO.PUT
        sta IOCB.CMD,X
        lda #<file.dup.size
        sta IOCB.BUFLEN,X
        lda #>file.dup.size
        sta IOCB.BUFLEN+1,X
        lda #<file.dup.buffer
        sta IOCB.BUF,X
        lda #>file.dup.buffer
        sta IOCB.BUF+1,X
        jsr CIOV
OOPS4
        bmi  OOPS5
; close
        jsr close
        bmi  OOPS5

; only and only if format and copy OK, 
; switch to D8: for MEM.SAV and DUP.SYS
        lda #'8'
        sta FIXMDUP     ; set MEM.SAV and DUP.SYS drive
        
;*** (3) CREATE MEM.SAV FILE
        ldx #<msg.create
        ldy #>msg.create
        lda #msg.create.end-msg.create
        jsr print
; start copy of DUP.SYS
        ldx #$70
        lda #XIO.OPEN
        sta IOCB.CMD,X
        lda #XIO.WRITE
        sta IOCB.AUX1,X
        lda #<file.mem.name
        sta IOCB.BUF,X
        lda #>file.mem.name
        sta IOCB.BUF+1,X
        jsr CIOV
OOPS5
        bmi oops6
; write mem.sav to d8:
        ldx #$70
        lda #XIO.PUT
        sta IOCB.CMD,X
        lda #<file.mem.size
        sta IOCB.BUFLEN,X
        lda #>file.mem.size
        sta IOCB.BUFLEN+1,X
        lda #<file.mem.buffer
        sta IOCB.BUF,X
        lda #>file.mem.buffer
        sta IOCB.BUF+1,X
        jsr CIOV
OOPS6
        bmi  oops7
; close channel
        jsr close
        bmi oops7

        rts         ; OK and we are done!

oops7
; set error code in message
        tya
        sec 
        sbc #100    ; error nums always are 1xx dec
        ldx #'0'-1  ; convert tens
count.tens
        inx 
        sec 
        sbc #10
        bpl count.tens ; the easy (slow) way
        clc
        adc #10+'0'
        stx msg.error.code
        sta msg.error.code+1
; error message
        ldx #<msg.error
        ldy #>msg.error
        lda #msg.error.end-msg.error
        jsr print
; close channel, just in case
        jsr close
.endif

        rts         ; ERROR and we are done!

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Messages
;

.if patchDOS & initRAMDISK
msg.start
        .byte 'THE!RAMDISK FOR THE!CART AND DOS '
        .byte $a0,$0b2,$ae,$b5,$a0 ; invers _2.5_
msg.start.end
.endif

.if initRAMDISK
msg.notfound
        .byte 'THE!CART NOT FOUND', $9b
msg.notfound.end

msg.setup
        .byte 'SET UP RAMDISK D8:', $9b
msg.setup.end

msg.format
        .byte 'FORMAT RAMDISK', $9b
msg.format.end

msg.copy
        .byte 'COPY DUP.SYS', $9b
msg.copy.end

msg.create
        .byte 'CREATE MEM.SAV', $9b
msg.create.end

msg.error
        .byte 'ERROR-  1' ; error code always >128
msg.error.code
        .byte '01',$9b
msg.error.end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; A string to hold drive name for XIO command
;

drv.name
        .byte 'D8:',$9b  
        
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; File names
;

file.dup.name
        .byte 'D1:DUP.SYS',$9b
file.dup.size   = 5126
file.dup.buffer = BUFFER

file.mem.name
        .byte 'D8:MEM.SAV',$9b
file.mem.size   = NDUP-NDOS
file.mem.buffer = NDOS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Close
;

close ; close channel in X
        ldx #$70
        lda #XIO.CLOSE
        sta IOCB.CMD,X
        jsr CIOV
        rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Check VTOC sector for pre formating
;
; return     Y=0   -> preformated
;            Y=1-3 -> wrong format
;

check.vtoc ; Check VTOC sector
; set DCBSEC and DISKBUF
        lda #<VTOCSEC
        sta DCBSEC
        lda #>VTOCSEC
        sta DCBSEC+1

        lda #<BUFFER
        sta DISKBUF
        lda #>BUFFER
        sta DISKBUF+1
; call RAMIONEW
        clc             ; read
        jsr RAMIO
; check first three bytes
        ldy #$03
        
        lda BUFFER
        cmp #DVDOTYP
        bne check.vtoc.end
        dey

        lda BUFFER+1
        cmp #<DVMAXSC
        bne check.vtoc.end
        dey

        lda BUFFER+2
        cmp #>DVMAXSC
        bne check.vtoc.end
        dey

check.vtoc.end
        rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 
; Print Message
;
; IN    X,Y    low, high byte of address to message
;        A    length of message

print    ;print message
        sta IOCB.BUFLEN
        lda #$00
        sta IOCB.BUFLEN+1
        stx IOCB.BUF
        sty IOCB.BUF+1
        lda #XIO.PUT
        sta IOCB.CMD
        ldx #$00
        jsr CIOV
        rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 
; Buffer for copy

BUFFER  =  *+1
.endif

.if patchDOS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 
; RAMIO: IN DCBSEC: sector number (low, high)
;           CARRY: set -> write to buffer, else -> read
;
; sector buffer address:     RAMIO.SECPTR
; ramdisk sector address:    RAMIO.RAMPTR
;

RAMIO.SECPTR = $43  ; address to buffer, FMSZPG register
RAMIO.RAMPTR = $32  ; address to ramdisk sector 
                    ; ZSECPTR = $32 (share with SIO!)

; number of sectors 1040 $0410
;   %0000010000010000 (16bit)
; split to bank and address 
;   %000001000 %0010000 (9bit Bank + 7bit address)

; address space $8000-$BFFF
; address = %10+(7bit address)+0000000 (16bit)

; Place for new subroutine at same place
; like RAMIO/SETBANK in DOS 2.5:
; RAMIONEW (incl jump to second part) length $55 + $3d = $92
;-----------------------------------------------------------
; RAMIO length $54 and SETBANK length $21  = $75 diff $1d!!!
; but
; memory layout with gaps (see sources of DOS 2.5):
; SETBANK    start $12cb end $12ec gap $1307  = $3d
; RAMIO        start $1481 end $14d4 gap $14d7  = $57 == $94
;---------------------------------------------------------
; perfect $92 < $94
;==================

        org RAMIO
; save the!cart registers
        lda TCMOSL
        pha
        lda TCMOFR
        pha
        lda TCPBRL
        pha
        lda TCPBRH
        pha
        lda TCPBEN
        pha
; save carry (read or write mode)
        php
; calc bank number
        lda DCBSEC      ; get low byte of sector
        asl             ; save Bit8 in carry 
        lda DCBSEC+1    ; get high byte of sector
        rol             ; get Bit8 of low byte 
        asl             ; get bank number with LSB 0
        tay             ; save bank number in Y
; calc address
        lda DCBSEC      ; get low byte of sector
        sec             ; set Bit7
        ror             ; save Bit0 in carry
        and #$bf        ; clear Bit6
        sta RAMIO.RAMPTR+1 ; high byte of address
        lda #$00
        ror             ; make carry Bit7
        sta RAMIO.RAMPTR ; low byte of address
; set buffer address
        lda DISKBUF
        sta RAMIO.SECPTR
        lda DISKBUF+1
        sta RAMIO.SECPTR+1
; set critical mode
        lda #$01
        sta CRITIC      ; tell VBLANK this is critical!
        ldx RTCLOKL
RAMIO.sync
        cpx RTCLOKL     ; got a VBLANK yet?
        beq RAMIO.sync  ; no
        sta NMIEN       ; disable VBI and DLI
        sei             ; and disable IRQ's
; set new The!Cart mode (bank on stack), 30c
        lda #TCMOSL.16K     ; 2c, set 2x8k mode at $8000-$BFFF
        sta TCMOSL          ; 4c,
        lda #TCMOFR.PBRAM   ; 2c, set to RAM
        sta TCMOFR          ; 4c,
        sty TCPBRL          ; 4c, get bank number from Y
; only $57 in RAMIO next part in SETBANK
        jmp RAMIONEW2

        org SETBANK
RAMIONEW2
        ldy #$00            ; 2c,
        sty TCPBRH          ; 4c,
        iny                 ; 2c, enable
        sty TCPBEN          ; 4c,
; copy from/to buffer, 10c
        ldy #$7f            ; 2c, 128 bytes in a sector
        plp                 ; 4c, read or write?
        bcc RAMIO.read      ; 3/4c, read request
RAMIO.write    ; write sector to RAMDISK,  2290c
        lda (RAMIO.SECPTR),Y ; 6c, move 128 bytes...
        sta (RAMIO.RAMPTR),Y ; 6c, ...to RAMDISK
        dey                  ; 2c
        bpl RAMIO.write      ; 3/4c
        bmi RAMIO.copy.end   ; 3/4c all bytes written
RAMIO.read ; read sector from RAMDISK, 2286c
        lda (RAMIO.RAMPTR),Y ; 6c
        sta (RAMIO.SECPTR),Y ; 6c, move 128 bytes
        dey                  ; 2c
        bpl RAMIO.read       ; 3/4c
RAMIO.copy.end
; restore The!Cart registers, 40c
        pla                  ; 4c
        sta TCPBEN           ; 4c
        pla                  ; 4c
        sta TCPBRH           ; 4c
        pla                  ; 4c
        sta TCPBRL           ; 4c
        pla                  ; 4c
        sta TCMOFR           ; 4c
        pla                  ; 4c
        sta TCMOSL           ; 4c
; unset critical mode
        lda #$c0
        sta NMIEN       ; enable VBI's and DLI's
        iny             ; from read/write loop y=ff
                        ; Y(ff)+1 = 0 
        sty CRITIC      ; no longer critical I/O
        cli             ; and IRQ's are now legal
; return code 1 = OK
        iny
        rts

.endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 
; Run address
        run start
