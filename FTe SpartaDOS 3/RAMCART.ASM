;
; THE!RAMDISK for THE!CART for SpartaDOS 3 
; Previous work RD/RAMDISK.COM for SpartaDOS 3 by FTe
;   RD Ver 2.3 07-14-86 (c) 1984 by FTe
;
; System equates
;
; OS EQUATES
; ----------
; 
; IO EQUATES
; 
ICCOM       = $0002
ICBLL       = $0008
ICBLH       = $0009
; 
; OS VARIABLES FOR XL/XE
; 
; PAGE 0
; 
DOSVEC      = $000A
DOSINI      = $000C
RTCLOK      = $0012
BUFRLO      = $0032
BUFRHI      = $0033
BFENLO      = $0034
BFENHI      = $0035
CRITIC      = $0042
; 
; PAGE 2
; 
SDMCTL      = $022F
MEMLO       = $02E7
; 
; PAGE 3
; 
DDEVIC      = $0300
DUNIT       = $0301
DCOMND      = $0302
DBUFLO      = $0304
DBUFHI      = $0305
DBYTLO      = $0308
DBYTHI      = $0309
DAUX1       = $030A
DAUX2       = $030B
IOCB0       = $0340
; 
; PIA
; 
PORTA       = $D300
PORTB       = $D301
PACTL       = $D302
PBCTL       = $D303
; 
; ANTIC
;
DMACTL      = $D400 
WSYNC       = $D40A
NMIEN       = $D40E
; 
; ROM VECTORS
; 
CIOV        = $E456
;
; SpartaDOS 
;
SD_BUFOFF      = $0A ; offset in line buffer
SD_LBUF        = $3F ; offset to line buffer
SD_ZCRNAME     = $03 ; offset for jmp to crunch name
SD_COMFNAM     = $21 ; offset to result buffer for crunch name 
SD_LSIO        = $0A ; negative offset to SIO vector

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


; macros

; saves register: pushes bank register on stack
M_cart_push .macro
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
            .endm

; restores register from stack: pops from stack
M_cart_pop  .macro
            pla                 
            sta TCPBEN          
            pla                 
            sta TCPBRH          
            pla                 
            sta TCPBRL          
            pla                 
            sta TCMOFR          
            pla                 
            sta TCMOSL          
            .endm
 
; set bank: number of bank in X, uses A
M_cart_set  .macro
; set new The!Cart mode
            lda #TCMOSL.16K         ; set 2x8k mode at $8000-$BFFF
            sta TCMOSL          
            lda #TCMOFR.PBRAM       ; set to RAM
            sta TCMOFR
            txa
            asl   
            sta TCPBRL              ; get bank number from X
            lda #$00                     
            sta TCPBRH              ; set high to $00
            lda #$01
            sta TCPBEN              ; enable        
            .endm
;
; Start of code
;
            org $3000
            
; info message
            jsr PRINT
            .byte 'THE!RAMDISK ver52 for THE!CART by HJX',$9B,$FF

; check for The!Cart
             lda TCMOSL
             cmp #TCMOSL.XLLOCK
             beq NORAMDISK
             cmp #TCMOSL.XELOCK
             bne RAMDISKINI
NORAMDISK
; no banks            
            jsr PRINT
            .byte '  Error - 512k RAM THE!CART not found',$9B
            .byte '  Use SHIFT+RETURN/ESC in start menu',$9B,$FF
            rts
                        
RAMDISKINI
; check for parameter
            ldy #SD_BUFOFF
            lda (DOSVEC),Y
            clc
            adc #SD_LBUF
            tay
            lda (DOSVEC),Y
            cmp #$9B
            bne PRSPARM
; no parameter -> error
            jmp PARAMERR

; jump for jsr to crunch name
CRNAME      jmp $FFFF

CHKFRMT     .byte $FF

; set crunch name address
PRSPARM     lda DOSVEC
            clc
            adc #SD_ZCRNAME
            sta CRNAME+1
            lda DOSVEC+1
            adc #$00
            sta CRNAME+2
            
; parameter parsing            
; get drive number SD_COMFNAM starts alway with Dx:
            jsr CRNAME
            bne PARAMERR
            ldy #SD_COMFNAM+1
            lda (DOSVEC),Y
            and #$0F
            sta DRVNUM
; check options /N
            jsr CRNAME
            beq PRSPAREND
            ldy #SD_COMFNAM+3
            lda (DOSVEC),Y
            cmp #'/'
            bne PARAMERR
PRSPARLOOP  iny
            lda (DOSVEC),Y

            cmp #$9B         ; end of parameter
            beq PRSPAREND
            
            cmp #'A'         ; try to preserve
            bne PRSPARNXT1
            jsr checkfrmt
            bcc PRSPARLOOP
            inc CHKFRMT
            jmp PRSPARLOOP

PRSPARNXT1  cmp #'F'         ; just format
            bne PRSPARNXT2
            jmp FRMTRD

PRSPARNXT2  cmp #'N'         ; format ?
            bne PARAMERR
; check format at startup to preserve existing RAM disk            
            inc CHKFRMT

            jmp PRSPARLOOP

PRSPAREND   jmp STARTINST

PARAMERR    jsr PRINT
            .byte '  Error - Wrong parameter',$9B
            .byte '  Use RAMCART Dn: [/N|A|F]',$9B
            .byte '    N - driver no format',$9B
            .byte '    A - driver auto format if needed',$9B
            .byte '    F - format no driver',$9B
            .byte '    w/o option driver and format',$9B,$FF
            rts

STARTINST   jsr PRINT
            .byte '  Install driver',$9B,$FF
; set jsr to original DOSINI
            lda DOSINI
            sta JSRDOSINI+1
            lda DOSINI+1
            sta JSRDOSINI+2

; set MEMLO oldaddress, realloc
            lda MEMLO
            sta READSTADR
            sta CPYTOADR
            lda MEMLO+1
            sta READSTADR+1
            sta CPYTOADR+1
;
; start realloc
;
            jsr REASTART

; set new DOSINI            
REAL001     lda #<JSRDOSINI
            sta DOSINI
REAH001     lda #>JSRDOSINI
            sta DOSINI+1
; get SIO and patch for RAMDISK
            sec
            lda DOSVEC
            sbc #SD_LSIO
            sta BUFRLO
            lda DOSVEC+1
            sbc #$00
            sta BUFRHI
            ldy #$00
            lda (BUFRLO),Y
REAA001     sta JMPSIO+1      ;realloc $33CA
REAL002     lda #<RAMDSIO
            sta (BUFRLO),Y
            iny
            lda (BUFRLO),Y
REAA002     sta JMPSIO+2      ;realloc $33D4
REAH002     lda #>RAMDSIO
            sta (BUFRLO),Y
; set MEMLO            
REAA003     jsr SETMEMLO      ;realloc $33DB
; format if requested            
            bit CHKFRMT
            bmi FRMTRD
            rts

; format ramdisk
FRMTRD      jsr PRINT
            .byte '  Formatted 512k',$9B,$FF

            jsr cart_save

; clear sector 0-3
_loop03     ldx #$00
            jsr cart_set
            lda #$00
            ldy #$7f
FRMTCLP03   sta $8000,Y
            dey
            bpl FRMTCLP03
            jsr cart_restore
            lda FRMTCLP03+1
            clc
            adc #$80
            sta FRMTCLP03+1
            lda FRMTCLP03+2
            adc #$00
            sta FRMTCLP03+2
_loopcnt03  lda #$04
            dec _loopcnt03+1
            bne _loop03

; header loop            
            ldx #$00
            jsr cart_set
            ldy #$2b
_loopheader lda RDHEAD,Y
            sta $8080,Y
            dey
            bpl _loopheader
            lda #$60    ; write RTS to second boot sector
            sta $8100   ; see header jmp $3080
            jsr cart_restore


; set sector 4-7 to $ff VTOV 512k = 4096 sectors
; = 4 VTOC sectors
_loop47     ldx #$00
            jsr cart_set
            lda #$ff
            ldy #$7f
FRMTCLP47   sta $8200,Y
            dey
            bpl FRMTCLP47
            jsr cart_restore
            lda FRMTCLP47+1
            clc
            adc #$80
            sta FRMTCLP47+1
            lda FRMTCLP47+2
            adc #$00
            sta FRMTCLP47+2
_loopcnt47  lda #$04
            dec _loopcnt47+1
            bne _loop47

; clear sector 8-9 
_loop89     ldx #$00
            jsr cart_set
            lda #$00
            ldy #$7f
FRMTCLP89   sta $8400,Y
            dey
            bpl FRMTCLP89
            jsr cart_restore
            lda FRMTCLP89+1
            clc
            adc #$80
            sta FRMTCLP89+1
            lda FRMTCLP89+2
            adc #$00
            sta FRMTCLP89+2
_loopcnt89  lda #$02
            dec _loopcnt89+1
            bne _loop89

            ldx #$00
            jsr cart_set
; write magic for Ebiguy
            lda MAGIC
            sta $8000
            
            lda MAGIC+1
            sta $8000+1
            
            lda MAGIC+2
            sta $8000+2
            
            lda MAGIC+3
            sta $8000+3
            
            lda MAGIC+4
            sta $8000+4
            
            lda MAGIC+5
            sta $8000+5
            
            lda MAGIC+6
            sta $8000+6
            
            lda MAGIC+7
            sta $8000+7
; mark used sectors
            lda #$00
            sta $8200   ; sector 0-7
            lda #$3f
            sta $8201   ; sector 8-9
;            lda #$fe
;            sta $83ff   ; sector 4096 does not exit
; set sector map for MAIN
            lda #$00    ; two words $0000 (first and last)
            sta $8400
            sta $8401
            sta $8402
            sta $8403
            lda #$09    ;  and third $0009 start of main
            sta $8404
; set MAIN directory            
            ldx #$00
_loopmain   lda RDMAIN,x
            sta $8480,x
            inx
            cpx #$17
            bne _loopmain
            jsr cart_restore

; finished
            rts
            
MAGIC       .byte $34,$23,$32,$21,$2D,$24,$33,$2B
            
; load boot sector to $3000 start $3080 and RTS ($60)
RDHEAD      .byte $00 ; Usually 0. Some formatting tools put a $53 (='S) for SD here.
            .byte $03 ; Number of sectors to boot.
            .byte $00,$30 ; Address where the boot sectors are loaded to
            .byte $E0,$07 ; This address is copied to DOSINI
            .byte $4c,$80,$30 ; After boot jump here: jmp $3080 (just RTS)
            .byte $08,$00 ; Sector number of the first sector map of the MAIN directory
            .word $1000 ; total sector count
            .word $0ff6 ; free sector count
            .byte $04 ; Number of bit map sectors on the disk
            .byte $04,$00 ; Sector number of the first bit map sector
            .byte $28,$00 ; Sector number to begin the file data sector allocation search
            .byte $0A,$00 ; Sector number to begin the directory data sector allocation search
            .byte 'CART512K' ; Volume name, 8 chars
            .byte $01 ; Tracks on disk (1 for ramdisks and HDs)
            .byte $80 ; Sector size ($80=128,$00=256,$01=512)
            .byte $20 ; File system version ($20=SD1.1-4.2 version 2.0, $21=Sd4.4> version 2.1) 
            .byte $00,$00,$00,$00,$00 ; reserved - no known use
            .byte $00 ; Volume sequence number
            .byte $00 ; Volume random number
            .byte $00,$00 ; Sector number of the first sector map of the file to be loaded when the disk is booted
            .byte $00 ; Lock flag ($ff=locked, $00=unlocked)
            .byte $00

RDMAIN      .byte $28 ; Bits 7-0: OpenWrite,-,SubDir,Del,Used,Arc,Hid,Prot
            .word $0000 ; First sector map of parent directory (MAIN=0)
            .byte $17,$00,$00 ; length of directory in bytes (always times 23 bytes)
RDMAINNAME  .byte 'MAIN       ' ; Name 11 chars
            .byte $0b,$07,$47 ; Date DD/MM/YY
            .byte $0b,$0b,$0b ; Time HH:MM:SS

; check preformat
checkfrmt
            jsr cart_save
            ldx #$00
            jsr cart_set

_nxtcharv   lda RDMAINNAME,x    ; check volume name
            cmp $8486,x
            bne _nofrmt
            inx
            cpx #$0b
            bne _nxtcharv
            
            jsr cart_restore
            sec
            rts
            
_nofrmt     jsr cart_restore
            clc
            rts

; wait for sync            
WAITSYNC    lda RTCLOK+2
WAITLOOP    cmp RTCLOK+2
            beq WAITLOOP
            rts

cart_save
            lda TCMOSL
            sta _tcmosl
            lda TCMOFR
            sta _tcmofr
            lda TCPBRL
            sta _tcpbrl
            lda TCPBRH
            sta _tcpbrh
            lda TCPBEN
            sta _tcpben

            rts

cart_restore
            lda _tcmosl
            sta TCMOSL
            lda _tcmofr
            sta TCMOFR
            lda _tcpbrl
            sta TCPBRL
            lda _tcpbrh
            sta TCPBRH
            lda _tcpben
            sta TCPBEN

            lda _nmien          ; enable interrupts
            sta NMIEN
            cli
            dec CRITIC 

            rts

cart_set
            inc CRITIC 
            jsr WAITSYNC        ; wait for vblank
            sei
            lda NMIEN
            sta _nmien
            lda #$00
            sta NMIEN

            lda #TCMOSL.16K         ; set 2x8k mode at $8000-$BFFF
            sta TCMOSL          
            lda #TCMOFR.PBRAM       ; set to RAM
            sta TCMOFR
            txa
            asl   
            sta TCPBRL              ; get bank number from X
            lda #$00                     
            sta TCPBRH              ; set high to $00
            lda #$01
            sta TCPBEN              ; enable        

            rts            

_tcmosl     .byte $00
_tcmofr     .byte $00
_tcpbrl     .byte $00
_tcpbrh     .byte $00
_tcpben     .byte $00

_nmien      .byte $00
            
; print subroutine            
PRINT       pla
            sta PRINTITER+1
            pla
            sta PRINTITER+2
PRINTLOOP   inc PRINTITER+1
            bne PRINTITER
            inc PRINTITER+2
PRINTITER   lda $FFFF
            cmp #$FF
            beq PRINTEND
            jsr CIOPUTCHR
            jmp PRINTLOOP
PRINTEND    lda PRINTITER+2
            pha
            lda PRINTITER+1
            pha
            rts
; call cio put char subroutine
CIOPUTCHR   ldx #$00
            stx IOCB0+ICBLL
            stx IOCB0+ICBLH
            ldy #$0B
            sty IOCB0+ICCOM
            jmp CIOV



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; BEGIN OF REALLOC BLOCK
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; to realloc routines
; DOSINI set MEMLO at reset
REABEGIN

JSRDOSINI   jsr $0000
SETMEMLO    
REAL003     lda #<REAEND
            sta MEMLO
REAH003     lda #>REAEND
            sta MEMLO+1
            rts

; new DOSVEC for RAMDISK device
RAMDSIO     lda DDEVIC
            cmp #$31
            bne JMPSIO
            lda DUNIT
REAA004     cmp DRVNUM
            beq NEWSIOGO
JMPSIO      jmp $0000

; set buffer address
NEWSIOGO    lda DBUFLO
            sta BFENLO
            lda DBUFHI
            sta BFENHI
; load commad byte            
            lda DCOMND
; command STATUS REQUEST
            cmp #$53 
            bne NEXT1
REAA009     lda CONFSECSIZ
            lsr
            lsr
            eor #$30
REAA010     ldy L36BB
            cpy #$1A
            bne L35B4
            ora #$80
L35B4       ldy #$00
            sta (BFENLO),Y
            iny
            lda #$FF
            sta (BFENLO),Y
            bmi JMPSIOEND
            
; command RETURN CONFIGURATION            
NEXT1       cmp #$4E
            bne NEXT2
            ldy #$0B            ; 12 bytes
RETCNFLOOP
REAA011     lda CONFBUF,Y
            sta (BFENLO),Y
            dey
            bpl RETCNFLOOP
            bmi JMPSIOEND

; command SET CONFIGURATION
NEXT2       cmp #$4F
            bne NEXT3
            ldy #$07
            lda (BFENLO),Y
            beq REAA020         ; error if sec size <> $80 ( $00 -> $100)            
REAA012     sta CONFSECSIZ
            ldy #$03
            lda (BFENLO),Y
REAA013     sta L36BB

JMPSIOEND
REAA014     jmp RDSIOEND

; command FORMAT DISK
NEXT3       cmp #$21
            bne NEXT4
SIOFRMT     ldy #$00
            lda #$FF
            sta (BFENLO),Y
            iny
            sta (BFENLO),Y
            bne JMPSIOEND

; command FORMAT DISK ENHANCED
NEXT4       cmp #$22
            bne NEXT5
            lda #$1A
REAA015     sta L36BB
            lda #$80
REAA016     sta CONFSECSIZ
            bne SIOFRMT
            
; command PUT/GET SECTOR 
NEXT5       cmp #$52            ; command GET SECTOR
            beq PUTGETSEC
            cmp #$57            ; command PUT SECTOR WITH VERIFY
            beq PUTGETSEC
            cmp #$50            ; command PUT SECTOR
            beq PUTGETSEC
REAA020     jmp RDSIOEND+3      ; error NAK, command not supported
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; buffer address and calc byte count
PUTGETSEC   lda #$00
            sta BUFRLO

            lda DAUX1
;            sec
;            sbc #$01
            sta BUFRHI

            lda DAUX2
;            sbc #$00
;
            asl BUFRHI
            rol
            tax                 ; set X with memory bank number
            lda BUFRHI
            lsr
            lsr
            ror BUFRLO
            ora #$80
            sta BUFRHI
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; set buffer address in copy loops
            lda BUFRLO
REAA021     sta GETADRLP+1
REAA022     sta PUTADRLP+1
            lda BUFRHI
REAA023     sta GETADRLP+2
REAA024     sta PUTADRLP+2            
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; check for GET
            lda DCOMND
            cmp #$52
            beq L3656           ; is GET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PUT: put user data to buffer            
            ldy #$7F
L364B       lda (BFENLO),Y
REAA005     sta BUFFERXX1,Y
            dey
            bpl L364B
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; check if bank number is in range            
L3656       cpx #$20            ; check bank number
            bcs REAA020         ; intermediate jmp to NAK
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
            M_cart_push         ; save register
            inc CRITIC
            lda RTCLOK+2
WAITLOOP2   cmp RTCLOK+2
            beq WAITLOOP2
            sei                 ; 40 cycles
            lda NMIEN
            pha
            lda #$00
            sta NMIEN
            M_cart_set          ; set bank, number in X
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; check for PUT
            ldy #$7F            ; 9 cycles
            lda DCOMND
            cmp #$52
            bne L369B           ; is PUT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; GET: read data to buffer
L367B
;            lda (BUFRLO),Y      ; 6 cycles
GETADRLP    lda $FFFF,Y
REAA006     sta BUFFERXX1,Y     ; 5 cycles +
            dey                 ; 2 cycles +
            bpl L367B           ; 4 cycles + * 128 = 2176
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; restore bank for write to user buffer
            pla
            tax
            M_cart_pop          ; restore register            
            stx NMIEN
            cli
            dec CRITIC          ; 54 cycles
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;            
; GET: write buffer to user data            
            ldy #$7F
L368E
REAA008     lda BUFFERXX1,Y
            sta (BFENLO),Y
            dey
            bpl L368E
            bmi RDSIOEND
            
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PUT: buffer data to sector
L369B
REAA007     lda BUFFERXX1,Y   ; 5 cycles                
;            sta (BUFRLO),Y    ; 6 cycles +              
PUTADRLP    sta $FFFF,Y
            dey               ; 2 cycles +              
            bpl L369B         ; 4 cycles + * 128 = 2176 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; restore register
            pla
            tax
            M_cart_pop          ; restore register
            stx NMIEN
            cli
            dec CRITIC          ; 54 cycles
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; enable interrupts and set rc            
RDSIOEND    ldy #$01
            bit $8BA0           ; $2c, ldy #$8b; bank/sector number error #139 NAK

            tya                 ; set RC
            rts
            
; drive configuration buffer
CONFBUF     .byte $28,$01,$12
L36BB       .byte $00
            .byte $00,$00,$00
CONFSECSIZ  .byte $80                   ; $80 -> 128Byte, $00 -> 256Byte
            .byte $FF,$00,$00,$00

DRVNUM      .byte $01
; $80 for 128Bytes ($100 for 256Bytes)
BUFFERXX1
;            org $37E6
REAEND      = BUFFERXX1 + $80
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; END OF REALLOC BLOCK
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; $20 Bytes
BNKSAVBUF   = REAEND

; $20 bytes
;            org $3806
;BNKSAVBUF2  = BNKSAVBUF + $20

 
;           org $3826
            org BNKSAVBUF + $20
; realloc whole addresses
REATAB      .word REAA001+1 ;$33CA
            .word REAA002+1 ;$33D4
            .word REAA003+1 ;$33DB
            .word REAA004+1 ;$3583
            .word REAA005+1 ;$364E
            .word REAA006+1 ;$367E
            .word REAA007+1 ;$369C
            .word REAA008+1 ;$368F
            .word REAA009+1 ;$35A5
            .word REAA010+1 ;$35AC
            .word REAA011+1 ;$35C6
            .word REAA012+1 ;$35D8
            .word REAA013+1 ;$35DF
            .word REAA014+1 ;$35E2
            .word REAA015+1 ;$35FA
            .word REAA016+1 ;$35FF
            .word REAA020+1 ;$3610
            .word REAA021+1
            .word REAA022+1
            .word REAA023+1
            .word REAA024+1
            .word $0000
 
; realloc address low byte           
            .word REAL001+1 ;$33B1
            .word REAL002+1 ;$33CD
            .word REAL003+1 ;$356E
            .word $0000
; realloc address high byte (address to high byte and value of low byte)
            .word REAH001+1  ;$33B5
            .byte <JSRDOSINI ;$6A
                        
            .word REAH002+1 ;$33D7
            .byte <RAMDSIO  ;$78
            
            .word REAH003+1  ;$3573
            .byte <REAEND    ;$E6
            

            .word $0000
            
REASTART    lda #$00
            sta REALOOPCNT
REALOOP     ldx REALOOPCNT
            lda REATABADR,X
            sta L3910+1
            lda REATABADR+1,X
            sta L3910+2
            ora L3910+1
            bne L3881
            rts
            
L3881       sec
            lda READSTADR,X
            sbc REASRCADR,X
            sta READIFLO
            lda READSTADR+1,X
            sbc REASRCADR+1,X
            sta READIFHI
            
L3894       jsr L391C
            beq L38AC
            lda ($D7),Y
            clc
            adc READIFLO
            sta ($D7),Y
            iny
            lda ($D7),Y
            adc READIFHI
            sta ($D7),Y
            jmp L3894
L38AC       jsr L391C
            beq L38BC
            lda ($D7),Y
            clc
            adc READIFLO
            sta ($D7),Y
            jmp L38AC
L38BC       jsr L391C
            beq L38D2
            jsr L3910
            clc
            adc READIFLO
            lda ($D7),Y
            adc READIFHI
            sta ($D7),Y
            jmp L38BC
L38D2       ldx REALOOPCNT

            lda CPYFROMADR,X
            sta L38F2+1
            lda CPYFROMADR+1,X
            sta L38F2+2

            lda CPYTOADR,X
            sta L38F2+4
            lda CPYTOADR+1,X
            sta L38F2+5

            ldy CPYLENGTH+1,X
            ldx #$00
L38F2       lda $FFFF,X
            sta $FFFF,X
            inx
            bne L38F2
            inc L38F2+2
            inc L38F2+5
            dey
            bpl L38F2
            lda REALOOPCNT
            clc
            adc #$0C
            sta REALOOPCNT
            jmp REALOOP
            
L3910       lda $FFFF
            inc L3910+1
            bne L391B
            inc L3910+2
L391B       rts

L391C       jsr L3910
            sta $D7
            jsr L3910
            ldy #$00
            sta $D8
            ora $D7
            rts

; realloc code pointer
REATABADR   .word REATAB
REASRCADR   .word REABEGIN
READSTADR   .word $FFFF
; copy code pointer
CPYFROMADR  .word REABEGIN
CPYLENGTH   .word REAEND-REABEGIN ;$027C
CPYTOADR    .word $FFFF
            .word $0000
            
; $01 byte
REALOOPCNT  ;= $392B
READIFLO   = REALOOPCNT+1
READIFHI   = READIFLO+1


         
