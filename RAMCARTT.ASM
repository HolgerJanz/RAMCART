;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 
; Test Driver - The!Ramdisk for The!Cart

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; The!Cart Equates
;

TCMOSL      = $d5a6     ; mode ($00-$3d,$01)
; how to figure out that The!Cart is not active?
; If the address is not used then the XL returns $ff but
; the XE (and old 800) return $d5 (high byte of address,
; the value of the last bus cycle)
TCMOSL.XLLOCK  = $ff    ; config lock or not present
TCMOSL.XELOCK  = $d5    ; config lock or not present

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Equates used to call CIO
;

XIO.FMT = 254   ; Format command
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
IOCB.AUX1   = IOCB+10    ; Auxilliary byte 1
IOCB.AUX2   = IOCB+11    ; Auxilliary byte 2

CIOV = $E456   ; the classic location

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; OS Equates
;

RAMIO    = $1481     ; address of FMS RAMIO
DISKBUF  = $0304     ; buffer address for read/write
DCBSEC   = $030a     ; DAUX1,DAUX2 containing sector number

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 
; RAMIO test switching with The!Cart
;

        org $4000 
start                    ; Start of code
; check for The!Cart
        lda TCMOSL
        cmp #TCMOSL.XLLOCK
        beq start.locked
        cmp #TCMOSL.XELOCK
        bne start.ok
start.locked
        ldx #<start.lock
        ldy #>start.lock
        lda #start.lock.end-start.lock
        jsr print        
        rts
        
start.ok
; let's go
        ldx #<start.letsgo
        ldy #>start.letsgo
        lda #start.letsgo.end-start.letsgo
        jsr print                

; write message
        ldx #<start.write
        ldy #>start.write
        lda #start.write.end-start.write
        jsr print        

; set buffer address for test frame
        lda #<RAMIO.SECBUF  ; set zero page address
        sta RAMIO.SECPTR    ; to sector buffer
        lda #>RAMIO.SECBUF
        sta RAMIO.SECPTR+1

; set buffer address for RAMIO
        lda #<RAMIO.SECBUF  ; buffer address for read/write
        sta DISKBUF         ; to sector buffer
        lda #>RAMIO.SECBUF
        sta DISKBUF+1
        
; init write loop message
        lda #$00            ; start sector is 0
        sta DCBSEC
        sta DCBSEC+1

        ldx #<start.counter.init ; init msg
        ldy #>start.counter.init
        lda #start.counter.init.end-start.counter.init
        jsr print        

; ************************************************************
start.write.loop
; print sector number
        jsr print.sector
; generate test data for sector
        jsr testdata.generate
; call RAMIO to write sector to RAM disk
        sec
        jsr RAMIO
; increment sector count
        clc
        lda #$01
        adc DCBSEC
        sta DCBSEC
        lda #$00 
        adc DCBSEC+1
        sta DCBSEC+1

; check sector count
        lda #$00
        cmp DCBSEC
        bne start.write.loop
        lda #$10
        cmp DCBSEC+1
        bne start.write.loop
; ************************************************************

; write lf
        ldx #<start.counter.lf
        ldy #>start.counter.lf
        lda #start.counter.lf.end-start.counter.lf
        jsr print        
;*
;*
; ************************************************************

; end of write, start read check

; ************************************************************
;*
;*

; check message
        ldx #<start.check
        ldy #>start.check
        lda #start.check.end-start.check
        jsr print        

; init check loop message
        lda #$00            ; start sector is 0
        sta DCBSEC
        sta DCBSEC+1

        ldx #<start.counter.init ; init msg
        ldy #>start.counter.init
        lda #start.counter.init.end-start.counter.init
        jsr print        

; ************************************************************
start.check.loop
; print sector number
        jsr print.sector
; call RAMIO to read sector from RAM disk
        clc
        jsr RAMIO
; check test data for sector
        jsr testdata.check

; increment sector count
        clc
        lda #$01
        adc DCBSEC
        sta DCBSEC
        lda #$00 
        adc DCBSEC+1
        sta DCBSEC+1

; check sector count
        lda #$00
        cmp DCBSEC
        bne start.check.loop
        lda #$10
        cmp DCBSEC+1
        bne start.check.loop
; ************************************************************

; write lf
        ldx #<start.counter.lf
        ldy #>start.counter.lf
        lda #start.counter.lf.end-start.counter.lf
        jsr print        

        rts

start.lock
        .byte 'THE!CART NOT FOUND'
        .byte $9b
start.lock.end

start.letsgo
        .byte 'THE!TEST FOR THE!RAMDISK'
        .byte $9b
start.letsgo.end

start.write
        .byte 'WRITE'
        .byte $9b
start.write.end

start.check
        .byte 'READ AND CHECK'
        .byte $9b
start.check.end

start.counter.init
        .byte 'SECTOR ____'
start.counter.init.end
start.counter.lf
        .byte $9b
start.counter.lf.end

start.error
        .byte ' ERROR DUMP:'
        .byte $9b
start.error.end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 
; Generate Test Date for Sector in 
;    IN    DCBSEC sector number
;        RAMIO.SECPTR buffer to sector buffer
;

testdata.generate
        ldy #$00            ; set begin byte
        lda #$BB
        sta (RAMIO.SECPTR),y
        
        iny                 ; set high sec num (once)
        lda DCBSEC+1
        sta (RAMIO.SECPTR),y

        iny                 ; set fill bytes (low sec num)
        lda DCBSEC
testdata.generate.loop
        sta (RAMIO.SECPTR),y
        iny
        cpy #$7f
        bne testdata.generate.loop
        
        lda #$EE            ; set end byte
        sta (RAMIO.SECPTR),y

        rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 
; Check Test Date for Sector in 
;    IN    DCBSEC sector number
;        RAMIO.SECPTR buffer to sector buffer
;

testdata.check
        ldy #$00            ; check begin byte
        lda (RAMIO.SECPTR),y
        cmp #$BB
        bne testdata.check.error
        
        iny                 ; check high byte (sec num)
        lda (RAMIO.SECPTR),y
        cmp DCBSEC+1
        bne testdata.check.error
        
        iny                 ; check fill bytes (low sec num)
testdata.check.loop
        lda (RAMIO.SECPTR),y
        cmp DCBSEC
        bne testdata.check.error
        iny
        cpy #$7f
        bne testdata.check.loop
        
        lda (RAMIO.SECPTR),y ; check end byte
        cmp #$EE
        bne testdata.check.error

        rts

testdata.check.error
; write error
        ldx #<start.error
        ldy #>start.error
        lda #start.error.end-start.error
        jsr print        
; write sector data
        jsr print.data
; init next sector check msg
        ldx #<start.counter.init
        ldy #>start.counter.init
        lda #start.counter.init.end-start.counter.init
        jsr print        

        rts


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 
; Print Data
;

print.data
        lda #$00
        sta print.data.loop.cnt

print.data.loop
; get byte, conv ,and push
        ldy print.data.loop.cnt
        lda (RAMIO.SECPTR),y
        jsr convha
        txa    ;save chars on stack
        pha
        tya
        pha
; set text and print line
        lda print.data.loop.cnt
        and #$0f
        asl
        tax
        pla
        sta print.data.line,x
        inx
        pla
        sta print.data.line,x
        cpx #$1f
        bne print.data.loop.next
        ldx #<print.data.line
        ldy #>print.data.line
        lda #print.data.line.end-print.data.line
        jsr print
print.data.loop.next
; increment and check
        inc print.data.loop.cnt
        lda #$80
        cmp print.data.loop.cnt
        bne print.data.loop
        
        rts

print.data.loop.cnt
        .byte $00        
print.data.line
:16     .byte '##'
        .byte $9b
print.data.line.end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 
; Print Sector
;

print.sector
        lda DCBSEC+1    ;get high byte
        jsr convha
        stx print.sector.sec.num
        sty print.sector.sec.num+1

        lda DCBSEC      ;get low byte
        jsr convha
        stx print.sector.sec.num+2
        sty print.sector.sec.num+3

        ldx #<print.sector.sec ; print
        ldy #>print.sector.sec
        lda #print.sector.sec.end-print.sector.sec
        jsr print        

        rts

print.sector.sec
:4      .byte $1e
print.sector.sec.num
        .byte 'XXXX'
print.sector.sec.end

        
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
; Data for RAMIO 
RAMIO.SECPTR = $cb      ; address to buffer
RAMIO.SECBUF            ; input read/write buffer
:$80    .byte $ee    

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 
; Run address
        run start        ;Define run address
