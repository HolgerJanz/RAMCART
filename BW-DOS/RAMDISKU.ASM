;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; RAMDISK ULTIMATE for SpartaDOS 3 for tfhh SRAM512k and U1MB
;   COMPY and RAMBO up to 1024k
;   by hjx (x) 2020
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
CRITIC      = $0042
ZBNKSWTMSK  = $00D0
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
DSTATS		= $0303
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
;        PORTB $D301 XE
;        
;        0 - OS ROM on=1 off=0
;        1 - BASIC  on=0 off=1
;        2 - Bank-Switch
;        3 - Bank-Switch
;        4 - CPU-Switch   off=1 on=0
;        5 - ANTIC-Switch off=1 on=0
;        6 - unsued
;        7 - Self-Test on=0(if 0 is on) off=1
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Start of code
;
            org $3000
            
; memory addresses to check for alias of main memory
RB256TEST1  .byte $00 
RB256TEST2  .byte $00

; bit mask kind Rambo1 ($00), Rambo2 ($01), or Compy ($FF)
USEDMASK    .byte $FF
            
start
            jsr PRINT
            .byte 'Ramdisk Ultimate vers69 hjx',$9B,$FF
       
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; determine extended memory
;
            lda #<BNKSWTMSK             ; check Compy
            sta ZBNKSWTMSK
            lda #>BNKSWTMSK
            sta ZBNKSWTMSK+1
            jsr CHKBNKS
            stx BNKCNT

            lda #<BNKSWTMSKR1           ; check Rambo1
            sta ZBNKSWTMSK
            lda #>BNKSWTMSKR1
            sta ZBNKSWTMSK+1
            jsr CHKBNKS
            cpx BNKCNT
            bmi check_r2
            beq check_r2
            lda #$00
            sta USEDMASK                ; used mask $00 Rambo1
            stx BNKCNT                  ; save higher cnt

check_r2    lda #<BNKSWTMSKR2           ; check Rambo2
            sta ZBNKSWTMSK
            lda #>BNKSWTMSKR2
            sta ZBNKSWTMSK+1
            jsr CHKBNKS
            cpx BNKCNT
            bmi check_r1
            beq check_r1
            lda #$01
            sta USEDMASK                ; used mask $01 Rambo2
            stx BNKCNT                  ; save higher cnt

            ldx #$00                    ; copy Rambo2 to mask
CPYR2M      lda BNKSWTMSKR2,X
            sta BNKSWTMSK,X
            inx
            cpx #$40  
            bne CPYR2M
            jmp start_rambo

check_r1
            bit USEDMASK
            bmi start_compy
            ldx #$00                    ; copy Rambo1 to mask
CPYR1M      lda BNKSWTMSKR1,X
            sta BNKSWTMSK,X
            inx
            cpx #$40  
            bne CPYR1M

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; write kind of extended memory
;            
start_rambo
            jsr PRINT
            .byte '  Found Rambo ',$FF
            jmp start_check

start_compy
            cpx #$04
            bcc start_check
            jsr PRINT
            .byte '  Found Compy ',$FF

start_check
; check bank count
            ldx BNKCNT
            cpx #$04
            bcc EXT_NO
            bne EXT_192
            jsr PRINT
            .byte '64k bits 23',$9B,$FF
            jmp EXT_END
; no banks            
EXT_NO      jsr PRINT
            .byte '  Error: No extended memory',$9B,$FF
            jmp PRNHLP
            
EXT_192     cpx #$0C
            beq EXT_256
            bcs EXT_320
            jsr PRINT
            .byte '128K bits 236',$9B,$FF
            jmp EXT_END

EXT_256     jsr PRINT
            .byte '192K bits 2365 w/main',$9B,$FF
            jmp EXT_END
            
EXT_320     cpx #$10
            bne EXT_576
            bit USEDMASK
            bmi CMP_320
            jsr PRINT
            .byte '256K bits 2365',$9B,$FF
            jmp EXT_END
CMP_320     jsr PRINT
            .byte '256K bits 2367',$9B,$FF
            jmp EXT_END

EXT_576     cpx #$20
            bne EXT_1088     
            bit USEDMASK
            bmi CMP_576
            bne RA2_576
            jsr PRINT
            .byte '512K bits 23651',$9B,$FF
            jmp EXT_END
RA2_576     jsr PRINT
            .byte '512K bits 23657',$9B,$FF
            jmp EXT_END
CMP_576     jsr PRINT
            .byte '512K bits 23671',$9B,$FF
            jmp EXT_END

EXT_1088    cpx #$40
            beq EXT_1088EQ
            jmp EXT_NO
EXT_1088EQ  bit USEDMASK
            bmi CMP_1088
            bne RA2_1088
            jsr PRINT
            .byte '1024K bits 236517',$9B,$FF
            jmp EXT_END
RA2_1088    jsr PRINT
            .byte '1024K bits 236571',$9B,$FF
            jmp EXT_END
CMP_1088    jsr PRINT
            .byte '1024K bits 236710',$9B,$FF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; parse parameter
;
EXT_END     ldy #SD_BUFOFF
            lda (DOSVEC),Y
            clc
            adc #SD_LBUF
            tay
            lda (DOSVEC),Y
            cmp #$9B
            beq ERRDRVNR
            jmp PRSPARM
; no parameter -> error
ERRDRVNR    jsr PRINT
            .byte '  Error: No drive number specified',$9B,$FF
PRNHLP
            jsr PRINT
            .byte '  Use: RAMDISKU Dx: [/EDF]',$9B
            .byte '    x - drive number for ramdisk',$9B
            .byte '    E - use 64K less extended memory',$9B
            .byte '    D - install ramdisk driver',$9B
            .byte '    F - format ramdisk',$9B,$FF
            rts
; jump for jsr to crunch name
CRNAME      jmp $FFFF

RDBNKCNT    .byte $00

; set crunch name address
PRSPARM     lda DOSVEC
            clc
            adc #SD_ZCRNAME
            sta CRNAME+1
            lda DOSVEC+1
            adc #$00
            sta CRNAME+2
; get drive number SD_COMFNAM starts alway with Dx:
            jsr CRNAME
            bne PARAMERR
            ldy #SD_COMFNAM+1
            lda (DOSVEC),Y
            and #$0F
            sta DRVNUM
; check options /EDF
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
; save 4 banks for 130XE compatibilty
            cmp #'E'
            bne PRSPARNXT1
            lda #$04
            sta SPARBNKS
            jmp PRSPARLOOP
; check install driver only
PRSPARNXT1  cmp #'D'
            bne PRSPARNXT2
            lda #$FF
            sta CHKPAROPT
            sta CHKINIDRV
            jmp PRSPARLOOP
; check format             
PRSPARNXT2  cmp #'F'
            bne PARAMERR
            lda #$FF
            sta CHKPAROPT
            sta CHKFRMT
            jmp PRSPARLOOP
PARAMERR    jsr PRINT
            .byte '  Error: Wrong parameter specified',$9B,$FF
            jmp PRNHLP

CHKPAROPT   .byte $00

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; check for spare banks
;
PRSPAREND
            lda SPARBNKS
            beq BNKCNTOK
            jsr PRINT
            .byte '  Use 64K less extended memory',$9B,$FF
            lda BNKCNT
            cmp #$04
            bne BNKCNTOK
            jsr PRINT
            .byte '  Error: No extra extended memory',$9B,$FF
            jmp PRNHLP
BNKCNTOK
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; check for init driver and format
;
; set format and ini by options
            bit CHKPAROPT
            bmi STRTINIFMT ; no options set default /DF
            lda #$FF
            sta CHKINIDRV
            sta CHKFRMT
STRTINIFMT
; install driver requested
            bit CHKINIDRV
            bpl NOINIDRV
            jsr INIDRV
NOINIDRV
; format if requested
            bit CHKPAROPT
            bmi NOPREFRMT
            jsr PREFRMT
NOPREFRMT
            bit CHKFRMT
            bpl NOFRMTRD
            jsr FRMTRD
NOFRMTRD
            rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Subroutine install driver
;
CHKINIDRV   .byte $00

INIDRV
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
; start realloc
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
; message
            jsr PRINT
            .byte '  Driver installed',$9B,$FF
            rts


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Subroutine preserve ramdisk
;
PREFRMT
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
; compare
            ldx #$16
CHKFRMTLOOP lda RDHEAD,X
            cmp $4000,X
            bne CHKNOPREFRMT
            inx
            cpx #$21
            bne CHKFRMTLOOP
; clear format flag
            lda #$00
            sta CHKFRMT
            jmp CHKPREFRMTEND
CHKNOPREFRMT
            lda #$FF
            sta CHKFRMT
CHKPREFRMTEND
; restore PORTB
            pla
            sta PORTB
; enable interrupts
            lda #$E0
            sta NMIEN
            cli
; set format flag
            rts
            
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Subroutine format ramdisk
;
CHKFRMT     .byte $00

FRMTRD
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
            sta $4600,Y
            iny
            bne FRMTCLP
; header loop            
            ldy #$2A
FRMTHLP     lda RDHEAD,Y
            sta $4000,Y
            dey
            bpl FRMTHLP
            lda #$60    ; write RTS to second boot sector
            sta $4080   ; see header jmp $3080
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
FRMTVTOCLP  jsr FILLHSEC
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
            lda RDBNKCNT
            tax
            sec
            sbc #$01
            lsr
            lsr
            lsr                 ; 8 banks per sector of sector map
            clc
            adc #$01            
            sta $400F           ; number of bit map sectors used on the disk
            clc
            adc #$04
            sta $4009           ; first sector map of the MAIN directory
; correct free sector map
            lda RDMAPSZ-4,X 
            sta $4180
            lda RDMAPSZ-3,X 
            sta $4181
; calc adress for VTOC            
            lda RDMAPSZ-2,X
            sta BUFRLO
            lda RDMAPSZ-1,X
            sta BUFRHI   
            ldy #$04
            lda $4009
            clc
            adc #$01
            sta (BUFRLO),Y
; create MAIN directory
            ldx #$00
            ldy #$80
L349B       lda RDMAIN,X
            sta (BUFRLO),Y
            inx
            iny
            cpx #$17
            bne L349B
; restore PORTB
            pla
            sta PORTB
; enable interrupts
            lda #$E0
            sta NMIEN
            cli
; write message
            jsr PRINT
            .byte '  Ramdisk formatted',$9B,$FF
            rts
; set VTOC            
FILLHSEC    ldy #$00
            lda #$FF
L34AF       sta $4180,Y
            iny
            cpy #$40
            bne L34AF
            rts
;
; data array for format ram disk
;
;                 total, free number of sectors
RDSIZE
            .word $0200,$01F9 ; 64k
            .word $0400,$03F9 ; 128k
            .word $0600,$05F8 ; 192k
            .word $0800,$07F8 ; 256k
            .word $0A00,$09F7 ; 320k
            .word $0C00,$0BF7 ; 384k
            .word $0E00,$0DF6 ; 448k
            .word $1000,$0ff6 ; 512k
; extension for 1088k
            .word $0000,$0000 ; dummy
            .word $0000,$0000 ; dummy
            .word $0000,$0000 ; dummy
            .word $0000,$0000 ; dummy
            .word $0000,$0000 ; dummy
            .word $0000,$0000 ; dummy
            .word $1E00,$1DF2 ; 1024-64=960k reserve 4 banks (130XE)
            .word $2000,$1ff2 ; 1024k

RDMAPSZ
            .byte $01,$FF       ; 64k
            .word $4200
            
            .byte $01,$FF       ; 128k
            .word $4200
            
            .byte $00,$FF       ; 192k
            .word $4280
            
            .byte $00,$FF       ; 256k
            .word $4280
            
            .byte $00,$7F       ; 320k
            .word $4300
            
            .byte $00,$7F       ; 384k
            .word $4300
            
            .byte $00,$3F       ; 448k
            .word $4380
            
            .byte $00,$3F       ; 512k
            .word $4380

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

            .byte $00,$03       ; 1024-64=960k reserve 4 banks (130XE)
            .word $4580

            .byte $00,$03       ; 1024k 
            .word $4580

RDMAIN
            .byte $28                   ; ???
            .byte $00,$00               ; Sector number of the parent directory, $00 this is root
            .byte $17,$00,$00           ; Length of the directory in bytes
            .byte 'MAIN       '         ; Name of the directory padded with spaces (8 bytes)
            .byte $0b,$07,$47           ; Date DD/MM/YY
            .byte $0b,$0b,$0b           ; Time HH:MM:SS

RDHEAD
            .byte $00                   ; Usually 0. Some formatting tools put a $53 (='S) for SD here
            .byte $03                   ; Number of sectors to boot
            .byte $00,$07               ; Address where the boot sectors are loaded to
            .byte $E0,$07               ; This address is copied to DOSINI. 2 bytes
            .byte $4C,$80,$30           ; execution to code beginning jmp $3080
            .byte $03,$00               ; Sector number of the first sector map of the MAIN directory
            .byte $00,$04               ; Total number of sectors on the disk
            .byte $F9,$03               ; Number of free sectors on the disk
            .byte $01                   ; Number of bit map sectors on the disk
            .byte $04,$00               ; Sector number of the first bit map sector
            .byte $20,$00               ; Sector number to begin the file data sector allocation search
            .byte $00,$00               ; Sector number to begin the directory data sector allocation search
            .byte 'RAMDISKU'            ; Disk volume name, 8 chars
            .byte $00                   ; Number of tracks on the disk, $00 for ramdisk or HD
            .byte $80                   ; Size of the sectors on this disk, $00 = 256 Byte
            .byte $22                   ; File system revision number of the disk format
            .byte $00,$00,$00,$00,$00   ; reserved - no known usage
            .byte $00                   ; Volume sequence number
            .byte $16                   ; Volume random number
            .byte $00,$00               ; Sector number of the first sector map of the file to be loaded when the disk is booted
            .byte $00                   ; This is the write LOCK flag, $FF locked, $00 unlocked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Subroutine check banks
;
CHKBNKS
; save PIA PORT B
            lda PORTB
            pha
; switch off interrupts
            lda SDMCTL
            sta SSDMCTL
            lda #$00
            sta SDMCTL
            jsr WAITSYNC
; switch off interrupts
            sei
            lda #$00
            sta NMIEN
; try to save and write banks            
            ldy #$3F
BNKSAVWRT   lda (ZBNKSWTMSK),Y
            sta PORTB
            lda $7000
            sta BNKSAVBUF,Y
            lda (ZBNKSWTMSK),Y
            sta $7000
            lda $7001
            sta BNKSAVBUF2,Y
            lda (ZBNKSWTMSK),Y
            asl
            sta $7001
            dey
            bpl BNKSAVWRT
; write to check memory aliases (RAMBO 256k)
            lda #$FF
            sta RB256TEST1
            lda #$FF
            sta RB256TEST2
; check banks
BNKCHK      iny
            lda (ZBNKSWTMSK),Y
            sta PORTB
            lda (ZBNKSWTMSK),Y
            cmp $7000
            bne BNKSTOP
            lda (ZBNKSWTMSK),Y
            asl
            cmp $7001
            bne BNKSTOP
            cpy #$3F
            bne BNKCHK
            iny
BNKSTOP     tya                 ; save bank count in X
            tax
; restore banks
            ldy #$00
BNKRESTR    lda (ZBNKSWTMSK),Y
            sta PORTB
            lda BNKSAVBUF,Y
            sta $7000
            lda BNKSAVBUF2,Y
            sta $7001
            iny
            cpy #$40
            bne BNKRESTR
; reset check memory aliases (RAMBO 256k)
            lda #$00
            sta RB256TEST1
            lda #$00
            sta RB256TEST2
; restore PIA PORT B
            pla
            sta PORTB
; enable interrupts
            lda #$E0
            sta NMIEN
            cli
; enable interrupts
            lda SSDMCTL
            sta SDMCTL
            jsr WAITSYNC
            rts
; wait for sync            
WAITSYNC    lda RTCLOK+2
WAITLOOP    cmp RTCLOK+2
            beq WAITLOOP
            rts            
SSDMCTL     .byte $00

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Bank masks Rambo 1 and 2
;
BNKSWTMSKR1
            .byte $E2,$E6,$EA,$EE       ; 1110:0010 1110:0110 1110:1010 1110:1110
            .byte $A2,$A6,$AA,$AE       ; 1010:0010 1010:0110 1010:1010 1010:1110
            .byte $C2,$C6,$CA,$CE       ; 1100:0010 1100:0110 1100:1010 1100:1110
            .byte $82,$86,$8A,$8E       ; 1000:0010 1000:0110 1000:1010 1000:1110
            .byte $E0,$E4,$E8,$EC       ; 1110:0000 1110:0100 1110:1000 1110:1100
            .byte $A0,$A4,$A8,$AC       ; 1010:0000 1010:0100 1010:1000 1010:1100
            .byte $C0,$C4,$C8,$CC       ; 1100:0000 1100:0100 1100:1000 1100:1100
            .byte $80,$84,$88,$8C       ; 1000:0000 1000:0100 1000:1000 1000:1100
; extension for 1088k
            .byte $62,$66,$6A,$6E       ; 0110:0010 0110:0110 0110:1010 0110:1110
            .byte $22,$26,$2A,$2E       ; 0010:0010 0010:0110 0010:1010 0010:1110
            .byte $42,$46,$4A,$4E       ; 0100:0010 0100:0110 0100:1010 0100:1110
            .byte $02,$06,$0A,$0E       ; 0000:0010 0000:0110 0000:1010 0000:1110
            .byte $60,$64,$68,$6C       ; 0110:0000 0110:0100 0110:1000 0110:1100
            .byte $20,$24,$28,$2C       ; 0010:0000 0010:0100 0010:1000 0010:1100
            .byte $40,$44,$48,$4C       ; 0100:0000 0100:0100 0100:1000 0100:1100
            .byte $00,$04,$08,$0C       ; 0000:0000 0000:0100 0000:1000 0000:1100

BNKSWTMSKR2
            .byte $E2,$E6,$EA,$EE       ; 1110:0010 1110:0110 1110:1010 1110:1110
            .byte $A2,$A6,$AA,$AE       ; 1010:0010 1010:0110 1010:1010 1010:1110
            .byte $C2,$C6,$CA,$CE       ; 1100:0010 1100:0110 1100:1010 1100:1110
            .byte $82,$86,$8A,$8E       ; 1000:0010 1000:0110 1000:1010 1000:1110
            .byte $62,$66,$6A,$6E       ; 0110:0010 0110:0110 0110:1010 0110:1110
            .byte $22,$26,$2A,$2E       ; 0010:0010 0010:0110 0010:1010 0010:1110
            .byte $42,$46,$4A,$4E       ; 0100:0010 0100:0110 0100:1010 0100:1110
            .byte $02,$06,$0A,$0E       ; 0000:0010 0000:0110 0000:1010 0000:1110
; extension for 1088k
            .byte $E0,$E4,$E8,$EC       ; 1110:0000 1110:0100 1110:1000 1110:1100
            .byte $A0,$A4,$A8,$AC       ; 1010:0000 1010:0100 1010:1000 1010:1100
            .byte $C0,$C4,$C8,$CC       ; 1100:0000 1100:0100 1100:1000 1100:1100
            .byte $80,$84,$88,$8C       ; 1000:0000 1000:0100 1000:1000 1000:1100
            .byte $60,$64,$68,$6C       ; 0110:0000 0110:0100 0110:1000 0110:1100
            .byte $20,$24,$28,$2C       ; 0010:0000 0010:0100 0010:1000 0010:1100
            .byte $40,$44,$48,$4C       ; 0100:0000 0100:0100 0100:1000 0100:1100
            .byte $00,$04,$08,$0C       ; 0000:0000 0000:0100 0000:1000 0000:1100

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; print subroutine            
;
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
;
; start of resident driver
;
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
;
; new DOSVEC for RAMDISK device
;
RAMDSIO     lda DDEVIC
            cmp #$31
            bne JMPSIO
            lda DUNIT
REAA004     cmp DRVNUM
            beq L358A
JMPSIO      jmp $0000
L358A       lda DBUFLO
            sta BFENLO
            lda DBUFHI
            sta BFENHI
            lda DCOMND
; command STATUS REQUEST
            cmp #$53 
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
REAA012     sta L36BF
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
REAA016     sta L36BF
            bne SIOFRMT
; command GET SECTOR
NEXT5       cmp #$52
            beq PUTGETSEC
; command PUT SECTOR WITH VERIFY
            cmp #$57
            beq PUTGETSEC
; command PUT SECTOR
            cmp #$50
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
            ldx PORTB
;            inc CRITIC
;            sei
;            lda #$00
;            sta NMIEN
     
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
;            lda #$E0
;            sta NMIEN
;            cli
;            dec CRITIC 
             
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
; restore bank
            stx PORTB
;            lda #$E0
;            sta NMIEN
;            cli
;            dec CRITIC 
            
RDSIOEND    ldy #$01
            bit $8BA0 ; $2c, ldy #$8b ; error #NAK
			sty DSTATS
            tya
            rts
            
BNKCNT      .byte $00
SPARBNKS    .byte $00

; drive configuration buffer
CONFBUF     .byte $28,$01,$12
L36BB       .byte $00,$00,$00,$00
L36BF       .byte $80,$FF,$00,$00,$00

DRVNUM      .byte $01

; Compy Shop
BNKSWTMSK
            .byte $E2,$E6,$EA,$EE ; 1110:0010 1110:0110 1110:1010 1110:1110
            .byte $A2,$A6,$AA,$AE ; 1010:0010 1010:0110 1010:1010 1010:1110
            .byte $62,$66,$6A,$6E ; 0110:0010 0110:0110 0110:1010 0110:1110 
            .byte $22,$26,$2A,$2E ; 0010:0010 0010:0110 0010:1010 0010:1110
            .byte $E0,$E4,$E8,$EC ; 1110:0000 1110:0100 1110:1000 1110:1100
            .byte $A0,$A4,$A8,$AC ; 1010:0000 1010:0100 1010:1000 1010:1100
            .byte $60,$64,$68,$6C ; 0110:0000 0110:0100 0110:1000 0110:1100
            .byte $20,$24,$28,$2C ; 0010:0000 0010:0100 0010:1000 0010:1100
; extension for 1088k
            .byte $E3,$E7,$EB,$EF ; 1110:0011 1110:0111 1110:1011 1110:1111
            .byte $A3,$A7,$AB,$AF ; 1010:0011 1010:0111 1010:1011 1010:1111
            .byte $63,$67,$6B,$6F ; 0110:0011 0110:0111 0110:1011 0110:1111 
            .byte $23,$27,$2B,$2F ; 0010:0011 0010:0111 0010:1011 0010:1111
            .byte $E1,$E5,$E9,$ED ; 1110:0001 1110:0101 1110:1001 1110:1101
            .byte $A1,$A5,$A9,$AD ; 1010:0001 1010:0101 1010:1001 1010:1101
            .byte $61,$65,$69,$6D ; 0110:0001 0110:0101 0110:1001 0110:1101
            .byte $21,$25,$29,$2D ; 0010:0001 0010:0101 0010:1001 0010:1101
 

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Realloc data arrays
; 
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
            
; realloc code pointer
REATABADR   .word REATAB
REASRCADR   .word REABEGIN
READSTADR   .word $FFFF

; copy code pointer
CPYFROMADR  .word REABEGIN
CPYLENGTH   .word REAEND-REABEGIN ;$027C
CPYTOADR    .word $FFFF

            .word $0000

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Subroutine realloc driver code
;
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
; loop variables
REALOOPCNT  .byte $00
READIFLO    .byte $00
READIFHI    .byte $00

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Segment for start address
;
            run start
         
