; The!Cart Bank Switch


;
; OS equ
;
TRNSMZ  = $0006
DOSVEC  = $000a
CRITIC  = $0042
LOMEM   = $0080

BASICF  = $03f8

SDMCTL  = $022f
GINTLK  = $3fa
CARTCK  = $3eb
RAMSIZ	= $02e4
MEMTOP  = $02E5
MEMLO   = $02E7

TRIG3   = $d013
DMACTL  = $d400 
NMIEN   = $d40e

PORTB   = $d301

WARMSV  = $e474

WARMST = $08
BOOT?  = $09
COLDST = $0244

; 
; IO EQUATES
; 
IOCB0        =  $0340     ; address of first IOCB
IOCB0.CMD    = IOCB0+2    ; where command goes in IOCB
IOCB0.STAT   = IOCB0+3    ; state returned
IOCB0.BUF    = IOCB0+4    ; buffer (or name) address
IOCB0.BUFLEN = IOCB0+8    ; max buffer length address
IOCB0.AUX1   = IOCB0+10   ; Auxilliary byte 1
IOCB0.AUX2   = IOCB0+11   ; Auxilliary byte 2

IOCB1        =  $0350     ; address of first IOCB
IOCB1.CMD    = IOCB1+2    ; where command goes in IOCB
IOCB1.STAT   = IOCB1+3    ; state returned
IOCB1.BUF    = IOCB1+4    ; buffer (or name) address
IOCB1.BUFLEN = IOCB1+8    ; max buffer length address
IOCB1.AUX1   = IOCB1+10   ; Auxilliary byte 1
IOCB1.AUX2   = IOCB1+11   ; Auxilliary byte 2


XIO.FMT = 254   ; Format command
XIO.INPUT = 5   ; Input Line
XIO.PRINT = 9   ; Print line
XIO.OPEN  = 3   ; Open
XIO.CLOSE = 12  ; Close
XIO.READ  = 4   ; Read
XIO.WRITE = 8   ; Write
XIO.GET   = 7   ; Get
XIO.PUT   = 11  ; Put

XIO.STAT.EOF = $88

CIOV = $E456   ; the classic location

;
; SpartaDOS 
;
SD_BUFOFF		= $0A ; offset in line buffer
SD_LBUF			= $3F ; offset to line buffer
SD_ZCRNAME		= $03 ; offset for jmp to crunch name
SD_COMFNAM		= $21 ; offset to result buffer for crunch name 
SD_LSIO			= $0A ; negative offset to SIO vector

;
; BW-DOS
;

BW_WARMST 		= $15 ; negative offset WARMST $0ce4

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
TCMOSL.OSS   = $04
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




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Clear memory and init cart
;

		org $600
clear_cold
; clear zero page non OS part
        lda #$00
		ldx #$7f
clrlpp  sta LOMEM,x
		dex
		bpl clrlpp

; clear main memory
		lda MEMLO
		sta clrloop+1
		lda MEMLO+1
		sta clrloop+2
		ldx #$00
clrloop	stx $ffff
		inc clrloop+1	; inc address
		bne clrloop
		inc clrloop+2
		lda clrloop+2
		cmp #$C0        ;  max RAMSIZ
		bcc clrloop

; cold start cartridge
		lda #$ff
        sta COLDST
		lda #$00
		sta WARMST
		lda #$01
		sta BOOT?
		jsr _inicarvec
		lda #$00 ;$ff
		sta WARMST
		lda #$00
		sta COLDST
		lda #$01
		sta BOOT?

; reset BW-DOS WARMST
		lda #$00
_warmst	sta $FFFF

just_warm			
		jmp WARMSV      	; warm start

_inicarvec
		jmp ($bffe)		; Cartridge init vector

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Main
;

        org $3000
start        
; message
        ldx #<startmsg.begin
        ldy #>startmsg.begin
        lda #startmsg.end-startmsg.begin
        jsr print

; check for parameter
        ldy #SD_BUFOFF
        lda (DOSVEC),y
        clc
        adc #SD_LBUF
        tay
        lda (DOSVEC),y
        cmp #$9B
        beq prserr

        iny
        sty paridy      ;set index to parameter

; read sys file        
        jsr open
        bmi prserr
                
rdnext  jsr input       ; read line
        bmi filerr
                
        lda #' '
        cmp pbuffer+8   ; check for spaces at 9 and 12
        bne filerr
        lda #' '
        cmp pbuffer+11
        bne filerr
        
        jsr check
        bcs found
        
        inc lcnt
        jmp rdnext

; exit with parse error                  
prserr  jsr close
        ldx #<errprs.begin
        ldy #>errprs.begin
        lda #errprs.end-errprs.begin
        jsr print
        jsr list
        rts

; exit with file error                  
filerr  lda #XIO.STAT.EOF     ; ignore end of file
        cmp IOCB1.STAT
        beq filend
        lda lcnt
        jsr convha
        stx errfil.line
        sty errfil.line+1
        ldx #<errfil.begin
        ldy #>errfil.begin
        lda #errfil.end-errfil.begin
        jsr print
        jsr close
        rts
        
filend  ldx #<errnfd.begin
        ldy #>errnfd.begin
        lda #errnfd.end-errnfd.begin
        jsr print
        jsr close
        jsr list
        rts

; read mode and bank
found   jsr close

        jsr rpara

; set WARMST
		sec
		lda DOSVEC
		sbc #BW_WARMST
		sta _warmst+1        
		lda DOSVEC+1
		sbc #$00
		sta _warmst+2

; switch The!Cart
        lda #$00        ; switch off DMA
        sta SDMCTL
        sta DMACTL

        sei             ; mask all interrupts
        lda #$00
        sta NMIEN
        
        lda #$02		; switch off BASIC ROM
		ora PORTB
		sta PORTB
		lda #$01
		sta BASICF

; set TC register
        sta TCPBEN		; diable and set:
        sta TCSBRL      ; disable Secondary Bank 
        sta TCSBRH
        sta TCSBEN
        sta TCMOFR      ; cfg flash r/o

        lda mode        ; set mode
        sta TCMOSL
        tax				; in X for cmp later

        lda bankl		; set P bank
        sta TCPBRL
        lda bankh
        sta TCPBRH
        
		lda #$01		; finally enable and do not read/write
        sta TCPBEN		; TC register any further

; check for off
        cpx #TCMOSL.OFF
        beq _nocar

; check for OSS
		cpx #TCMOSL.OSS
		bne _inicar
		sta $d500		; reset OSS cartdridge

_inicar
; prepare init car and warm start
        lda #$01        ; set cartridge flag
        sta TRIG3
        sta GINTLK
        sta TRNSMZ
        lda #$00        ; set cart check sum
        tax
        clc
_ccloop adc $bff0,x
        inx
        bne _ccloop
        sta CARTCK
		jmp clear_cold

_nocar  lda #$00        ; set cartridge flag
        sta TRIG3
        sta GINTLK
        sta TRNSMZ
        sta CARTCK      ; set cart check sum
		jmp just_warm

; THE END


; messages        

startmsg.begin
        .byte 'CAR for The!Cart ver44bw hjx',$9B
startmsg.end

errprs.begin
        .byte '  Error - no parameter',$9b
errprs.end

errfil.begin
        .byte '  Error - TCAR.SYS',$9b
        .byte '  Parsing line $'
errfil.line
        .byte 'XX',$9B
errfil.end

errnfd.begin
        .byte '  Error - not found',$9b
errnfd.end

erruse.begin
        .byte '  Use TCAR name:',$9B
erruse.end

; variables

lcnt    .byte $01        
paridy  .byte $00
mode    .byte $00
bankl   .byte $00
bankh   .byte $00
        
fname   .byte 'D1:>TCAR.CFG',$9b
lbuffer .byte '    '
pbuffer .byte '________________',$9b,$FF


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 
; List 
;
list    ldx #<erruse.begin
        ldy #>erruse.begin
        lda #erruse.end-erruse.begin
        jsr print
        
        jsr open
_list   jsr input       ; read line
        bmi _endlst

        lda #' '        ; reset current mark
        sta lbuffer+3
        
        jsr rpara
        
        lda TCMOSL      ; cmp current with para
        cmp mode
        bne _print

        lda TCPBRH
        cmp bankh
        bne _print

        lda TCPBRL
        cmp bankl
        bne _print

        lda #'>'        ; set current mark
        sta lbuffer+3

_print  lda #$9b        ; set return after name
        sta pbuffer+8

        ldx #<lbuffer
        ldy #>lbuffer
        lda #$0d
        jsr print
        
        jmp _list 

_endlst jsr close
        rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Read parameter (mode, bank low and bank high)
;
rpara   ldx pbuffer+9   ; read mode
        ldy pbuffer+10
        jsr convah
        sta mode

        ldx pbuffer+12  ; read bank low
        ldy pbuffer+13
        jsr convah
        sta bankh

        ldx pbuffer+14  ; read bank high
        ldy pbuffer+15
        jsr convah
        sta bankl
        
        rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 
; Check Command Line with File Buffer
;
; IN    pbuffer   address to file buffer
;       paridy    index to parameter in DOSVEC

check ; check command line and file buffer  
        ldx #$00
        ldy paridy 
checkn  lda (DOSVEC),y
        cmp pbuffer,x
        bne checkc
        inx
        iny
        jmp checkn
        
checkc  cmp #$9b
        bne notfnd
        lda #' '
        cmp pbuffer,x
        bne notfnd
        
        sec
        rts

notfnd  clc
        rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 
; Convert ATASCI to hex
;
; IN    X,Y   high, low ASCII digit 
;        A    hex value

convah  txa
        sec
        sbc #'0'
        cmp #10
        bcc hnum0_9
        sbc #'A'-'9'-1
hnum0_9 asl
        asl
        asl
        asl
        sta hbits+1
        tya
        sec
        sbc #'0'
        cmp #10
        bcc lnum0_9
        sbc #'A'-'9'-1
lnum0_9 and #$0F
hbits   ora #$00
        rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 
; Convert Hex to ATASCII
;
; IN    A    byte
; OUT X,Y    two ATASCII codes of hex representation
;

convha ; conv hex to atascii
        pha                    
        lsr
        lsr
        lsr
        lsr
        sed        
        clc
        adc #$90
        adc #$40
        tax
        pla
        and #$0f
        clc
        adc #$90
        adc #$40
        tay
        cld            
        rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 
; Print Message
;
; IN    X,Y    low, high byte of address to message
;        A    length of message

print ; print message
        sta IOCB0.BUFLEN
        lda #$00
        sta IOCB0.BUFLEN+1
        stx IOCB0.BUF
        sty IOCB0.BUF+1
        lda #XIO.PUT
        sta IOCB0.CMD
        ldx #$00
        jsr CIOV
        rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 
; Open File for Read
;
; IN    X,Y    low, high byte of address to file name
;

open ; open file
        lda #<fname
        sta IOCB1.BUF
        lda #>fname
        sta IOCB1.BUF+1
        lda #XIO.READ
        sta IOCB1.AUX1
        lda #$00
        sta IOCB1.AUX2
        lda #XIO.OPEN
        sta IOCB1.CMD
        ldx #$10
        jsr CIOV
        rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 
; Input from File
;
; IN    X,Y    low, high byte of address to buffer
;       A      length of buffer

input ; input file
        lda #<pbuffer
        sta IOCB1.BUF
        lda #>pbuffer
        sta IOCB1.BUF+1
        lda #$11
        sta IOCB1.BUFLEN
        lda #$00
        sta IOCB1.BUFLEN+1        
        lda #XIO.INPUT
        sta IOCB1.CMD
        ldx #$10
        jsr CIOV
        rts
        
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 
; Close File
;
close   lda #XIO.CLOSE
        sta IOCB1.CMD
        ldx #$10
        jsr CIOV
        rts
        
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 
; Run address
;
        run start