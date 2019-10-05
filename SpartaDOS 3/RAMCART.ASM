;
; RAMDISK for SpartaDOS 3 
;
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

; macros

; set bank: number of bank in X, uses A
M_bank_set  .macro
            lda BNKSWTMSK,X
            eor PORTB
            and #$7E
            eor PORTB
            sta PORTB
;            lda PORTB
;            and #$01
;            ora BNKSWTMSK,X
;            sta PORTB
            .endm

; saves bank register: pushes bank register on stack
M_bank_push .macro
            lda PORTB
            pha
            .endm

; restores bank register from stack: pops from stack
M_bank_pop  .macro
            pla
            sta PORTB
            .endm
 
;
; Start of code
;
            org $3000

; save PIA PORT B
            M_bank_push
            
; switch off interrupts
            lda #$00
            sta SDMCTL
            jsr WAITSYNC
            
; try to save and write banks            
            ldx #$1F
BNKSAVWRT   M_bank_set
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
            M_bank_set
            lda BNKSWTMSK,X
            cmp $7000
            bne BNKSTOP
            lda BNKSWTMSK,X
            asl
            cmp $7001
            bne BNKSTOP
            cpx #$1F
            bne BNKCHK
            inx
BNKSTOP     stx BNKCNT

; restore banks
            ldx #$00
BNKRESTR    M_bank_set
            lda BNKSAVBUF,X
            sta $7000
            lda BNKSAVBUF2,X
            sta $7001
            inx
            cpx #$20
            bne BNKRESTR

; restore PIA PORT B
            M_bank_pop

; enable interrupts
            lda #$22
            sta SDMCTL
            jsr WAITSYNC

; info message
            jsr PRINT
            .byte 'RAMDISK 512k 2019-10-05 12:33',$9B,$FF

; check bank count
            ldx BNKCNT
            cpx #$20
            beq RAMDISKINI

; no banks            
            jsr PRINT
            .byte 'Error - No 512k Extende RAM',$9B,$FF
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
PRSPARNXT   cmp #'N'         ; format ?
            bne PARAMERR
; check format at startup to preserve existing RAM disk            
            inc CHKFRMT
            jmp PRSPARLOOP
PARAMERR    jsr PRINT
            .byte 'Error - Parameter Error use Dx: [/N]',$9B,$FF
            rts

; set jsr to original DOSINI
PRSPAREND   lda DOSINI
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

; wait for sync            
WAITSYNC    lda RTCLOK+2
WAITLOOP    cmp RTCLOK+2
            beq WAITLOOP
            rts
            
; format ramdisk
FRMTRD      jsr PRINT
            .byte '  RAM Disk Formatted',$9B,$FF


;            lda PORTB
;            pha
            M_bank_push
            
;            and #$FD
;            eor BNKSWTMSK
;            and PORTBMASK
;            eor PORTB
;            sta PORTB
            ldx #$10
            M_bank_set

; clear loop
            lda #$00
            tay
FRMTCLP     sta $4000,Y
            sta $4100,Y
            sta $4200,Y
            sta $4300,Y
            iny
            bne FRMTCLP
; header loop            
            ldy #$2A
FRMTHLP     lda RDHEAD,Y
            sta $4000,Y
            dey
            bpl FRMTHLP
; set free sector VTOC             
            lda BNKCNT
            lsr
            lsr
            tax
FRMTVTOCLP  jsr FRMTSETVTOC
            lda FRMTVTOCIT+1
            clc
            adc #$40
            sta FRMTVTOCIT+1
            lda FRMTVTOCIT+2
            adc #$00
            sta FRMTVTOCIT+2
            dex
            bne FRMTVTOCLP
 ; set map sector
            lda #$04 
            sta $400F     ; number of bit map sectors used on the disk
            clc
            adc #$02
            sta $4009     ; first sector map of the MAIN directory
            lda #$00 
            sta $4080
            lda #$80      ; low address of MAIN sector map
            sta BUFRLO
            lda #$42      ; high address of MAIN sector map
            sta BUFRHI   
            clc
            ldy #$04
            lda $4009
            adc #$01
            sta (BUFRLO),Y
; set MAIN sector map            
            ldx #$00
            ldy #$80
L349B       lda RDMAIN,X
            sta (BUFRLO),Y
            inx
            iny
            cpx #$11
            bne L349B
; restore PORTB
;            pla
;            sta PORTB
            M_bank_pop
            rts
            
; set VTOC            
FRMTSETVTOC ldy #$00
            lda #$FF
FRMTVTOCIT  sta $4080,Y
            iny
            cpy #$40
            bne FRMTVTOCIT
            rts

RDHEAD      .byte $00,$03,$00,$07,$E0,$07,$4C,$80
            .byte $30,$03,$00 ;original $00,$04,$FB,$03
            .word $1000,$0ff8 ; 512k
            .byte $01, $02,$00,$20,$00,$00,$00
            .byte 'RAMD512K'
            .byte $00,$80,$22,$00,$00,$00,$00,$00
            .byte $00,$16,$00,$00,$00

RDMAIN      .byte $08,$00,$00,$11,$00,$00
            .byte 'MAIN       '


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
L358A       ldx PORTB           ; save PORTB
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
REAA020     jmp RDSIOEND+3      ; error NAK, command not supported

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
            
            txa                 ; OS off ???
            and #$FE
            sta PORTB
            
            lda DCOMND
            cmp #$52
            beq L3656           ; is PUT
            
            ldy #$00
L364B       lda (BFENLO),Y
REAA005     sta BUFFERXX1,Y
            iny
            cpy DBYTLO
            bne L364B
            
L3656       pla                 ; check bank number
REAA018     cmp BNKCNT
            bcs RDSIOEND+3      ; error NAK
            tay
            
            lda PORTB           ; set bank
            and #$FD
REAA019     eor BNKSWTMSK,Y
;REAA022     and PORTBMASK
            and #$7E
            eor PORTB
            sta PORTB
            
            ldy #$00
            lda DCOMND
            cmp #$52
            bne L369B           ; is PUT
L367B       lda (BUFRLO),Y
REAA006     sta BUFFERXX1,Y
            iny
            cpy DBYTLO
            bne L367B
            
            txa                 ; OS off ???
            and #$FE
            sta PORTB

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
            bit $8BA0           ; $2c, ldy #$8b; bank/sector number error #139 NAK

            stx PORTB           ; restrore PORTB

            lda #$E0
            sta NMIEN
            cli
            tya
            rts
            
BNKCNT      .byte $00

; drive configuration buffer
CONFBUF     .byte $28,$01,$12
L36BB       .byte $00,$00,$00,$00
L36BF       .byte $80,$FF,$00,$00,$00

DRVNUM      .byte $01
BNKSWTMSK   .byte $60,$64,$68,$6C,$20,$24,$28,$2C
            .byte $40,$44,$48,$4C,$00,$04,$08,$0C
            .byte $62,$66,$6A,$6E,$22,$26,$2A,$2E
            .byte $42,$46,$4A,$4E,$02,$06,$0A,$0E
;PORTBMASK   .byte $7E

; $100 Bytes
BUFFERXX1

;            org $37E6
REAEND      = BUFFERXX1 + $100
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; END OF REALLOC BLOCK
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; $20 Bytes
BNKSAVBUF   = REAEND

; $20 bytes
;            org $3806
BNKSAVBUF2  = BNKSAVBUF + $20

 
;           org $3826
            org BNKSAVBUF2 + $20
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
;            .word REAA022+1 ;$366A
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


         
