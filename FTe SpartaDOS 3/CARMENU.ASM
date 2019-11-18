; Start The!Cart Menu

        org $2000

        inc $42         ; begin critical

        lda #$00
        sta $09         ; set no boot

        lda #$01
        sta $244        ; reboot

        lda #$00
        sta $d5a0
        lda #$00        ; set P bank 0
        sta $d5a1
        
        lda #$00
        sta $d5a3       ; set S bank 0
        sta $d5a4
        sta $d5a5       ; disable S
        sta $d5a7       ; cfg flash r/o

        lda #$01        ; set mode 8k
        sta $d5a6
                
        jmp $e477       ; cold start
        