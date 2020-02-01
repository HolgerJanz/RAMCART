;
; OS EQUATES
;
RTCLOK   = $0012
CRITIC   = $42

SDMCTL   = $022F

DMACTL   = $D400
NMIEN    = $D40E

;
; IO EQUATES
;
CIOV        = $E456

IOCB0       = $0340
 
ICCOM       = $0002
ICBLL       = $0008
ICBLH       = $0009


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
TCMOSLOFF   = $00    ; off, cartridge disabled
TCMOSL8K    = $01    ; 8k banks at $A000
TCMOSLAM1MB = $03
TCMOSLFLEXI = $20    ; flexi mode, separate 8k banks at $A000 and $8000
TCMOSL16K   = $21    ; standard 16k cart at $8000-$BFFF

; how to figure out that The!Cart is not active?
; If the address is not used then the XL returns $ff but
; the XE (and old 800) return $d5 (high byte of address,
; the value of the last bus cycle)
TCMOSLXLLOCK  = $ff    ; config lock or not present
TCMOSLXELOCK  = $d5    ; config lock or not present

; Mode Flash/RAM Select
TCMOFR = $d5a7    ;flash/RAM mode (0-15,0)
; bit 0: primary bank write enable (0=readOnly, 1=write)
; bit 1: primary bank source (0=flash, 1=RAM)
; bit 2: secondary bank write enable (0=readOnly, 1=write)
; bit 3: secondary bank source (0=flash, 1=RAM)
TCMOFRFLASH = $00
TCMOFRPBFLW = $01    ; primary bank RAM
TCMOFRPBRAM = $03    ; primary bank RAM
TCMOFRSBRAM = $0C    ; secondary bank RAM

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
; wait for sync            
;
;waitsync    lda rtclok+2
;_waitloop   cmp rtclok+2
;            beq _waitloop
;            rts

;
; Set flash The!Cart register
;
setTCFLASH

        lda #TCMOSL8K
        sta TCMOSL
        
        lda #TCMOFRFLASH
        sta TCMOFR

        lda flashBL
        sta TCPBRL

        lda flashBH
        sta TCPBRH

        lda #$01
        sta TCPBEN

        rts

flashBL .byte $c0
flashBH .byte $3f
        

;
; Set RAM The!Cart register
;
setTCRAM

        lda #TCMOSL8K
        sta TCMOSL
        
        lda #TCMOFRPBRAM
        sta TCMOFR

        lda ramBANK
        sta TCPBRL

        lda #$00
        sta TCPBRH

        lda #$01
        sta TCPBEN

        rts

ramBank .byte $00



;
; Store The!Cart register
;
storeTCreg

        lda TCMOSL
        sta _tcmosl

        lda TCPBRL
        sta _tcpbrl

        lda TCPBRH
        sta _tcpbrh

        lda TCMOFR
        sta _tcmofr

        lda TCPBEN
        sta _tcpben

        sei                 ; disable interrupts

        lda #$00
        sta NMIEN
        
        rts

;
; Restore The!Cart register
;
restoreTCreg

        lda _tcmosl
        sta TCMOSL

        lda _tcpbrl
        sta TCPBRL

        lda _tcpbrh
        sta TCPBRH

        lda _tcmofr
        sta TCMOFR

        lda _tcpben
        sta TCPBEN

        lda #$e0
        sta NMIEN

        cli
        
        rts

_tcmosl .byte $00
_tcmofr .byte $00
_tcpbrl .byte $00
_tcpbrh .byte $00
_tcpben .byte $00
_sdmctl .byte $00

;
; Global Store The!Cart register
;
globalStoreTCreg

        lda TCMOSL
        sta _gtcmosl

        lda TCPBRL
        sta _gtcpbrl

        lda TCPBRH
        sta _gtcpbrh

        lda TCMOFR
        sta _gtcmofr

        lda TCPBEN
        sta _gtcpben

        lda SDMCTL          ; DMA control
        sta _gsdmctl

        inc CRITIC
        
        lda #$00
        sta SDMCTL
        sta DMACTL
        
        rts

;
; Restore The!Cart register
;
globalRestoreTCreg

        sei                 ; disable interrupts
        
        lda _gtcmosl
        sta TCMOSL

        lda _gtcpbrl
        sta TCPBRL

        lda _gtcpbrh
        sta TCPBRH

        lda _gtcmofr
        sta TCMOFR

        lda _gtcpben
        sta TCPBEN

        cli

        lda _gsdmctl         ; restore DMA control
        sta SDMCTL

        dec CRITIC
        
        rts

_gtcmosl .byte $00
_gtcmofr .byte $00
_gtcpbrl .byte $00
_gtcpbrh .byte $00
_gtcpben .byte $00
_gsdmctl .byte $00


;
; copy 8k from $A000 to $8000
;
copy8k_A24

        ldx #$00

_loopCopyA24
        lda $a000,x
        sta $4000,x

        lda $a100,x
        sta $4100,x

        lda $a200,x
        sta $4200,x

        lda $a300,x
        sta $4300,x

        lda $a400,x
        sta $4400,x

        lda $a500,x
        sta $4500,x

        lda $a600,x
        sta $4600,x

        lda $a700,x
        sta $4700,x

        lda $a800,x
        sta $4800,x

        lda $a900,x
        sta $4900,x

        lda $aa00,x
        sta $4a00,x

        lda $ab00,x
        sta $4b00,x

        lda $ac00,x
        sta $4c00,x

        lda $ad00,x
        sta $4d00,x

        lda $ae00,x
        sta $4e00,x

        lda $af00,x
        sta $4f00,x

        inx
        bne _loopCopyA24

        ldx #$00

_loopCopyB25
        lda $b000,x
        sta $5000,x

        lda $b100,x
        sta $5100,x

        lda $b200,x
        sta $5200,x

        lda $b300,x
        sta $5300,x

        lda $b400,x
        sta $5400,x

        lda $b500,x
        sta $5500,x

        lda $b600,x
        sta $5600,x

        lda $b700,x
        sta $5700,x

        lda $b800,x
        sta $5800,x

        lda $b900,x
        sta $5900,x

        lda $ba00,x
        sta $5a00,x

        lda $bb00,x
        sta $5b00,x

        lda $bc00,x
        sta $5c00,x

        lda $bd00,x
        sta $5d00,x

        lda $be00,x
        sta $5e00,x

        lda $bf00,x
        sta $5f00,x

        inx
        bne _loopCopyB25

        rts

;
; copy 8k from $8000 to $A000
;
copy8k_42A

        ldx #$00

_loopCopy42A
        lda $4000,x
        sta $a000,x

        lda $4100,x
        sta $a100,x

        lda $4200,x
        sta $a200,x

        lda $4300,x
        sta $a300,x

        lda $4400,x
        sta $a400,x

        lda $4500,x
        sta $a500,x

        lda $4600,x
        sta $a600,x

        lda $4700,x
        sta $a700,x

        lda $4800,x
        sta $a800,x

        lda $4900,x
        sta $a900,x

        lda $4a00,x
        sta $aa00,x

        lda $4b00,x
        sta $ab00,x

        lda $4c00,x
        sta $ac00,x

        lda $4d00,x
        sta $ad00,x

        lda $4e00,x
        sta $ae00,x

        lda $4f00,x
        sta $af00,x

        inx
        bne _loopCopy42A

        ldx #$00

_loopCopy52B
        lda $5000,x
        sta $b000,x

        lda $5100,x
        sta $b100,x

        lda $5200,x
        sta $b200,x

        lda $5300,x
        sta $b300,x

        lda $5400,x
        sta $b400,x

        lda $5500,x
        sta $b500,x

        lda $5600,x
        sta $b600,x

        lda $5700,x
        sta $b700,x

        lda $5800,x
        sta $b800,x

        lda $5900,x
        sta $b900,x

        lda $5a00,x
        sta $ba00,x

        lda $5b00,x
        sta $bb00,x

        lda $5c00,x
        sta $bc00,x

        lda $5d00,x
        sta $bd00,x

        lda $5e00,x
        sta $be00,x

        lda $5f00,x
        sta $bf00,x

        inx
        bne _loopCopy52B

        rts

; print subroutine            
print       pla
            sta printiter+1
            pla
            sta printiter+2
printloop   inc printiter+1
            bne printiter
            inc printiter+2
printiter   lda $ffff
            cmp #$ff
            beq printend
            jsr cioputchr
            jmp printloop
printend    lda printiter+2
            pha
            lda printiter+1
            pha
            rts
; call cio put char subroutine
cioputchr   ldx #$00
            stx iocb0+icbll
            stx iocb0+icblh
            ldy #$0b
            sty iocb0+iccom
            jmp ciov

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

