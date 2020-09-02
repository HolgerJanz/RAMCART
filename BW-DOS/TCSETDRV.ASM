;
; Set drive for TCDRIVER the Ramdisk and Flashdisk driver for The!Cart
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
IOCB0       = $0340

DOSVEC		= $000A
MEMLO		= $02e7
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
TCMOSL.OSS   = $04
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
TCMOFR.FLASH = $00
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


			org $3000
start
; info message
            jsr print
            .byte 'The!Cart Set Drive ver42bw hjx',$9B,$FF

; !!! DO NOT TOUCH TC REGISTERS, OSS CARTRIDGES HATE IT !!!!
; check for The!Cart
;             lda TCMOSL
;             cmp #TCMOSL.XLLOCK
;             beq noRamDisk
;             cmp #TCMOSL.XELOCK
;             bne checkDOS
;noRamDisk
;            jsr print
;            .byte '  Error: The!Cart not found',$9B,$FF
;            jmp printHelp

checkDOS
			lda MEMLO			; calc MEMLO-$08
			sec
			sbc #$08
			sta checkDOSel+1
			lda MEMLO+1
			sbc #$00
			sta checkDOSeh+1
			ldx #$07
checkDOSloop			
			lda checkArray,X
			eor #$ff
checkDOSa	cmp $700,X
			bne noCheckArray
			dex 
			bpl checkDOSloop
			bmi setConfAddress
noCheckArray			
			inc checkDOSa+1		; increment address
			bne *+5
			inc checkDOSa+2
			
checkDOSel	lda #$00			; check address for MEMLO
			cmp checkDOSa+1
			bne checkDOS
checkDOSeh	lda #$30
			cmp checkDOSa+2
			bne checkDOS		
noBWTCDOS			
            jsr print
            .byte '  Error: No BW-DOS 1.31 TC',$9B,$FF
            jmp printHelp

setConfAddress
            lda checkDOSa+1
            clc
            adc #$08
            sta confAddr+1
            sta disAddr+1
            lda checkDOSa+2
            adc #$00
            sta confAddr+2
            sta disAddr+2

startParameter
			jsr paramCheck			; check for parameter
			bcc parameterEnd
			jsr paramGet
			bne parameterError

            ldy #SD_COMFNAM+1		; get drive number
            lda (DOSVEC),Y
            and #$0f
            ldx driveCnt+1
            sta driveNumbers,X

			inc driveCnt+1			; next
driveCnt	lda #$00
			cmp #$05
			bne startParameter
			beq parameterEnd

parameterEnd
			lda driveCnt+1
			beq displayDrive		; check no parameter
			jsr paramCheck			; check for too many parameter
			bcs parameterError

			jsr print
			.byte 'New configuration:',$9b,$FF
			jsr printDrive

			ldx #$04
driveLoop	lda driveNumbers,X
confAddr	sta $2139,X
			dex
			bpl driveLoop
			
			rts

displayDrive
			ldx #$04
driveLoop2
disAddr		lda $2139,X
			sta driveNumbers,X
			dex
			bpl driveLoop2
			
			jsr print
			.byte 'Current configuration:',$9b,$FF
			jsr printDrive 
			rts

parameterError
            jsr print
            .byte '  Error: Wrong parameter',$9B,$FF

printHelp
            jsr print
            .byte '  Parameter: Dx: [Da:]..[Dd:]',$9B
            .byte '    x - number for ramdisk',$9B
            .byte '    a-d - number for flash disk 1-4',$9B
			.byte '  Use D0: to disable drive.',$9b
            .byte '  Use shift+return/esc in start menu.',$9B
            .byte '  If Dx: equals Da-d:, Dx: precedes.',$9B,$FF
            rts

driveNumbers
			.byte $00	; Ramdisk
			.byte $00	; F1:
			.byte $00	; F2:
			.byte $00	; F3:
			.byte $00	; F4:

;checkArray	.byte $b0,$70,$30,$f0,$3f,$3f,$3f,$3e
; must be hidden else it would be found in sector buffer
checkArray	.byte $4f,$8f,$Cf,$0f,$c0,$c0,$c0,$c1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; print drive config
;
printDrive
loop		ldx #$00
			lda driveNumbers,X
			ora #$30
			sta printDrv
			jsr print
printDev	.byte 'RAM=D'
printDrv	.byte ' ',$FF
			lda #' '
			sta printDev
			lda #'F'
			sta printDev+1
			inc loop+1
			lda loop+1
			ora #$30
			sta printDev+2
			cmp #$35
			bne Loop
			jsr print
			.byte $9b,$FF
			rts
			
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; check for next parameter
;   sets carry if next parameter is available
;
paramCheck	ldy #SD_BUFOFF
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
paramGet		; set crunch name address, if necessary
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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; print subroutine            
;

print       pla
            sta PRINTITER+1
            pla
            sta PRINTITER+2
printLoop   inc PRINTITER+1
            bne PRINTITER
            inc PRINTITER+2
PRINTITER   lda $FFFF
            cmp #$FF
            beq printEnd
            jsr CIOputChar
            jmp printLoop
printEnd    lda PRINTITER+2
            pha
            lda PRINTITER+1
            pha
            rts
; call cio put char subroutine
CIOputChar  ldx #$00
            stx IOCB0+ICBLL
            stx IOCB0+ICBLH
            ldy #$0B
            sty IOCB0+ICCOM
            jmp CIOV

			run start
