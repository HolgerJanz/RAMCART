;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 
; My DOS Patch - Ramdisk for The!Cart and MyDOS 4.55
;
; Patches for MyDOS 4.55 beta4
;

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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; OS Equates
;

NMIEN   = $d40e
RTCLOKL = $14
CRITIC  = $42

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
; Star Patch of DUP (DOS is patched at loading)
;

        org $5000 ; MyDOS DUP ends at $4439
START
; info message
        ldx #<msg.start
        ldy #>msg.start
        lda #msg.start.end-msg.start
        jsr print
; patch DUP
; set version extension (invers TC for The!Cart)
;        lda #$d4
;        sta PRNMENTC
;        lda #$c3
;        sta PRNMENTC+1
; finished
        rts        
        
; print to screen
print   ; print adr X,Y len A
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

msg.start
        .byte 'My!RAMDISK v42 '
        .byte 'PATCH MYDOS4.55beta4'
        .byte $9b
msg.start.end



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; MyDOS Equates
;

BUFR    = $32
CURFCB  = $2e
DBUFLO  = $0304
DAUX1   = $030a
DSTATS  = $0303

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Patch DUP
;;
;
;; patched routines of DUP
;PRNMENTC= $2b32 ; MyDOS menu
;CHKBANKS= $3724 ; check bank
;RAMDSU  = $37c2 ; ramdisk present ?
;CHKRDBN = $382c ; directly at the call of bank check
;GETSEQN = $38da ; get sequence number of banks
;DVNOQ   = $38f8 ; drive number question
;DVNOQ2  = $390e ; jump over page map manipulation
;GETDRV  = $391f ; get drive number
;
;; set version extension (invers TC for The!Cart)
;;        org PRNMENTC
;        .byte $d4,$c3
;
;; check banks, sets RDKLMT
;;        org CHKBANKS
;        lda TCMOSL
;        cmp #TCMOSL.XLLOCK
;        beq CHKB.NO
;        cmp #TCMOSL.XELOCK
;        bne CHKB.YE
;CHKB.NO lda #$00
;        sta RDKLMT
;        rts
;CHKB.YE lda #$20
;        sta RDKLMT
;        rts
;        
;; jump over question about Axlon or XE,
;; we have The!Card
;;        org RAMDSU
;        jmp CHKRDBN
;        
;; jump over sequence number input
;; sequence is clear (0-31) = 32 banks
;;        org GETSEQN
;        jmp DVNOQ
;; jump over map page manipulation,
;; there is no map page anymore
;;        org DVNOQ2
;        jmp GETDRV
;        
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Patch DOS
;

; patched routines of DOS
RDKIO   = $0c33
MAPAGE  = $0bba

; min $0bba because MAPAGE starts there but is not need,
; VALSEC original at $0bfa
        org MAPAGE+3        ; because of bcc VALSEC 
                            ; must not be out of range
VALSEC  asl
        tax                 ;Save RAMbank # in X*2
; set address of sector
        tya                 ;Sector # (lo)
        sec                 ; set Bit7
        ror                 ; save Bit0 in carry
        and #$bf            ; clear Bit6
        sta BUFR+1          ;  (lo)/2.
        lda #$00
        ror                 ;Odd sector uses
        sta BUFR            ;  top 1/2 page.
; set sector buffer address
        lda DBUFLO          ;USER BUFFER ADDRESS GOES HERE
        sta BUFR+2
        lda DBUFLO+1
        sta BUFR+3
; save the!cart registers
        plp                 ; pull carry
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
        php                 ; push carry again
; set critical mode
        lda #$01
        sta CRITIC          ; tell VBLANK this is critical!
        ldy RTCLOKL
SYNC    cpy RTCLOKL         ; got a VBLANK yet?
        beq SYNC            ; no
        sta NMIEN           ; disable VBI and DLI
        sei                 ; and disable IRQ's
; set new The!Cart mode, 30c
        lda #TCMOSL.16K     ; set 2x8k mode at $8000-$BFFF
        sta TCMOSL        
        lda #TCMOFR.PBRAM   ; set to RAM
        sta TCMOFR          ;
        stx TCPBRL          ; get bank number from x
; read or write sector
        ldy #$00
        plp                 ; pull carry 
        bcc RREADL          ;CY=0 IF READ
; write
RWRITL  lda (BUFR+2),Y
        sta (BUFR),Y
        iny 
        bpl RWRITL
        bmi RRWEND
; read
RREADL  lda (BUFR),Y
        sta (BUFR+2),Y
        iny 
        bpl RREADL
RRWEND
; restore The!Cart registers, part 1
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
; jump to The End
        jmp RIOX
; max $0c32

        org RDKIO
; keep original address for RDKIO
; ramdisk IO
; input: sector number in A(H),Y(L)
;        read/write    in C
        sty DAUX1 ;*** FOR FORMAT CODE ***
        cpy #$80
        rol 
        cmp #32
; keep RDKLMT stable,
; do not change from NRDKIO to RDKLMT
RDKLMT  = *-1       ;NUMBER OF 16K PAGES IN RAMDISK
        bcc VALSEC  ;CALCULATE MEM. ADDR.
        plp 
        ldy #139
        bmi RERROR
RIOX
; reset critical mode
        lda #$C0
        sta NMIEN   ;RE-ENABLE NMI
        ldy #$00
        sty CRITIC
        cli         ;ENABLE INTERRUPTS
; set return values
        iny         ;RETURN '1' IN Y-REG
RERROR  sty DSTATS  ;AND IN STATUS BYTE
        ldx CURFCB  ;RESTORE FCB ADDR
        rts         ;THEN EXIT

; max $0c5c

        run START