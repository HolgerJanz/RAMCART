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

; 
; SIO
; 
SIOV        = $E459
; SIOCB addresses
DDEVIC		= $0300
DUNIT		= $0301
DCOMND		= $0302
DSTATS		= $0303
DBUFLO		= $0304
DBUFHI		= $0305
DTIMLO		= $0306
DTIMHI		= $0307
DBYTLO		= $0308
DBYTHI		= $0309
DAUX1		= $030a
DAUX2		= $030b

; cursor
CRSINH		= $02F0

;
; SpartaDOS 
;
DOSVEC		= $000A
;
SD_BUFOFF   = $0A ; offset in line buffer
SD_LBUF     = $3F ; offset to line buffer
SD_ZCRNAME  = $03 ; offset for jmp to crunch name
SD_COMFNAM  = $21 ; offset to buffer for crunch name 
SD_LSIO     = $0A ; negative offset to SIO vector

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Start of code
;
            org $3000
start
;            jsr print
;            .byte 'Poke vers42 by hjx',$9B,$FF

			jsr pcheck			; check for parameter 1
			bcc error_msg
			jmp start_adr
error_msg   jsr PRINT
            .byte '  Error - use: POKE aaaa vv[vv]',$9B
            .byte $ff
			rts
			
start_adr	jsr pget
			beq error_msg

            ldx #$00			; get address
            ldy #SD_COMFNAM+3
loop_r4     lda (DOSVEC),Y
			cmp #$9b
			beq error_msg
			sta char1,x
			iny
			inx
			cpx #$04
			bne loop_r4
			lda (DOSVEC),Y
			cmp #$9b
error_msg2	bne error_msg

			ldx char1			; convert address
			ldy char2
			jsr conva2h
			sta adr1_h

			ldx char3
			ldy char4
			jsr conva2h
			sta adr1_l
			
			jsr pcheck			; check for parameter 2
			bcc error_msg
			jsr pget
			beq error_msg

            ldx #$00
            ldy #SD_COMFNAM+3	; get value
loop_r2     lda (DOSVEC),Y
			cmp #$9b
			beq error_msg
			sta char1,x
			iny
			inx
vchar_cnt	cpx #$02
			bne loop_r2
			lda (DOSVEC),Y
			cmp #$9b
			beq poke

			bit flag_word		; chek for word
			bne error_msg2

			lda #$ff
			sta flag_word
			lda #$04
			sta vchar_cnt+1
			jmp loop_r2
			
poke		ldx char1			; convert value
			ldy char2
			jsr conva2h
			sta val1

			lda adr1_h			; convert address for output
			jsr convh2a
			stx msg_a
			sty msg_a+1

			lda adr1_l
			jsr convh2a
			stx msg_a+2
			sty msg_a+3

			lda val1			; convert value for output
			jsr convh2a
			stx msg_v
			sty msg_v+1


			bit flag_word		; check for word
			beq poke_byte

			clc					; calc adr for high byte
			lda adr1_l
			adc #$01
			sta adr2_l
			lda adr1_h
			adc #$00
			sta adr2_h

			lda val1			; set value for high byte
			sta val2

			ldx char3			; convert value 2 (low)
			ldy char4
			jsr conva2h
			sta val1
			jsr convh2a			; convert value 2 for output
			stx msg_v+2
			sty msg_v+3

			
c_val2		lda #$00
c_adr2		sta $ffff
			
			
poke_byte			
c_val1		lda #$00
c_adr1		sta $ffff

			jsr print
            .byte '$'
msg_a       .byte 'aaaa < $'
msg_v       .byte 'vv  ',$9B
			.byte $FF

            rts

flag_word	.byte $00
char1		.byte $00
char2		.byte $00
char3		.byte $00
char4		.byte $00

adr1_l		= c_adr1+1
adr1_h		= adr1_l+1

adr2_l		= c_adr2+1
adr2_h		= adr2_l+1

val1		= c_val1+1
val2		= c_val2+1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; check for next parameter
;   sets carry if next parameter is available
;
pcheck		ldy #SD_BUFOFF
            lda (DOSVEC),Y
            clc
            adc #SD_LBUF
            tay
            lda (DOSVEC),Y
            cmp #$9b
            clc
            beq pcheck_end
			sec
pcheck_end	rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; get next parameter
;   calls crunch name 
;
; jump for jsr to crunch name
pget_set	.byte $ff
pget		; set crunch name address, if necessary
			bit pget_set
			bpl pget_call
			
			lda DOSVEC
            clc
            adc #SD_ZCRNAME
            sta pget_call+1
            
            lda DOSVEC+1
            adc #$00
            sta pget_call+2
            
			lda #$00
			sta pget_set
			
pget_call	jsr $ffff
			rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; convert atascii to hex
;   atascii X,Y -> hex A            
;
conva2h		txa
			jsr conva2h_h
			asl
			asl
			asl
			asl
			sta conva2h_o+1
			tya
			jsr conva2h_h
conva2h_o	ora #$00
			rts
			
conva2h_h   sec
            sbc #'0'
            cmp #$0A
            bcc conva2h_hl
            clc
            adc #$09
conva2h_hl  and #$0F
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