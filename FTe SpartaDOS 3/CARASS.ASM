; Start Assembler Editor (8k, $1ff0)

; OS equ
SDMCTL  = $022f
GINTLK  = $3fa
CARTCK  = $3eb

TRIG3   = $d013
DMACTL  = $d400 
NMIEN   = $d40e

WARMST  = $e474

; TC equ
TCMOSL     = $d5a6    ; mode ($00-$3d,$01)
TCMOSL.8K  = $01      ; 8k banks at $A000
TCMOFR     = $d5a7    ; flash/RAM mode (0-15,0)

TCPBRL = $d5a0    ; register low byte (0-255,0)
TCPBRH = $d5a1    ; register high byte (0-63,0)
TCPBEN = $d5a2    ; enable (0=dis-1=en,1)

TCSBRL = $d5a3    ; register low byte (0-255,0)
TCSBRH = $d5a4    ; register high byte (0-63,0)
TCSBEN = $d5a5    ; enable (0=dis-1=en,0)

; Main
        org $2000

        lda #$00        ; switch off DMA
        sta SDMCTL
        sta DMACTL

        sei             ; mask all interrupts
        lda #$00
        sta NMIEN

        lda #$f0
        sta TCPBRL
        lda #$1f        ; set P bank 
        sta TCPBRH
        
        lda #$00
        sta TCSBRL      ; set S bank 
        sta TCSBRH
        sta TCSBEN      ; disable S

        sta TCMOFR      ; cfg flash r/o
        lda #TCMOSL.8K  ; set mode 8k
        sta TCMOSL

        lda #$01        ; set cartridge flag
        sta TRIG3
        sta GINTLK
        
        lda #$00        ; set cart check sum
        tax
        clc
_ccloop adc $bff0,x
        inx
        bne _ccloop
        sta CARTCK

        pla             ; clear return adr from stack 
        pla
        
        jmp WARMST      ; warm start
        