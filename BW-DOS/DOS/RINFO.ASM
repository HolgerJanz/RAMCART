;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Poke for SpartaDOS 3 by hjx

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Equates
;

; 
; CIO
; 
CIOV        = $E456
; CIOCB addresses
ICHID		= $0340
ICDNO		= $0341
ICCOM       = $0342
ICSTA		= $0343
ICBAL       = $0344
ICBAH       = $0345
ICPTL		= $0346
ICPTH		= $0347
ICBLL       = $0348
ICBLH       = $0349
ICAX1		= $034a
ICAX2		= $034b

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Start of code
;
            org $0600
start

			ldx #$00
aLoop		txa
			pha
			
			lda $02e4,x
			jsr convh2a
aDmpAdr1	stx aDmpAdr
aDmpAdr2	sty aDmpadr+1

			inc aDmpAdr1+1
			inc aDmpAdr1+1
			inc aDmpAdr1+1

			inc aDmpAdr2+1
			inc aDmpAdr2+1
			inc aDmpAdr2+1

			pla
			tax
			inx
			cpx #$05
			bne aLoop
			
			jsr print
			.byte '$02E4-$02E8',$9b
aDmpAdr		.byte 'xx xx xx xx xx'
aDmpAdrEnd	.byte $9b,$ff

			ldx #$00
oLoop		txa
			pha
			
			lda $ffee,x
			jsr convh2a
oDmpAdr1	stx oDmpAdr
oDmpAdr2	sty oDmpadr+1

			inc oDmpAdr1+1
			inc oDmpAdr1+1
			inc oDmpAdr1+1

			inc oDmpAdr2+1
			inc oDmpAdr2+1
			inc oDmpAdr2+1

			pla
			tax
			inx
			cpx #$0c
			bne oLoop
			
			jsr print
			.byte '$FFEE-$FFF9',$9b
oDmpAdr		.byte 'xx xx xx xx xx xx xx xx xx xx xx xx'
oDmpAdrEnd	.byte $9b,$ff
			
			rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; convert hex to atascii
;   hex A -> atascii X,Y            
;
convh2a		pha
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
; run address            
;
            run start