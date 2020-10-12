; The!Cart Ramdisk Format

;
; OS EQUATES
;
RTCLOK   = $0012
CRITIC   = $42

SDMCTL   = $022F
CH       = $02FC

DMACTL   = $D400
NMIEN    = $D40E

;
; IO EQUATES
;
CIOV        = $E456

IOCB0       = $0340
 
ICCOM       = $0342
ICBLL       = $0348
ICBLH       = $0349


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
TCMOFR.FLASH = $00
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


; Start of code
;
            org $3000
start
; info message
            jsr print
            .byte 'Format for The!Cart ver42bw hjx',$9B,$FF
            
; check if we are running on THE!CART hardware
	        lda TCMOSL
    	    cmp #TCMOSL.XLLOCK
        	beq errorNoCart
        	cmp #TCMOSL.XELOCK
        	beq errorNoCart
        	bne startQuest
 
errorNoCart
        	jsr PRINT
        	.byte '  Error - The!Cart not found',$9B,$FF
        	rts

startQuest
	        jsr PRINT
        	.byte 'Start format RAM disk? (Y)',$ff
        
        	jsr getKey
        	cmp #$2B
        	beq startFormat

        	jsr PRINT
        	.byte $9b,'Abort.',$9b,$ff
        	rts
startFormat
			jsr FRMTRD
        	jsr PRINT
        	.byte $9b,'Finished.',$9b,$ff
            rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; format ramdisk
;
FRMTRD      jsr cart_save

; header loop            
            ldx #$00
            jsr cart_set
            ldy #$7f
_loophead1  lda RDSEC1,Y
            sta $8000,Y		; sector 1
            dey
            bpl _loophead1
            jsr cart_restore

            ldx #$00
            jsr cart_set
            ldy #$7f
_loophead2  lda RDSEC2,Y
            sta $8080,Y		; sector 2
            dey
            bpl _loophead2
            jsr cart_restore

            ldx #$00
            jsr cart_set
            ldy #$7f
_loophead3  lda RDSEC3,Y
            sta $8100,Y		; sector 3
            dey
            bpl _loophead3
            jsr cart_restore

; set sector 4-7 to $ff VTOV 512k = 4096 sectors
; = 4 VTOC sectors
_loop47     ldx #$00
            jsr cart_set
            lda #$ff
            ldy #$7f
FRMTCLP47   sta $8180,Y
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

; clear sector 8-11 
_loop89     ldx #$00
            jsr cart_set
            lda #$00
            ldy #$7f
FRMTCLP89   sta $8380,Y
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
_loopcnt89  lda #$04
            dec _loopcnt89+1
            bne _loop89

            ldx #$00
            jsr cart_set
; mark used sectors
            lda #$00
            sta $8180   ; sector 1-8
            lda #$1f
            sta $8181   ; sector 9-11
; set sector map for MAIN
            lda #$00    ; two words $0000 (first and last)
            sta $8400
            sta $8401
            sta $8402
            sta $8403
            lda #$0a    ;  and third $0009 start of main
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


; load boot sector to $3000 start $3080 and RTS ($60)
RDSEC1
			.byte $00 ; Usually 0. Some formatting tools put a $53 (='S) for SD here.
            .byte $03 ; Number of sectors to boot.
            .byte $00,$30 ; Address where the boot sectors are loaded to
            .byte $E0,$07 ; This address is copied to DOSINI
            .byte $4c,$80,$30 ; After boot jump here: jmp $3080 (just RTS)
            .byte $09,$00 ; Sector number of the first sector map of the MAIN directory
            .word $1000 ; total sector count
            .word $0ff5 ; free sector count
            .byte $05 ; Number of bit map sectors on the disk
            .byte $04,$00 ; Sector number of the first bit map sector
            .byte $51,$00 ; Sector number to begin the file data sector allocation search
            .byte $0B,$00 ; Sector number to begin the directory data sector allocation search
            .byte 'CART512K' ; Volume name, 8 chars
            .byte $01 ; Tracks on disk (1 for ramdisks and HDs)
            .byte $80 ; Sector size ($80=128,$00=256,$01=512)
;            .byte $20 ; File system version ($20=SD1.1-4.2 version 2.0, $21=Sd4.4> version 2.1) 
;            .byte $00,$00,$00,$00,$00 ; reserved - no known use
;            .byte $00 ; Volume sequence number
;            .byte $00 ; Volume random number
;            .byte $00,$00 ; Sector number of the first sector map of the file to be loaded when the disk is booted
;            .byte $00 ; Lock flag ($ff=locked, $00=unlocked)
;            .byte $00
			.byte $20,$06,$01,$FF,$FF,$00,$00,$E4
			.byte $00,$00,$00,$00,$00,$00,$00,$00
			.byte $45,$72,$72,$6F,$72,$3A,$20,$4E
			.byte $6F,$20,$44,$4F,$53,$9B,$AD,$28
			.byte $30,$8D,$0A,$03,$AD,$29,$30,$8D
			.byte $0B,$03,$A9,$00,$A2,$2F,$20,$F1
			.byte $30,$AD,$00,$2F,$8D,$28,$30,$AD
			.byte $01,$2F,$8D,$29,$30,$A0,$04,$84
			.byte $91,$A4,$91,$CC,$1F,$30,$F0,$D6
			.byte $B9,$00,$2F,$8D,$0A,$03,$B9,$01
			.byte $2F,$8D,$0B,$03,$C8,$C8,$84,$91
			.byte $60,$6C,$E2,$02,$00,$00,$00,$00

RDSEC2
			.byte $A2,$00,$AD,$1F,$30,$85,$91,$85
			.byte $90,$8D,$08,$03,$D0,$01,$E8,$8E
			.byte $09,$03,$20,$0A,$31,$85,$96,$20
			.byte $0A,$31,$25,$96,$C9,$FF,$D0,$37
			.byte $A9,$78,$8D,$E2,$02,$A9,$30,$8D
			.byte $E3,$02,$20,$0A,$31,$85,$92,$20
			.byte $0A,$31,$85,$93,$05,$92,$F0,$1C
			.byte $20,$0A,$31,$38,$E5,$92,$48,$08
			.byte $20,$0A,$31,$28,$E5,$93,$85,$95
			.byte $68,$85,$94,$20,$6B,$31,$20,$79
			.byte $30,$4C,$A0,$30,$6C,$E0,$02,$A9
			.byte $30,$A2,$30,$8D,$44,$03,$8E,$45
			.byte $03,$8E,$48,$03,$A9,$09,$8D,$42
			.byte $03,$A2,$00,$20,$56,$E4,$4C,$EE
			.byte $30,$A0,$40,$8C,$03,$03,$8D,$04
			.byte $03,$8E,$05,$03,$AD,$0A,$03,$0D

RDSEC3
			.byte $0B,$03,$F0,$D3,$20,$59,$E4,$30
			.byte $CE,$60,$A9,$00,$85,$95,$85,$94
			.byte $A6,$90,$EC,$1F,$30,$F0,$06,$BD
			.byte $00,$2E,$E6,$90,$60,$20,$61,$30
			.byte $A5,$95,$D0,$17,$AD,$1F,$30,$F0
			.byte $04,$A5,$94,$30,$0E,$A9,$00,$A2
			.byte $2E,$20,$F1,$30,$38,$26,$90,$AD
			.byte $00,$2E,$60,$A5,$92,$A6,$93,$20
			.byte $F1,$30,$A5,$92,$18,$6D,$08,$03
			.byte $85,$92,$A5,$93,$6D,$09,$03,$85
			.byte $93,$38,$A5,$94,$ED,$08,$03,$85
			.byte $94,$A5,$95,$ED,$09,$03,$85,$95
			.byte $4C,$1D,$31,$A5,$94,$D0,$02,$C6
			.byte $95,$C6,$94,$20,$10,$31,$A0,$00
			.byte $91,$92,$E6,$92,$D0,$02,$E6,$93
			.byte $A5,$94,$05,$95,$D0,$E5,$60,$00



RDMAIN      .byte $28 ; Bits 7-0: OpenWrite,-,SubDir,Del,Used,Arc,Hid,Prot
            .word $0000 ; First sector map of parent directory (MAIN=0)
            .byte $17,$00,$00 ; length of directory in bytes (always times 23 bytes)
RDMAINNAME  .byte 'MAIN       ' ; Name 11 chars
            .byte $0b,$07,$47 ; Date DD/MM/YY
            .byte $0b,$0b,$0b ; Time HH:MM:SS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; subroutines for The Cart
;

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

            lda #$e0          ; enable interrupts
            sta NMIEN
            cli
            dec CRITIC 

            rts

cart_set
            inc CRITIC 
            jsr WAITSYNC        ; wait for vblank
            sei                 ; disable interrupt
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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; print subroutine            
;
print		pla
            sta print_iter+1
            pla
            sta print_iter+2
print_loop  inc print_iter+1
            bne print_iter
            inc print_iter+2
print_iter  lda $ffff
            cmp #$ff
            beq print_end
            
            ldx #$00			; put char
            stx ICBLL
            stx ICBLH
            ldy #$0B
            sty ICCOM
            jsr CIOV
            
            jmp print_loop
print_end   lda print_iter+2
            pha
            lda print_iter+1
            pha
            rts
            
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; get key
;
getKey
			lda #$FF		; check for key
			tax
			cmp CH
			beq getKey
			lda CH
			stx CH
			rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; start address 
;
            run start