; clears memory from MEMLO to MEMTOP

MEMTOP      = $02E5
MEMLO       = $02E7
CH			= $02FC
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

			org $0480

			lda MEMLO+1
			jsr convh2a
			stx adr_low
			sty adr_low+1
			lda MEMLO
			jsr convh2a
			stx adr_low+2
			sty adr_low+3

			lda MEMTOP+1
			jsr convh2a
			stx adr_high
			sty adr_high+1
			lda MEMTOP
			jsr convh2a
			stx adr_high+2
			sty adr_high+3

	        jsr PRINT
    	    .byte 'Clear memory $' 
adr_low		.byte 'xxxx-$'
adr_high	.byte 'yyyy ? (Y)',$ff

	        jsr getKey
    	    cmp #$2B
        	beq clear_start
	        jsr PRINT
    	    .byte $9b,'Abort.',$9b,$ff 
			rts

clear_start
			lda MEMLO
			sta clear_loop+1
			lda MEMLO+1
			sta clear_loop+2
			
			ldx #$00
clear_loop	stx $ffff

			lda clear_loop+2	; check for MEMTOP
			cmp MEMTOP+1
			bne clear_inc
			lda clear_loop+1
			cmp MEMTOP
            bcs clear_end
            
clear_inc   inc clear_loop+1	; inc address
            bne clear_loop
			inc clear_loop+2
			jmp clear_loop
			
clear_end	jsr PRINT
    	    .byte $9b,'Done.',$9b,$ff 
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
			