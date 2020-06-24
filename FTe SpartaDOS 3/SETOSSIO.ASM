;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Set SpartaDOS 3.2g SIO to OS SIO ($E459)
;

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

BUFRLO      = $0032
BUFRHI      = $0033


DOSVEC      = $000A

SD_LSIO        = $0A ; negative offset to SIO vector


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; start            
;
			org $3000
start
			jsr print
			.byte 'Set OS SIO ',$ff
			
            sec
            lda DOSVEC
            sbc #SD_LSIO
            sta BUFRLO
            lda DOSVEC+1
            sbc #$00
            sta BUFRHI

            ldy #$00
            lda (BUFRLO),Y
            sta sio_old,Y
            lda sio_new,Y
            sta (BUFRLO),Y

			iny
            lda (BUFRLO),Y
            sta sio_old,Y
            lda sio_new,Y
            sta (BUFRLO),Y

			lda sio_old+1
			jsr convh2a
			stx val_old
			sty val_old+1
			lda sio_old
			jsr convh2a
			stx val_old+2
			sty val_old+3

			lda sio_new+1
			jsr convh2a
			stx val_new
			sty val_new+1
			lda sio_new
			jsr convh2a
			stx val_new+2
			sty val_new+3

			jsr print
			.byte 'old=$'
val_old		.byte '0000 new=$'
val_new		.byte '0000',$9b,$ff

			rts

sio_old		.word $0000
sio_new		.word $e459

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; print subroutine            
;
print
			pla
            sta print_iter+1
            pla
            sta print_iter+2
print_loop  inc print_iter+1
            bne print_iter
            inc print_iter+2
print_iter  lda $ffff
            cmp #$ff
            beq print_end
            jsr cioputchr
            jmp print_loop
print_end   lda print_iter+2
            pha
            lda print_iter+1
            pha
            rts
; call cio put char subroutine
cioputchr   ldx #$00
            stx ICBLL
            stx ICBLH
            ldy #$0B
            sty ICCOM
            jmp CIOV
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
; start segment            
;

            run start
            