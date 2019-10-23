;
; Extended RAMDISK for SpartaDOS 3 for U1MB (RAMBO 1088k)
;
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

;        PORTB $D301 XE
;        
;        0 - OS ROM on=1 off=0
;        1 - BASIC  on=0 off=1
;        2 - Bank-Switch
;        3 - Bank-Switch
;        4 - CPU-Switch   off=1 on=0
;        5 - ANTIC-Switch off=1 on=0
;        6 - unsued
;        7 - Self-Test on=1 off=0
;        
;        Mask 7E PORTBMASK
;        0111 1110
;        
;        Mask FD
;        1111 1101
;        
;        Mask FD
;        1111 1110
;        
;        Bank Switch
;        
;        format
;        lda bnkswtmsk  0110.0000
;        eor portb.     0000.0011 -> 0110.0011
;        and #$7e       0111.1110 -> 0110.0010
;        eor portb.     0000.0011 -> 0110.0001
;        
;        BNKSWTMSK
;        $60 - 0110 0000
;        $64 - 0110 0100
;        $68 - 0110 1000
;        $6C - 0110 1100
;        
;        $20 - 0010 0000
;        $24 - 0010 0100
;        $28 - 0010 1000
;        $2C - 0010 1100
;        
;        $40 - 0100 0000
;        $44 - 0100 0100
;        $48 - 0100 1000
;        $4C - 0100 1100
;        
;        $00 - 0000 0000
;        $04 - 0000 0100
;        $08 - 0000 1000
;        $0C - 0000 1100
;        
;        $62 - 0110 0010
;        $66 - 0110 0110
;        $6A - 0110 1010
;        $6E - 0110 1110
;        
;        $22 - 0010 0010
;        $26 - 0010 0110
;        $2A - 0010 1010
;        $2E - 0010 1110
;        
;        $42 - 0100 0010
;        $46 - 0100 0110
;        $4A - 0100 1010
;        $4E - 0100 1110
;        
;        $02 - 0000 0010
;        $06 - 0000 0110
;        $0A - 0000 1010
;        $0E - 0000 1110




;
; Start of code
;
            org $3000

; save PIA PORT B
            lda PORTB
            pha

; switch off interrupts
            sei
            lda #$00
            sta NMIEN
            
; try to save and write banks            
            ldx #$3F
BNKSAVWRT   lda BNKSWTMSK,X
            sta PORTB
            lda $7000
            sta BNKSAVBUF,X
            lda BNKSWTMSK,X
            sta $7000
            lda $7001
            sta BNKSAVBUF2,X
            lda BNKSWTMSK,X
            asl
            sta $7001
            dex
            bpl BNKSAVWRT
            
; check banks
BNKCHK      inx
            lda BNKSWTMSK,X
            sta PORTB
            lda BNKSWTMSK,X
            cmp $7000
            bne BNKSTOP
            lda BNKSWTMSK,X
            asl
            cmp $7001
            bne BNKSTOP
            cpx #$3F
            bne BNKCHK
            inx
BNKSTOP     stx BNKCNT

; restore banks
            ldx #$00
BNKRESTR    lda BNKSWTMSK,X
            sta PORTB
            lda BNKSAVBUF,X
            sta $7000
            lda BNKSAVBUF2,X
            sta $7001
            inx
            cpx #$40
            bne BNKRESTR

; restore PIA PORT B
            pla
            sta PORTB

; enable interrupts
            lda #$E0
            sta NMIEN
            cli

; info message
            jsr PRINT
            .byte 'RD  Ver 2.4 U1MB/1088k by HJX vers43',$9B
            .byte ' (C) 1986 ICD Inc.',$9B,$9B,$FF

            jsr PRINT
            .byte 'Computer is: ',$FF

; check bank count
            ldx BNKCNT
            cpx #$04
            bcc EXT_NO
            bne EXT_192
            jsr PRINT
            .byte '128K - 130XE  (64K)',$9B,$FF
            jmp EXT_END

; no banks            
EXT_NO      jsr PRINT
            .byte '800XL unmodified',$9B
            .byte '-- No RAM Disk Installed',$9B,$FF
            rts
            
EXT_192     cpx #$0C
            beq EXT_256
            bcs EXT_320
            jsr PRINT
            .byte '192K - 130XE  (128K)',$9B,$FF
            jmp EXT_END

EXT_256     jsr PRINT
            .byte '256K - 800/1200XL (192K)',$9B,$FF
            jmp EXT_END
            
EXT_320     cpx #$10
            bne EXT_576
            jsr PRINT
            .byte '320K - 130XE  (256K)',$9B,$FF
            jmp EXT_END
            
EXT_576     cpx #$20
            bne EXT_1088     
            jsr PRINT
            .byte '576K - 130XE (512K)',$9B,$FF
            jmp EXT_END

EXT_1088    cpx #$40
            beq EXT_1088EQ
            jmp EXT_NO
EXT_1088EQ  jsr PRINT
            .byte '1088K - 130XE (1024K)',$9B,$FF

; check for parameter
EXT_END     ldy #SD_BUFOFF
            lda (DOSVEC),Y
            clc
            adc #SD_LBUF
            tay
            lda (DOSVEC),Y
            cmp #$9B
            bne PRSPARM
            
; no parameter -> error
            jsr PRINT
            .byte '-- No Drive Number Specified',$9B,$FF
            rts

; jump for jsr to crunch name
CRNAME      jmp $FFFF

CHKFRMT     .byte $FF
RDBNKCNT    .byte $00

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
; check options /EN
            jsr CRNAME
            beq PRSPAREND
            ldy #SD_COMFNAM+3
            lda (DOSVEC),Y
            cmp #'/'
            bne PARAMERR
PRSPARLOOP  iny
            lda (DOSVEC),Y
            cmp #$9B
            beq PRSPAREND
            cmp #'E'
            bne PRSPARNXT
; save 4 banks for 130XE compatibilty
            lda #$04
            sta SPARBNKS
            bne PRSPARLOOP
PRSPARNXT   cmp #'N'
            bne PARAMERR
; check format at startup to preserve existing RAM disk            
            inc CHKFRMT
            jmp PRSPARLOOP
PARAMERR    jsr PRINT
            .byte '-- Parameter Error',$9B,$FF
            rts

; set jsr to original DOSINI
PRSPAREND   lda DOSINI
            sta JSRDOSINI+1
            lda DOSINI+1
            sta JSRDOSINI+2

; check for spare banks
            lda SPARBNKS
            beq NOSPARBNK
            lda BNKCNT
            cmp #$04
            bne BNKCNTOK
            jsr PRINT
            .byte 'Error -- No Extra RAM For RAMDISK',$9B,$FF
            rts
; message if banks are reserved
BNKCNTOK    jsr PRINT
            .byte '<RAMDISK Uses 64K Less Memory>',$9B,$FF

; set MEMLO oldaddress, realloc
NOSPARBNK   lda MEMLO
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
            .byte '   <RAM Disk Formatted>',$9B,$FF
; switch off interrupts
            sei
            lda #$00
            sta NMIEN
; switch bank
            lda PORTB
            pha
            ldx SPARBNKS
            lda BNKSWTMSK,X
            sta PORTB
; clear loop
            lda #$00
            tay
FRMTCLP     sta $4000,Y
            sta $4100,Y
            sta $4200,Y
            sta $4300,Y
            sta $4400,Y
            sta $4500,Y
            iny
            bne FRMTCLP
; header loop            
            ldy #$2A
FRMTHLP     lda RDHEAD,Y
            sta $4000,Y
            dey
            bpl FRMTHLP
; calc banks for ramdisk            
            lda BNKCNT
            sec
            sbc SPARBNKS
            tax
            stx RDBNKCNT
; set size loop
            ldy #$00
FRMTSLP     lda RDSIZE-4,X
            sta $400B,Y       ; total number of sectors on the disk
            inx               ; and number of free sectors on the disk
            iny
            cpy #$04
            bne FRMTSLP
; set free sector VTOC             
            lda RDBNKCNT
            lsr
            lsr
            tax
FRMTVTOCLP  jsr L34AB
            lda L34AF+1
            clc
            adc #$40
            sta L34AF+1
            lda L34AF+2
            adc #$00
            sta L34AF+2
            dex
            bne FRMTVTOCLP
; set sector numbers in boot sector and correct VTOC
            ldx RDBNKCNT
            lda RDMAPSZ-4,X
            sta $400F     	; number of bit map sectors used on the disk
            clc
            adc #$02
            sta $4009     	; first sector map of the MAIN directory
; correct free sector map
            cpx #$20		; more then $20 banks (512k) adjust tow bytes
            bcs FMTMT512
            lda RDMAPSZ-3,X 
            sta $4080
            jmp FMTLT512
FMTMT512    lda #$00
            sta $4080
            lda RDMAPSZ-3,X 
            sta $4081
FMTLT512
; calc adress for VTOC            
            lda RDMAPSZ-2,X
            sta BUFRLO
            lda RDMAPSZ-1,X
            sta BUFRHI   
            clc
            ldy #$04
            lda $4009
            adc #$01
            sta (BUFRLO),Y
; create MAIN directory
            ldx #$00
            ldy #$80
L349B       lda RDMAIN,X
            sta (BUFRLO),Y
            inx
            iny
            cpx #$11
            bne L349B
; restore PORTB
            pla
            sta PORTB
; enable interrupts
            lda #$E0
            sta NMIEN
            cli
            rts
; set VTOC            
L34AB       ldy #$00
            lda #$FF
L34AF       sta $4080,Y
            iny
            cpy #$40
            bne L34AF
            rts

;                 total, free number of sectors
RDSIZE      .word $0200,$01FB ; 64k
            .word $0400,$03FB ; 128k
            .word $0600,$05FA ; 192k
            .word $0800,$07FA ; 256k
            .word $0A00,$09F9 ; 320k
            .word $0C00,$0BF9 ; 384k
            .word $0E00,$0DF8 ; 448k
            .word $1000,$0ff8 ; 512k
; extension for 1088k
            .word $0000,$0000 ; dummy
            .word $0000,$0000 ; dummy
            .word $0000,$0000 ; dummy
            .word $0000,$0000 ; dummy
            .word $0000,$0000 ; dummy
            .word $0000,$0000 ; dummy
            .word $1E00,$1DF4 ; 1024-64=960k reserve 4 banks (130XE)
            .word $2000,$1ff4 ; 1024k

RDMAPSZ     .byte $01,$07       ; 64k
            .word $4100
            
            .byte $01,$07       ; 128k
            .word $4100
            
            .byte $02,$03       ; 192k
            .word $4180
            
            .byte $02,$03       ; 256k
            .word $4180
            
            .byte $03,$01       ; 320k
            .word $4200
            
            .byte $03,$01       ; 384k
            .word $4200
            
            .byte $04,$00       ; 448k
            .word $4280
            
            .byte $04,$00       ; 512k
            .word $4280

; extension for 1088k
            .byte $00,$00       ; dummy
            .word $0000

            .byte $00,$00       ; dummy
            .word $000

            .byte $00,$00       ; dummy
            .word $0000

            .byte $00,$00       ; dummy
            .word $0000

            .byte $00,$00       ; dummy
            .word $0000

            .byte $00,$00       ; dummy
            .word $0000

            .byte $08,$0F       ; 1024-64=960k reserve 4 banks (130XE)
            .word $4480

            .byte $08,$0F       ; 1024k 
            .word $4480

RDMAIN      .byte $08			; ???
			.byte $00,$00		; Sector number of the parent directory, $00 this is root
			.byte $11,$00,$00	; Length of the directory in bytes
            .byte 'MAIN       '	; Name of the directory padded with spaces (8 bytes)

RDHEAD      .byte $00			; Usually 0. Some formatting tools put a $53 (='S) for SD here
			.byte $03			; Number of sectors to boot
			.byte $00,$07		; Address where the boot sectors are loaded to
			.byte $E0,$07		; This address is copied to DOSINI. 2 bytes
			.byte $4C,$80,$30	; execution to code beginning jmp $3080
            .byte $03,$00		; Sector number of the first sector map of the MAIN directory
            .byte $00,$04		; Total number of sectors on the disk
            .byte $FB,$03		; Number of free sectors on the disk
            .byte $01			; Number of bit map sectors on the disk
            .byte $02,$00		; Sector number of the first bit map sector
            .byte $20,$00		; Sector number to begin the file data sector allocation search
            .byte $00,$00		; Sector number to begin the directory data sector allocation search
            .byte 'RAMDISKU'	; Disk volume name, 8 chars
            .byte $00			; Number of tracks on the disk, $00 for ramdisk or HD
            .byte $80			; Size of the sectors on this disk, $00 = 256 Byte
            .byte $22			; File system revision number of the disk format
            .byte $00,$00,$00,$00,$00; reserved - no known usage
            .byte $00			; Volume sequence number
            .byte $16			; Volume random number
            .byte $00,$00		; Sector number of the first sector map of the file to be loaded when the disk is booted
            .byte $00			; This is the write LOCK flag, $FF locked, $00 unlocked


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
REAL003     lda #<BNKSAVBUF
            sta MEMLO
REAH003     lda #>BNKSAVBUF
            sta MEMLO+1
            rts
; new DOSVEC for RAMDISK device
RAMDSIO     lda DDEVIC
            cmp #$31
            bne JMPSIO
            lda DUNIT
REAA004     cmp DRVNUM
            beq L358A
JMPSIO      jmp $0000
L358A       ldx PORTB
            sei
            lda #$00
            sta NMIEN
            lda DBUFLO
            sta BFENLO
            lda DBUFHI
            sta BFENHI
            lda DCOMND
            
            cmp #$53            ; command STATUS REQUEST 
            bne NEXT1
REAA009     lda L36BF
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
            
NEXT1       cmp #$4E            ; command RETURN CONFIGURATION
            bne NEXT2
            ldy #$0B            ; 12 bytes
RETCNFLOOP
REAA011     lda CONFBUF,Y
            sta (BFENLO),Y
            dey
            bpl RETCNFLOOP
            bmi JMPSIOEND
            
NEXT2       cmp #$4F            ; command SET CONFIGURATION
            bne NEXT3
            ldy #$07
            lda (BFENLO),Y
REAA012     sta L36BF
            ldy #$03
            lda (BFENLO),Y
REAA013     sta L36BB

JMPSIOEND
REAA014     jmp RDSIOEND

NEXT3       cmp #$21            ; command FORMAT DISK
            bne NEXT4
SIOFRMT     ldy #$00
            lda #$FF
            sta (BFENLO),Y
            iny
            sta (BFENLO),Y
            bne JMPSIOEND
            
NEXT4       cmp #$22            ; command FORMAT DISK ENHANCED
            bne NEXT5
            lda #$1A
REAA015     sta L36BB
            lda #$80
REAA016     sta L36BF
            bne SIOFRMT
            
NEXT5       cmp #$52            ; command GET SECTOR
            beq PUTGETSEC
            cmp #$57            ; command PUT SECTOR WITH VERIFY
            beq PUTGETSEC
            cmp #$50            ; command PUT SECTOR
            beq PUTGETSEC
REAA020     jmp RDSIOEND+3

PUTGETSEC   lda #$00
            sta BUFRLO
            lda DAUX1
            sec
            sbc #$01
            sta BUFRHI
            lda DAUX2
            sbc #$00
            asl BUFRHI
            rol
            bit DBYTLO
            bmi L3631
REAA017     asl L36BF
            asl BUFRHI
            rol
L3631       pha
            lda BUFRHI
            lsr
            lsr
            ror BUFRLO
            ora #$40
            sta BUFRHI
            
            lda DCOMND
            cmp #$52
            beq L3656
            
            ldy #$00
L364B       lda (BFENLO),Y
REAA005     sta BUFFERXX1,Y
            iny
            cpy DBYTLO
            bne L364B
; check bank number
L3656       pla
            clc
REAA021     adc SPARBNKS
REAA018     cmp BNKCNT
            bcs RDSIOEND+3
; switch bank            
            tay
REAA019     lda BNKSWTMSK,Y
            sta PORTB
            
            ldy #$00
            lda DCOMND
            cmp #$52
            bne L369B
            
L367B       lda (BUFRLO),Y
REAA006     sta BUFFERXX1,Y
            iny
            cpy DBYTLO
            bne L367B
; restore bank
            stx PORTB
             
            ldy #$00
L368E
REAA008     lda BUFFERXX1,Y
            sta (BFENLO),Y
            iny
            cpy DBYTLO
            bne L368E
            beq RDSIOEND
L369B
REAA007     lda BUFFERXX1,Y
            sta (BUFRLO),Y
            iny
            cpy DBYTLO
            bne L369B
            
RDSIOEND    ldy #$01
            bit $8BA0 ; $2c, ldy #$8b
            stx PORTB
            lda #$E0
            sta NMIEN
            cli
            tya
            rts
            
BNKCNT      .byte $00
SPARBNKS    .byte $00

; drive configuration buffer
CONFBUF     .byte $28,$01,$12
L36BB       .byte $00,$00,$00,$00
L36BF       .byte $80,$FF,$00,$00,$00

DRVNUM      .byte $01

BNKSWTMSK   .byte $60,$64,$68,$6C,$20,$24,$28,$2C
            .byte $40,$44,$48,$4C,$00,$04,$08,$0C
            .byte $62,$66,$6A,$6E,$22,$26,$2A,$2E
            .byte $42,$46,$4A,$4E,$02,$06,$0A,$0E
; extension for 1088k
            .byte $E0,$E4,$E8,$EC,$A0,$A4,$A8,$AC
            .byte $C0,$C4,$C8,$CC,$80,$84,$88,$8C
            .byte $E2,$E6,$EA,$EE,$A2,$A6,$AA,$AE
            .byte $C2,$C6,$CA,$CE,$82,$86,$8A,$8E

; $100 Bytes
BUFFERXX1

;            org $37E6
REAEND      = BUFFERXX1 + $100
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; END OF REALLOC BLOCK
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; $20 Bytes extension $40
BNKSAVBUF   = REAEND

; $20 bytes extension $40
;            org $3806
BNKSAVBUF2  = BNKSAVBUF + $40

 
;           org $3826
            org BNKSAVBUF2 + $40
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
            .word REAA017+1 ;$362C
            .word REAA018+1 ;$365C
            .word REAA019+1 ;$3667
            .word REAA020+1 ;$3610
            .word REAA021+1 ;$3659
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
            .byte <BNKSAVBUF ;$E6
            
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

; $01 byte
REALOOPCNT  ;= $392B
READIFLO   = REALOOPCNT+1
READIFHI   = READIFLO+1

;
            org $0580
; realloc code pointer
REATABADR   .word REATAB
REASRCADR   .word REABEGIN
READSTADR   .word $FFFF
; copy code pointer
CPYFROMADR  .word REABEGIN
CPYLENGTH   .word REAEND-REABEGIN ;$027C
CPYTOADR    .word $FFFF

            .word $0000

         
