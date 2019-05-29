;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Modified DUP.SYS MyDOS 4.55beta4 for The!Cart
;
; Changed lines are commented out
; followed by substitutes lines 
;

;
; System equates
; 
; IO EQUATES
; 
ICHID       = $0000
ICDNO       = $0001
ICCOM       = $0002
ICSTA       = $0003
ICBAL       = $0004
ICBAH       = $0005
ICPTL       = $0006
ICPTH       = $0007
ICBLL       = $0008
ICBLH       = $0009
ICAX1       = $000A
ICAX2       = $000B
ICAX3       = $000C
ICAX4       = $000D
ICAX5       = $000E
ICAX6       = $000F
; 
; OS VARIABLES FOR XL/XE
; 
; PAGE 0
; 
NGFLAG      = $0001
CASINI      = $0002
RAMLO       = $0004
TRAMSZ      = $0006
CMCMD       = $0007
WARMST      = $0008
BOOT        = $0009
DOSVEC      = $000A
DOSINI      = $000C
APPMHI      = $000E
POKMSK      = $0010
BRKKEY      = $0011
RTCLOK      = $0012
BUFADR      = $0015
ICCOMT      = $0017
DSKFMS      = $0018
DSKUTL      = $001A
ABUFPT      = $001C
ICHIDZ      = $0020
ICDNOZ      = $0021
ICCOMZ      = $0022
ICSTAZ      = $0023
ICBALZ      = $0024
ICBAHZ      = $0025
ICPTLZ      = $0026
ICPTHZ      = $0027
ICBLLZ      = $0028
ICBLHZ      = $0029
ICAX1Z      = $002A
ICAX2Z      = $002B
ICAX3Z      = $002C
ICAX4Z      = $002D
ICAX5Z      = $002E
ICAX6Z      = $002F
STATUS      = $0030
CHKSUM      = $0031
BUFRLO      = $0032
BUFRHI      = $0033
BFENLO      = $0034
BFENHI      = $0035
LTEMP       = $0036
BUFRFL      = $0038
RECVDN      = $0039
XMTDON      = $003A
CHKSNT      = $003B
NOCKSM      = $003C
BPTR        = $003D
FTYPE       = $003E
FEOF        = $003F
FREQ        = $0040
SOUNDR      = $0041
CRITIC      = $0042
FMSZPG      = $0043
ZCHAIN      = $004A
DSTAT       = $004C
ATRACT      = $004D
DRKMSK      = $004E
COLRSH      = $004F
TEMP        = $0050
HOLD1       = $0051
LMARGN      = $0052
RMARGN      = $0053
ROWCRS      = $0054
COLCRS      = $0055
DINDEX      = $0057
SAVMSC      = $0058
OLDROW      = $005A
OLDCOL      = $005B
OLDCHR      = $005D
OLDADR      = $005E
FKDEF       = $0060
PALNTS      = $0062
LOGCOL      = $0063
ADRESS      = $0064
MLTTMP      = $0066
SAVADR      = $0068
RAMTOP      = $006A
BUFCNT      = $006B
BUFSTR      = $006C
BITMSK      = $006E
SHFAMT      = $006F
ROWAC       = $0070
COLAC       = $0072
ENDPT       = $0074
DELTAR      = $0076
DELTAC      = $0077
KEYDEF      = $0079
SWPFLG      = $007B
HOLDCH      = $007C
INSDAT      = $007D
COUNTR      = $007E
LOMEM       = $0080
; 
; PAGE 2
; 
VDSLST      = $0200
VPRCED      = $0202
VINTER      = $0204
VBREAK      = $0206
VKEYBD      = $0208
VSERIN      = $020A
VSEROR      = $020C
VSEROC      = $020E
VTIMR1      = $0210
VTIMR2      = $0212
VTIMR4      = $0214
VIMIRQ      = $0216
CDTMV1      = $0218
CDTMV2      = $021A
CDTMV3      = $021C
CDTMV4      = $021E
CDTMV5      = $0220
VVBLKI      = $0222
VVBLKD      = $0224
CDTMA1      = $0226
CDTMA2      = $0228
CDTMF3      = $022A
SRTIMR      = $022B
CDTMF4      = $022C
INTEMP      = $022D
CDTMF5      = $022E
SDMCTL      = $022F
SDLSTL      = $0230
SDLSTH      = $0231
SSKCTL      = $0232
SPARE       = $0233
LPENH       = $0234
LPENV       = $0235
BRKKY       = $0236
VPIRQ       = $0238
CDEVIC      = $023A
CCOMND      = $023B
CAUX1       = $023C
CAUX2       = $023D
TMPSIO      = $023E
ERRFLG      = $023F
DFLAGS      = $0240
DBSECT      = $0241
BOOTAD      = $0242
COLDST      = $0244
RECLEN      = $0245
DSKTIM      = $0246
PDVMSK      = $0247
SHPDVS      = $0248
PDMSK       = $0249
RELADR      = $024A
PPTMPA      = $024C
PPTMPX      = $024D
CHSALT      = $026B
VSFLAG      = $026C
KEYDIS      = $026D
FINE        = $026E
GPRIOR      = $026F
PADDL0      = $0270
PADDL1      = $0271
PADDL2      = $0272
PADDL3      = $0273
PADDL4      = $0274
PADDL5      = $0275
PADDL6      = $0276
PADDL7      = $0277
STICK0      = $0278
STICK1      = $0279
STICK2      = $027A
STICK3      = $027B
PTRIG0      = $027C
PTRIG1      = $027D
PTRIG2      = $027E
PTRIG3      = $027F
PTRIG4      = $0280
PTRIG5      = $0281
PTRIG6      = $0282
PTRIG7      = $0283
STRIG0      = $0284
STRIG1      = $0285
STRIG2      = $0286
STRIG3      = $0287
HIBYTE      = $0288
WMODE       = $0289
BLIM        = $028A
IMASK       = $028B
JVECK       = $028C
NEWADR      = $028E
TXTROW      = $0290
TXTCOL      = $0291
TINDEX      = $0293
TXTMSC      = $0294
TXTOLD      = $0296
CRETRY      = $029C
HOLD3       = $029D
SUBTMP      = $029E
HOLD2       = $029F
DMASK       = $02A0
TMPLBT      = $02A1
ESCFLG      = $02A2
TABMAP      = $02A3
LOGMAP      = $02B2
INVFLG      = $02B6
FILFLG      = $02B7
TMPROW      = $02B8
TMPCOL      = $02B9
SCRFLG      = $02BB
HOLD4       = $02BC
DRETRY      = $02BD
SHFLOC      = $02BE
BOTSCR      = $02BF
PCOLR0      = $02C0
PCOLR1      = $02C1
PCOLR2      = $02C2
PCOLR3      = $02C3
COLOR0      = $02C4
COLOR1      = $02C5
COLOR2      = $02C6
COLOR3      = $02C7
COLOR4      = $02C8
RUNADR      = $02C9
HIUSED      = $02CB
ZHIUSE      = $02CD
GBYTEA      = $02CF
LOADAD      = $02D1
ZLOADA      = $02D3
DSCTLN      = $02D5
ACMISR      = $02D7
KRPDER      = $02D9
KEYREP      = $02DA
NOCLIK      = $02DB
HELPFG      = $02DC
DMASAV      = $02DD
PBPNT       = $02DE
PBUFSZ      = $02DF
RUNAD       = $02E0
INITAD      = $02E2
RAMSIZ      = $02E4
MEMTOP      = $02E5
MEMLO       = $02E7
HNDLOD      = $02E9
DVSTAT      = $02EA
CBAUDL      = $02EE
CBAUDH      = $02EF
CRSINH      = $02F0
KEYDEL      = $02F1
CH1         = $02F2
CHACT       = $02F3
CHBAS       = $02F4
NEWROW      = $02F5
NEWCOL      = $02F6
ROWINC      = $02F8
COLINC      = $02F9
CHAR        = $02FA
ATACHR      = $02FB
CH          = $02FC
FILDAT      = $02FD
DSPFLG      = $02FE
SSFLAG      = $02FF
; 
; PAGE 3
; 
DDEVIC      = $0300
DUNIT       = $0301
DCOMND      = $0302
DSTATS      = $0303
DBUFLO      = $0304
DBUFHI      = $0305
DTIMLO      = $0306
DUNUSE      = $0307
DBYTLO      = $0308
DBYTHI      = $0309
DAUX1       = $030A
DAUX2       = $030B
TIMER1      = $030C
ADDCOR      = $030E
CASFLG      = $030F
TIMER2      = $0310
TEMP1       = $0312
TEMP2       = $0314
TEMP3       = $0315
SAVIO       = $0316
TIMFLG      = $0317
STACKP      = $0318
TSTAT       = $0319
HATABS      = $031A
PUPBT1      = $033D
PUPBT2      = $033E
PUPBT3      = $033F
IOCB0       = $0340
IOCB1       = $0350
IOCB2       = $0360
IOCB3       = $0370
IOCB4       = $0380
IOCB5       = $0390
IOCB6       = $03A0
IOCB7       = $03B0
PRNBUF      = $03C0
SUPERF      = $03E8
CKEY        = $03E9
CASSBT      = $03EA
CARTCK      = $03EB
DERRF       = $03EC
ACMVAR      = $03ED
BASICF      = $03F8
MINTLK      = $03F9
GINTLK      = $03FA
CHLINK      = $03FB
CASBUF      = $03FD
; 
; HARDWARE REGISTERS
; 
; 
; POKEY
; 
IRQEN       = $D20E
; 
; PIA
; 
PORTA       = $D300
PORTB       = $D301
PACTL       = $D302
PBCTL       = $D303
; 
; ANTIC
; 
NMIEN       = $D40E
; 
; FLOATING POINT ROUTINES
; 
AFP         = $D800
FASC        = $D8E6
IFP         = $D9AA
FPI         = $D9D2
ZFR0        = $DA44
ZF1         = $DA46
FSUB        = $DA60
FADD        = $DA66
FMUL        = $DADB
FDIV        = $DB28
PLYEVL      = $DD40
FLD0R       = $DD89
FLD0P       = $DD8D
FLD1R       = $DD98
FLD1P       = $DD9C
FSTOR       = $DDA7
FSTOP       = $DDAB
FMOVE       = $DDB6
EXP         = $DDC0
EXP10       = $DDCC
LOG         = $DECD
LOG10       = $DED1
; 
; ROM VECTORS
; 
DSKINV      = $E453
CIOV        = $E456
SIOV        = $E459
SETVBV      = $E45C
SYSVBV      = $E45F
XITVBV      = $E462
SIOINV      = $E465
SENDEV      = $E468
INTINV      = $E46B
CIOINV      = $E46E
SELFSV      = $E471
WARMSV      = $E474
COLDSV      = $E477
RBLOKV      = $E47A
CSOPIV      = $E47D
PUPDIV      = $E480
SELFTSV     = $E483
PENTV       = $E486
PHUNLV      = $E489
PHINIV      = $E48C
GPDVV       = $E48F

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



;
; Code equates
;
L00AE       = $00AE
L00D4       = $00D4
L00D5       = $00D5
L00D6       = $00D6
L00D7       = $00D7
L00D8       = $00D8
L00D9       = $00D9
L00DA       = $00DA
L00DB       = $00DB
L00DC       = $00DC
L00DD       = $00DD
L00DE       = $00DE
L00DF       = $00DF
L00E0       = $00E0
L00E1       = $00E1
L00F3       = $00F3
L00F4       = $00F4
L0709       = $0709
L070A       = $070A
L070B       = $070B
L0769       = $0769
L0779       = $0779
L07BE       = $07BE
L07C3       = $07C3
L07CB       = $07CB
L07E0       = $07E0
L0908       = $0908
L0A08       = $0A08
L0B14       = $0B14
L0B1C       = $0B1C
L0B25       = $0B25
L0B2F       = $0B2F
L0B9A       = $0B9A
L0BB9       = $0BB9
L0BBA       = $0BBA
L0C0F       = $0C0F
L0C10       = $0C10
L0C19       = $0C19
L0C1A       = $0C1A
L0C3A       = $0C3A
L0C4C       = $0C4C
L0C4D       = $0C4D
L14EE       = $14EE
L1B24       = $1B24
L1B27       = $1B27
L1B2C       = $1B2C
L1B2E       = $1B2E
L1B34       = $1B34
L1B36       = $1B36
L1B46       = $1B46
L1B48       = $1B48
L1BA8       = $1BA8
L1BEE       = $1BEE
L1BF1       = $1BF1
L1C29       = $1C29
L1C58       = $1C58
L1C65       = $1C65
L1C6F       = $1C6F
L1C70       = $1C70
L1C71       = $1C71
L1C72       = $1C72
L1C73       = $1C73
L1C75       = $1C75
L279F       = $279F
L27A0       = $27A0
L27A1       = $27A1
L27A2       = $27A2
L27A3       = $27A3
L27A4       = $27A4
L27A5       = $27A5
L27A9       = $27A9
L27EF       = $27EF
L27F0       = $27F0
L281F       = $281F
L283F       = $283F
L2840       = $2840
L2841       = $2841
L2842       = $2842
L2843       = $2843
L285F       = $285F
L289E       = $289E
L289F       = $289F
L2978       = $2978
L2979       = $2979
L298A       = $298A
L298B       = $298B
L298E       = $298E
L299F       = $299F
L29A0       = $29A0
L29A1       = $29A1
L29A2       = $29A2
L29A3       = $29A3
L29A4       = $29A4
L29A5       = $29A5
L29A6       = $29A6
L29A7       = $29A7
L29A8       = $29A8
L29A9       = $29A9
L29AA       = $29AA
L29AB       = $29AB
L29AC       = $29AC
L29AD       = $29AD
L29AE       = $29AE
L29AF       = $29AF
L29B0       = $29B0
L29B1       = $29B1
L29B2       = $29B2
L29B3       = $29B3
L29B4       = $29B4
L29B5       = $29B5
L2D8B       = $2D8B
L2DB2       = $2DB2
L2DCC       = $2DCC
L2EDD       = $2EDD
L30A4       = $30A4
L3734       = $3734
L3735       = $3735
L3748       = $3748
L3749       = $3749
L3750       = $3750
L3751       = $3751
L3777       = $3777
L3778       = $3778
L3AAC       = $3AAC
L3AC3       = $3AC3
L3E07       = $3E07
L3E50       = $3E50
L3FB1       = $3FB1
L4000       = $4000
L4172       = $4172
L52A9       = $52A9
L6A33       = $6A33
L8B3C       = $8B3C
LA900       = $A900
LB28D       = $B28D
LBFFA       = $BFFA
LBFFB       = $BFFB
LBFFC       = $BFFC
LBFFD       = $BFFD
LD03D       = $D03D

;
; MyDOS equates
;

RDKLMT      = $0C3A

;
; Start of code
;
            org $2A00
;
            .byte 'D'
L2A01       .byte '5:DOS.SYS'
            .byte $9B
L2A0B       jsr CIOINV
            ldx #$00
            jsr L1B46
            .byte $0C,$03,$62,$1C
            stx CDTMV3
            stx CDTMV3+1
            ldy #$01
            lda #$03
            sta CDTMF3
            jsr SETVBV
L2A27       lda CDTMF3
            bne L2A27
            rts
L2A2D       clc
            cld
            ldx #$FF
            stx BRKKEY
            lda #$07
            sta DOSINI+1
            lda #$E0
            sta DOSINI
            lda #$02
            sta LMARGN
            lda #$27
            sta RMARGN
            lda L1C70
            ora L07BE
            and #$C1
            cmp #$80
            bne L2A51
            sta WARMST
L2A51       lda #$40
            ora L07BE
            sta L07BE
            lda #$80
            ora POKMSK
            sta POKMSK
            sta IRQEN
            jsr L2A0B
            lda L07BE
            and #$01
            beq L2A91
            jsr L442E
            .byte 'Error loading MEM.SA'
            .byte 'V or memory!'
            .byte $9B,$00
L2A91       lda L070B
            ora #$30
            sta L1C75
            ldx #$1C
            ldy #$08
L2A9D       lda #$20
            sta L2B4B,X
            sta L2B4C,X
            sta L2B4D,X
            sta L2B4E,X
            cpy L070A
            bne L2AB4
            lda #$52
            bne L2ABB
L2AB4       lda L0B1C,Y
            beq L2AC0
            lda #$48
L2ABB       sta L2B4D,X
            bne L2B04
L2AC0       lda L07C3,Y
            beq L2B0A
            lda #$53
            sta DCOMND
            sty DUNIT
            stx FMSZPG+5
            jsr DSKINV
            asl DVSTAT
            lda #$00
            adc #$00
            beq L2ADF
            lda #$45
            bne L2AEF
L2ADF       asl DVSTAT
            asl DVSTAT
            adc #$00
            beq L2AED
            lda #$44
            bne L2AEF
L2AED       lda #$53
L2AEF       ldy DUNIT
            ldx FMSZPG+5
            sta L2B4D,X
            lda L07CB,Y
            lsr
            lda #$2D
            bcc L2B01
            lda #$3D
L2B01       sta L2B4E,X
L2B04       tya
            ora #$30
            sta L2B4C,X
L2B0A       dex
            dex
            dex
            dex
            dey
            bne L2A9D
            asl L2CF2
            lda L0779
            cmp #$55
            ror L2CF2
            jsr L3EC8
; add invers TC to version
            .byte $7d,'MyDOS 4.55beta4 ',$d4,$c3,' ' 
            .byte '  (C)1989 '
            .byte $D7,$CF,$D2,$C4,$CD,$C1,$D2,$CB
            .byte $9B
            .byte 'Disks'
L2B4B       .byte ' '
L2B4C       .byte '1'
L2B4D       .byte 'S'
L2B4E       .byte '-                   '
            .byte '         '
            .byte $9B
            .byte 'D: = '
            .byte $00
            lda #$74
            ldx #$1C
            jsr L3EB2
            jsr L3EC8
            .byte $9B,$9B
            .byte '1-8.Dir of D1:-D8: *'
            .byte '. Dir of D:'
            .byte $9B
            .byte 'A. Disk Directory  K'
            .byte '. Save Memory'
            .byte $9B
            .byte 'B. Run Cartridge   L'
            .byte '. Load Memory'
            .byte $9B
            .byte 'C. Copy File(s)    M'
            .byte '. Run at Address'
            .byte $9B
            .byte 'D. Delete File(s)  N'
            .byte '. Load MEM.SAV'
            .byte $9B
            .byte 'E. Rename File(s)  O'
            .byte '. Change Config.'
            .byte $9B
            .byte 'F. Lock File(s)    P'
            .byte '. Set Density'
            .byte $9B
            .byte 'G. Unlock File(s)  Q'
            .byte '. Make Directory'
            .byte $9B
            .byte 'H. Write DOS Files R'
            .byte '. Pick Directory'
            .byte $9B
            .byte 'I. Initialize Disk S'
            .byte '. Set RAMdisk #'
            .byte $9B
            .byte 'J. Duplicate Disk  '
L2CF2       .byte 'V. Set Verify Flag'
            .byte $9B
            .byte ' '
            .byte $9B,$00
            ldy L1C73
            bpl L2D10
            jsr L4136
L2D10       ldx #$FF
            txs
            inx
            stx L1C6F
            stx L29AA
            stx L1C73
            jsr L1B24
            ldx #$30
            jsr L1B2C
            lda #$15
            sta L3FB0
            jsr L3EC8
            .byte 'Select Item ('
            .byte $D2,$C5,$D4,$D5,$D2,$CE
            .byte ' for menu):'
            .byte $00
            lda #$40
            sta SHFLOC
            ora L07BE
            sta L07BE
            jsr L3ED8
            cmp #$9B
            bne L2D6F
            jmp L2A91
L2D61       cmp #$31
            bcc L2D68
            jmp L2DD6
L2D68       cmp #$2A
            bne L2D7B
            jmp L2DCC
L2D6F       cmp #$3A
            bcc L2D61
            cmp #$57
            bcs L2D7B
            sbc #$40
            bcs L2D7D
L2D7B       lda #$16
L2D7D       asl
            tay
            lda L2D9E,Y
            sta DSKUTL
            lda L2D9F,Y
            sta DSKUTL+1
            jmp L3ECE
            .byte 'No such item!'
            .byte $9B,$00
            jmp L2D10
L2D9E       .byte $F7
L2D9F       and L3E07
            .byte $7F
            bmi L2DB2
            .byte $2F
            ldy #$2F
            .byte $C3
            rol L2EDD
            beq L2DE0
            eor BUFRLO,X
            adc L6A33,Y
            .byte $3C
            txs
            and L3E50,X
            adc LD03D
            .byte $3A
            cmp LTEMP
            inc ICAX6Z
            asl STATUS
            .byte $13,$3C,$8B
            and L2D8B
            bit L8B3C
            and LB28D
            and #$A9
            .byte $3A
            sta L29B1
            bne L2DDE
L2DD6       sta L29B1
            lda #$3A
            sta L29B2
L2DDE       lda #$2A
L2DE0       sta L29B3
            sta L29B4
            lda #$44
            sta L29B0
            lda #$9B
            sta L29B5
            sta L29A9
            sta L27EF
            bne L2E20
            .byte 'Files to list, Desti'
            .byte 'nation?'
            .byte $9B,$00
            lda #$9B
            sta L29A9
            jsr L41E2
            jsr L43E5
L2E20       lda #$B0
            ldy #$29
            jsr L1B34
            ldx #$10
            stx L29A7
            jsr L43C4
            lda #$29
            sta L00DB
            lda #$79
            sta L00DA
            lda #$26
            sta L00DC
            lda #$00
            sta L00DD
            ldx #$00
            lda L27EF
            bmi L2E5A
            lda L27EF
            bmi L2E54
            jsr L41EC
            sty IOCB2+ICBAL
            sta IOCB2+ICBAH
L2E54       ldx #$20
            lda #$07
            bne L2E5C
L2E5A       lda #$05
L2E5C       stx L29A8
            jsr L403E
            jmp L2D10
L2E65       jsr L442E
            .byte 'Need new file name!'
            .byte $9B,$00
L2E7D       jsr L442E
            .byte 'No drive or director'
            .byte 'ies allowed in new n'
            .byte 'ame!'
            .byte $9B,$00
            .byte 'Lock '
            .byte $00
            .byte 'Unlock '
            .byte $00
            .byte 'Delete '
            .byte $00
            .byte 'Lock which file?'
            .byte $9B,$00
            ldy #$AE
            ldx #$2E
            lda #$23
            bne L2EF8
            .byte 'Unlock which file?'
            .byte $9B,$00
            ldy #$B4
            ldx #$2E
            lda #$24
L2EF8       sty L29AC
            stx L29AD
            pha
            jsr L41E2
            jsr L42FF
            ldx L1C6F
            cpx #$51
            beq L2F3B
            bne L2F85
            .byte 'Delete what file?'
            .byte $9B,$00
            ldy #$BC
            ldx #$2E
            lda #$21
            sty L29AC
            stx L29AD
            pha
            jsr L41E2
            jsr L42FF
            ldx L1C6F
            cpx #$4E
            beq L2F85
L2F3B       jsr L3EC8
            .byte 'Answer ''Y'' or ''N'''
            .byte $9B,$00
            pla
            jsr L43B2
L2F55       jsr L409E
            bcs L2F95
            lda L29AC
            ldx L29AD
            jsr L3EB2
            lda #$B0
            ldx #$29
            jsr L3EB2
            jsr L3EC8
            .byte $3F
            brk
            jsr L3ED8
            cmp #$59
            bne L2F7B
            ldx #$20
            jsr L412F
L2F7B       jmp L2F55
L2F7E       pha
            jsr L41E2
            jsr L42FF
L2F85       pla
L2F86       sta IOCB1+ICCOM
            ldx #$10
            jsr L412F
            lda IOCB1+ICCOM
            cmp #$29
            beq L2F98
L2F95       jmp L2D10
L2F98       jmp L3038
L2F9B       jmp L2E7D
L2F9E       jmp L2E65
            .byte 'File to rename, new '
            .byte 'name?'
            .byte $9B,$00
            jsr L41E2
            jsr L42FF
            ldy L29A0
            lda L27EF
            cmp #$2C
            beq L2FD0
            cmp #$20
            bne L2F9E
L2FD0       iny
            lda (L00DE),Y
            cmp #$3A
            beq L2F9B
            cmp #$3E
            beq L2F9B
            cmp #$30
            bcc L2FE3
            cmp #$7B
            bcc L2FD0
L2FE3       lda #$20
            bne L2F86
            .byte 'Full directory name?'
            .byte $9B,$00
            ldx #$08
            stx IOCB1+ICAX1
            lda #$22
            jmp L2F7E
            .byte 'Directory to be used'
            .byte ' as ''D:''?'
            .byte $9B,$00
            jsr L41E2
            jsr L42FF
            ldy L29A0
            cpy #$04
            bcc L3055
            lda #$29
            jmp L2F86
L3038       ldy #$03
            lda (ICBALZ),Y
            cmp #$3A
            bne L3052
            jsr L1B27
            lda #$74
            sta IOCB1+ICBAL
            lda #$1C
            sta IOCB1+ICBAH
            lda #$29
            jmp L2F86
L3052       jmp L2D10
L3055       jsr L442E
            .byte 'Invalid directory!'
            .byte $9B,$00
L306C       jmp L4136
L306F       ldx #$10
            stx L29A7
            jsr L1B46
            .byte $04,$03
            bcs L30A4
            bmi L306C
            jmp L2E54
            .byte 'File source, destina'
            .byte 'tion?'
            .byte $9B,$00
            lda #$20
            sta L2842
            lda #$9B
            sta L29A9
            jsr L41E2
            lda #$44
            sta L00DB
            lda #$3A
            sta L00DA
            lda MEMTOP
            sec
            sbc #$3A
            sta L00DC
            lda MEMTOP+1
            sbc #$44
            sta L00DD
            jsr L43E5
            lda L27EF
            bmi L30CA
            jsr L41EC
L30CA       asl WARMST
            lda L00DF
            sta IOCB2+ICBAH
            lda L00DE
            sta IOCB2+ICBAL
            lda L29B0
            cmp #$44
            bne L306F
            lda #$B0
            ldy #$29
            jsr L1B34
            lda #$3F
            ldy #$0B
L30E8       sta L27EF,Y
            dey
            bne L30E8
            jsr L4322
            ldx #$10
            jsr L43C4
            ldy #$FF
L30F8       iny
            lda (L00DE),Y
            sta L2840,Y
            bne L30F8
L3100       dey
            lda (L00DE),Y
            cmp #$3A
            beq L310B
            cmp #$3E
            bne L3100
L310B       iny
            sty L29AF
            lda (L00DE),Y
            beq L3156
            ldx #$00
L3115       lda (L00DE),Y
            bmi L3163
            cmp #$2A
            beq L312A
            cmp #$2E
            bcc L3163
            bne L3126
            lda #$20
            dey
L3126       sta L27F0,X
            iny
L312A       inx
            cpx #$08
            bcc L3115
L312F       iny
L3130       lda (L00DE),Y
            beq L3163
            cmp #$2E
            beq L312F
            cmp #$2A
            beq L3156
            cmp #$20
            beq L3163
            cmp #$2C
            beq L3163
            cmp #$9B
            beq L3163
            iny
L3149       sta L27F0,X
            inx
            cpx #$0B
            bcc L3130
            bcs L3156
L3153       jsr L4322
L3156       jsr L409E
            bit L29A4
            bmi L3156
            bcc L3167
            jmp L2D10
L3163       lda #$20
            bne L3149
L3167       lda #$28
            sta IOCB3+ICBAH
            lda #$40
            sta IOCB3+ICBAL
            ldx #$00
            ldy L29AF
L3176       lda L27F0,X
            beq L31AE
            cmp #$3F
            bne L3182
            lda L27A1,X
L3182       sta L2840,Y
            cmp #$20
            beq L318A
            iny
L318A       inx
            cpx #$08
            bcc L3176
            lda #$2E
            sta L2840,Y
            iny
L3195       lda L27F0,X
            beq L31AE
            cmp #$3F
            bne L31A1
            lda L27A1,X
L31A1       sta L2840,Y
            cmp #$20
            beq L31A9
            iny
L31A9       inx
            cpx #$0B
            bcc L3195
L31AE       lda #$2E
            cmp L283F,Y
            bne L31B6
            dey
L31B6       lda #$9B
            ldx L1C6F
            cpx #$51
            bne L31C1
            lda #$3F
L31C1       sta L2840,Y
            lda #$00
            sta L2841,Y
            lda L29A9
            bne L31F2
            lda #$B0
            ldx #$29
            jsr L3EB2
            jsr L3EC8
            and L3E2D
            jsr LA900
            rti
            ldx #$28
            jsr L3EB2
            lda L1C6F
            cmp #$51
            bne L31F2
            jsr L3ED8
            cmp #$59
            bne L3244
L31F2       lda IOCB1+ICAX6
            sta IOCB2+ICAX6
            ldx #$20
            stx L29A7
            lda #$04
            sta IOCB0+ICAX1,X
            lda #$B0
            ldy #$29
            jsr L1B36
            lda #$03
            jsr L1B2E
            bmi L324F
            ldx #$07
L3212       lda L4425,X
            cmp L2842,X
            bne L322B
            dex
            bne L3212
            lda L2841
            sta L441C
            sta L2A01
            lda #$60
            sta L2843
L322B       lda #$28
            sta IOCB3+ICBAH
            lda #$40
            sta IOCB3+ICBAL
            ldx #$08
            stx IOCB3+ICAX1
            ldx #$30
            stx L29A8
            lda #$07
            jsr L403E
L3244       lda L29A9
            bne L324C
            jmp L3153
L324C       jmp L2D10
L324F       jmp L4136
L3252       lda #$01
            bne L32C4
            .byte 'Disk to FORMAT:'
            .byte $00
            jsr L42AB
            jsr L43E5
            lda #$29
            sta IOCB1+ICBAH
            lda #$B0
            sta IOCB1+ICBAL
            ldy #$01
            lda (L00DE),Y
            sta L32B6
            jsr L3EC8
            .byte '(Press '
            .byte $DB,$C1,$DD
            .byte ' for Enhanced Dns)'
            .byte $9B
            .byte 'Type '
            .byte $DB,$D9,$DD
            .byte ' to Format Drive '
L32B6       .byte '0:'
            .byte $00
            jsr L3ED8
            cmp #$41
            beq L3252
            eor #$59
            bne L32E3
L32C4       sta IOCB1+ICAX1
            lda #$00
            ldx L1C6F
            cpx #$4E
            bne L32D1
            ror
L32D1       sta IOCB1+ICAX2
            lda #$FE
            sta IOCB1+ICCOM
            ldx #$10
            jsr CIOV
            bpl L32E3
            jmp L4136
L32E3       jmp L2D10
            .byte 'D'
L32E7       .byte '5:DUP.SYS'
            .byte $9B
            .byte 'Drive to write DOS f'
            .byte 'iles to?'
            .byte $00
            jsr L42AB
            lda L1C65
            pha
            lda #$31
            sta L1C65
            sta L1C58
            ldy #$01
            lda (L00DE),Y
            cmp #$3A
            bne L3328
            lda L1C75
L3328       sta L2A01
            sta L32E7
            dey
            sty L1C6F
            lda #$80
            sta L07BE
            lda #$00
            ldy #$2A
            jsr L1B34
            lda #$08
            sta IOCB1+ICAX1
            jsr L43C9
            jsr L1B27
            pla
            sta L1C58
            sta L1C65
            ldy #$70
            lda #$00
            ldx #$2A
            jsr L3D66
            lda #$32
            sta IOCB1+ICBAH
            lda #$E6
            sta IOCB1+ICBAL
            lda #$44
            sta L00D9
            lda #$39
            sta L00D8
            lda #$1A
            sta L00DB
            lda #$3A
            sta L00DA
            lda #$00
            sta L00E0
            jmp L3D11
            .byte 'Source, Destination '
            .byte '(Sectors)?'
            .byte $9B,$00
            jsr L42AB
            ldy #$01
            lda (L00DE),Y
            and #$0F
            sta L29A7
            sta L29A8
            lda L27EF
            cmp #$28
            beq L33C6
            jsr L42A5
            ldy #$01
            lda (L00DE),Y
            and #$0F
            sta L29A8
            cmp L29A7
            bne L33C6
            ldx #$9B
            stx L29AA
L33C6       tax
            ldy L29A7
            lda L29AA
            ora #$40
            sta L29AA
            bmi L33F9
            jsr L3EC8
            .byte 'Insert both disks, t'
            .byte 'ype '
            .byte $D2,$C5,$D4,$D5,$D2,$CE,$00
            jsr L3ED8
L33F9       jsr L4322
            lda L29A7
            jsr L42DB
            asl DVSTAT
            lda #$00
            adc #$00
            sta IOCB2+ICAX1
            ldy L29A8
            ldx L29A7
            lda L07C3,X
            cmp L07C3,Y
            beq L3449
            sty L299F
            jsr L4366
            ldy L29A8
            ldx L29A7
            lda L07C3,X
            cmp L07C3,Y
            beq L3449
            jsr L442E
            .byte 'Drives not compatibl'
            .byte 'e!'
            .byte $9B,$00
L3449       asl WARMST
            lsr
            sta L29AD
            ror
            sta L29AC
            stx DUNIT
            lda L27EF
            pha
            lda #$FF
            tax
L345D       sta L281F,X
            sta L289F,X
            dex
            bne L345D
            pla
            cmp #$28
            beq L3484
            cmp #$9B
            beq L34E8
L346F       jsr L442E
            .byte 'Invalid options!'
            .byte $9B,$00
L3484       jsr L4170
            cpy #$2D
            bne L346F
            sta L27A2
            stx L27A3
            jsr L4170
            cpy #$29
            bne L346F
            sta L27A0
            stx L27A1
            ldy #$00
            sty L29A0
            sty L27A5
            sty L27A4
            lda #$27
            sta L00DB
            lda #$A9
            sta L00DA
            lda #$FE
L34B3       ldx L27A5
            cpx L27A3
            bne L34C3
            ldx L27A4
            cpx L27A2
            bcs L34CA
L34C3       sec
            rol
            jsr L351A
            bne L34B3
L34CA       ldx L27A1
            cpx L27A5
            bcc L34E2
            bne L34DC
            ldx L27A0
            cpx L27A4
            bcc L34E2
L34DC       asl
            jsr L351A
            bne L34CA
L34E2       sec
            rol
            bcs L34E2
            sta (L00DA),Y
L34E8       sec
            lda MEMTOP
            sbc L29AC
            sta L00DC
            lda MEMTOP+1
            sbc L29AD
            sta L00DD
            lda L00DC
            cmp #$3A
            lda L00DD
            sbc #$44
            bcs L352F
            jsr L442E
            .byte 'Not enough memory!'
            .byte $9B,$00
L351A       bcs L3526
            sta (L00DA),Y
            lda #$FE
            inc L00DA
            bne L3526
            inc L00DB
L3526       inc L27A4
            bne L352E
            inc L27A5
L352E       rts
L352F       lda L29A0
            beq L3581
            lda #$68
            ldx #$01
            sta DAUX1
            stx DAUX2
            lda #$9F
            ldx #$27
            sta DBUFLO
            stx DBUFHI
            jsr L3F28
            bpl L3550
            jmp L4136
L3550       clc
            lda L27A0
            adc #$0C
            sta L27A0
            bcc L355E
            inc L27A1
L355E       lda L279F
            cmp #$04
            bcc L3581
            inc L27A0
            clc
            lda DBUFLO
            adc DBYTLO
            sta DBUFLO
            lda DBUFHI
            adc DBYTHI
            sta DBUFHI
            dec DAUX1
            jsr L3F28
L3581       lda #$00
            sta DAUX2
            lda #$01
            sta DAUX1
            lda L27A9
            sta L29A4
            lda #$08
            sta L29A2
            lda #$27
            sta L00D5
            lda #$A9
            sta L00D4
L359E       lda L00D4
            sta L29A1
            lda L00D5
            sta L29A0
            lda L29A2
            sta L29A3
            lda L29A4
            sta L1C73
            lda DAUX1
            sta L29A5
            lda DAUX2
            sta L29A6
            lda #$00
            sta L29A9
L35C5       lda #$44
            sta DBUFHI
            lda #$3A
            sta DBUFLO
L35CF       asl L29A4
            dec L29A2
            bne L35E9
            inc L00D4
            bne L35DD
            inc L00D5
L35DD       ldy #$00
            lda (L00D4),Y
            sta L29A4
            ldx #$08
            stx L29A2
L35E9       bit L29A4
            bmi L3610
            lda L29A9
            asl
            lda L29A7
            bcc L35FA
            lda L29A8
L35FA       jsr L3F2C
            clc
            lda DBUFLO
            adc L29AC
            sta DBUFLO
            lda DBUFHI
            adc L29AD
            sta DBUFHI
L3610       lda DAUX1
            cmp L27A0
            lda DAUX2
            sbc L27A1
            bcc L3626
            lda L29A9
            bpl L3645
            jmp L2D10
L3626       inc DAUX1
            bne L362E
            inc DAUX2
L362E       lda L00DC
            cmp DBUFLO
            lda L00DD
            sbc DBUFHI
            bcs L35CF
            lda L29A9
            bpl L3645
            jsr L4322
            jmp L359E
L3645       bit L29AA
            bpl L3676
            jsr L3EC8
            .byte 'Insert DESTINATION d'
            .byte 'isk, press '
            .byte $D2,$C5,$D4,$D5,$D2,$CE,$00
            jsr L3ED8
L3676       lda #$4E
            cmp L1C6F
            beq L3699
            sta L1C6F
            ldx #$20
            lda #$00
            ldy #$2A
            jsr L1B36
            lda #$FE
            sta IOCB2+ICCOM
            lda L29A8
            ora #$30
            sta L2A01
            jsr L412F
L3699       lda #$00
            sta IOCB2+ICAX1
            dec L29A9
            lda L29A1
            sta L00D4
            lda L29A0
            sta L00D5
            lda L29A5
            sta DAUX1
            lda L29A6
            sta DAUX2
            lda L29A3
            sta L29A2
            lda L1C73
            sta L29A4
            jmp L35C5
            .byte 'Drive, new density:'
            .byte $00
            jsr L42AB
            lda L27EF
            cmp #$9B
            bne L36F9
L36E4       jsr L442E
            .byte 'Drive unchanged.'
            .byte $9B,$00
L36F9       ldy L29A0
            lda (L00DE),Y
            tax
            ldy #$01
            lda (L00DE),Y
            cmp #$39
            bcs L36E4
            sbc #$30
            bcc L36E4
            tay
            iny
            sty L299F
            lda #$01
            cpx #$53
            beq L371B
            cpx #$44
            bne L36E4
            asl
L371B       sta L07C3,Y
            jsr L4393
            jmp L2A91
CHKBANKS    
        lda TCMOSL
        cmp #TCMOSL.XLLOCK
        beq CHKB.NO
        cmp #TCMOSL.XELOCK
        bne CHKB.YE
CHKB.NO lda #$00
        sta RDKLMT
        rts
CHKB.YE lda #$20
        sta RDKLMT
        rts
L3733   nop ; just for valid L3733
;            sei
;            ldy #$00
;            sty NMIEN
;            sty IRQEN
;            lda PORTB
;            pha
;            ldx #$FF
;L3733       sty PORTB
;            lda L4000
;            sta L0908,Y
            stx L4000
            txa
            sta L0A08,Y
            iny
            bne L3733
            dex
            stx PORTB
            stx L4000
            ldx #$00
L374F       sty PORTB
            lda L4000
            cmp #$FF
            bne L375E
            inx
            stx L4000
            txa
L375E       sta L0A08,Y
            iny
            bne L374F
            stx L0C3A
            ldx #$01
L3769       txa
            ldy #$FF
L376C       cmp L0A08,Y
            beq L3794
            dey
            cpy #$FF
            bne L376C
L3776       sty PORTB
            lda L0908,Y
            sta L4000
            dey
            cpy #$FF
            bne L3776
            pla
            sta PORTB
            lda #$C0
            sta NMIEN
            lda POKMSK
            sta IRQEN
            cli
            rts
L3794       tya
            sta L0BB9,X
            inx
            cpx #$41
            bcc L3769
            ldy #$FE
            bne L3776
L37A1       jsr L3EC8
            .byte 'RAM disk present?'
            .byte $00
            jsr L3ED8
            ldy #$00
            cmp #$59
            beq L37C2
            jmp L392F
L37C2       jmp CHKRDBN ; jump over AXLON/XE question
;             jsr L3EC8
            .byte $DB,$C1,$DD
            .byte 'xlon or '
            .byte $DB,$D8,$DD
            .byte 'E type RAMdisk?'
            .byte $00
            jsr L3ED8
            ldy #$01
            ldx #$D3
            cmp #$58
            beq L37F6
            ldy #$FF
            ldx #$CF
            cmp #$41
            bne L37C2
L37F6       sty L0C19
            sty L0C4C
            sty L3734
            sty L3748
            sty L3750
            sty L3777
            stx L0C1A
            stx L0C4D
            stx L3735
            stx L3749
            stx L3751
            stx L3778
            ldy #$EA
            ldx #$EA
            cmp #$58
            beq L3826
            ldy #$A9
            ldx #$00
L3826       sty L0C0F
            stx L0C10
CHKRDBN     jsr CHKBANKS
            lda L0C3A
            bne L385B
            jsr L3EC8
            .byte 'No extended memory i'
            .byte 'nstalled!'
            .byte $9B,$00
            ldy #$00
            jmp L392F
L385B       ldx #$00
            stx L00D5
            asl
            asl
            rol L00D5
            asl
            rol L00D5
            asl
            sta L00D4
            rol L00D5
            jsr IFP
            jsr FASC
            jsr L3EC8
            .byte 'Use default config f'
            .byte 'or '
            .byte $00
            ldy #$00
L388E       lda (L00F3),Y
            bmi L3895
            iny
            bne L388E
L3895       and #$7F
            sta (L00F3),Y
            iny
            lda #$00
            sta (L00F3),Y
            lda L00F3
            ldx L00F4
            jsr L3EB2
            jsr L3EC8
            .byte $4B,$3F
            .byte $00
            jsr L3ED8
            cmp #$4E
            beq L38B5
            jmp L38F8
L38B5       jsr L3EC8
            .byte 'Size(K)?'
            .byte $00
            jsr L410E
            jsr L4170
            lsr L00D5
            ror
            lsr L00D5
            ror
            lsr L00D5
            ror
            lsr L00D5
            ror
            bne L38D7
            lda #$04
L38D7       sta L0C3A
L38DA       jmp l38F8 ; jump over page sequence
;            jsr L3EC8
            .byte 'Page sequence?'
            .byte $00
            jsr L410E
            jsr L4172
            cpy #$9B
            bne L3973
            beq L3933
L38F8       jsr L3EC8
            .byte 'RAM disk drive no?'
            .byte $00
            jmp L391F ; jump over MAPAGE munipulation
;            lda L0C1A
            cmp #$CF
            bne L391F
            ldx L0C3A
L3918       txa
            sta L0BB9,X
            dex
            bne L3918
L391F       jsr L3ED8
            ldy #$08
            cmp #$30
            bcc L392F
            cmp #$39
            bcs L392F
            and #$0F
            tay
L392F       sty L070A
            rts
L3933       tay
            ldx L39FD,Y
            cpy #$03
            bcs L3968
            lda L3A03,Y
            ldx #$00
L3940       rol
            rol
            pha
            rol
            rol
            rol
            and #$0C
            tay
L3949       lda L3A09,Y
            sta L0BBA,X
            inx
            iny
            txa
            and #$03
            bne L3949
            pla
            cpx #$10
            bne L3940
L395B       lda L3A09,X
            sta L0BBA,X
            inx
            cpx #$40
            bne L395B
            beq L38F8
L3968       ldx #$40
L396A       dex
            txa
            sta L0BBA,X
            bne L396A
            beq L38F8
L3973       ldx #$00
            pha
            txa
L3977       sta L289F,X
            inx
            bne L3977
            pla
L397E       stx L299F
            cpy #$9B
            beq L39A8
            sta L285F,X
            tax
            lda L289F,X
            bne L39BA
            dec L289F,X
            ldy L29A0
            lda (L00DE),Y
            cmp #$9B
            bne L399D
            jsr L410E
L399D       jsr L4172
            ldx L299F
            inx
            cpx #$40
            bne L397E
L39A8       cpx L0C3A
            bne L39DD
L39AD       dex
            lda L285F,X
            sta L0BBA,X
            txa
            bne L39AD
            jmp L38F8
L39BA       jsr L3EC8
            .byte 'Duplicated sequence '
            .byte 'number!'
            .byte $9B,$00
            jmp L38DA
L39DD       jsr L3EC8
            .byte 'Wrong number of entr'
            .byte 'ies!'
            .byte $9B,$00
            jmp L38DA
L39FD       .byte $00,$00,$00,$FF,$FF,$FF
L3A03       .byte $9C,$D8,$4B,$FF,$FF,$00
L3A09       .byte $A3,$A7,$AB,$AF,$C3,$C7,$CB,$CF
            .byte $E3,$E7,$EB,$EF,$83,$87,$8B,$8F
            .byte $A1,$A5,$A9,$AD,$C1,$C5,$C9,$CD
            .byte $E1,$E5,$E9,$ED,$81,$85,$89,$8D
            .byte $A2,$A6,$AA,$AE,$C2,$C6,$CA,$CE
            .byte $E2,$E6,$EA,$EE,$82,$86,$8A,$8E
            .byte $A0,$A4,$A8,$AC,$C0,$C4,$C8,$CC
            .byte $E0,$E4,$E8,$EC,$80,$84,$88,$8C
L3A49       jsr L3EC8
            .byte 'Number of File Buffe'
            .byte 'rs?'
            .byte $00
            jsr L410E
            jsr L4170
            beq L3A73
            cmp #$11
            bcs L3A73
            sta L0709
L3A73       jsr L3EC8
            .byte '3 or 4 digit directo'
            .byte 'ry?'
            .byte $00
            jsr L410E
            jsr L4170
            ldy #$00
            cmp #$03
            beq L3AA5
            cmp #$04
            beq L3AA9
            bne L3AB7
L3AA0       cmp #$31
            pla
            bne L3AAC
L3AA5       ldx #$00
            beq L3AAB
L3AA9       ldx #$02
L3AAB       lda L3AA0,X
            sta L14EE,Y
            inx
            iny
            cpy #$03
            bne L3AAB
L3AB7       jsr L37A1
            jsr L07E0
            jmp L2A2D
L3AC0       lda #$D2
            bit L52A9
            ldy L299F
            sta L07CB,Y
            jsr L3C5B
            jmp L2D10
            .byte 'Drive number or '
            .byte $D2,$C5,$D4,$D5,$D2,$CE
            .byte ':'
            .byte $00
            jsr L3ED8
            cmp #$9B
            bne L3AF3
            jmp L3A49
L3AF3       cmp #$39
            bcc L3AFA
L3AF7       jmp L36E4
L3AFA       sbc #$30
            bcc L3AF7
            tay
            iny
            sty L299F
            lda #$00
            sta L07CB,Y
            jsr L3EC8
            .byte 'Remove drive?'
            .byte $00
            jsr L3ED8
            cmp #$59
            beq L3AC0
            jsr L3EC8
            .byte 'Is drive configurabl'
            .byte 'e?'
            .byte $00
            jsr L3ED8
            cmp #$59
            bne L3AC3
            jsr L3EC8
            .byte 'High capacity drive?'
            .byte $00
            jsr L3ED8
            cmp #$59
            beq L3BD9
            jsr L3EC8
            .byte 'Is drive double side'
            .byte 'd?'
            .byte $00
            jsr L3ED8
            cmp #$59
            bne L3B86
            lda #$01
            jsr L3C51
L3B86       jsr L3EC8
            .byte 'Tracks/side?'
            .byte $00
            jsr L410E
            jsr L4170
            cmp #$23
            beq L3BB6
            tay
            lda #$30
            cpy #$4D
            beq L3BB3
            lda #$20
            cpy #$50
            beq L3BB3
            lda #$10
            cpy #$28
            bne L3B86
L3BB3       jsr L3C51
L3BB6       jsr L3EC8
            .byte 'Step rate?'
            .byte $00
            jsr L3ED8
            cmp #$34
            bcs L3BB6
            sbc #$2F
            bcc L3BB6
            asl
            jsr L3C51
            jsr L3C5B
            jmp L2D10
L3BD9       jsr L3EC8
            .byte 'Drive size (in secto'
            .byte 'rs)?'
            .byte $00
            jsr L410E
            jsr L4170
            cpx #$00
            beq L3BD9
            pha
            ldy L299F
            lda #$12
            sta L07CB,Y
            lda #$02
            sta L07C3,Y
            pla
            jsr L3C5E
            jmp L2D10
            .byte 'RAM disk drive no?'
            .byte $00
            jsr L391F
            jmp L2D10
            .byte 'Verify WRITEs?'
            .byte $00
            jsr L3C42
            jmp L2D10
L3C42       jsr L3ED8
            ldx #$50
            cmp #$59
            bne L3C4D
            ldx #$57
L3C4D       stx L0779
            rts
L3C51       ldy L299F
            ora L07CB,Y
            sta L07CB,Y
            rts
L3C5B       ldx #$00
            txa
L3C5E       ldy L299F
            sta L0B14,Y
            txa
            sta L0B1C,Y
            jmp L4393
            .byte 'SAVE:filename,start,'
            .byte 'end(,init(,run))'
            .byte $9B,$00
            jsr L41E2
            sty IOCB1+ICBAL
            sta IOCB1+ICBAH
            lda L1C6F
            pha
            jsr L4172
            cpx #$44
            ldy #$70
            bcs L3CA9
            ldy #$80
L3CA9       jsr L3D66
            jsr L4172
            sta L00D8
            stx L00D9
            sec
            sbc L00D6
            sta L00DA
            txa
            sbc L00D7
            bpl L3CDA
            jsr L442E
            .byte 'Invalid START-END ra'
            .byte 'nge!'
            .byte $9B,$00
L3CDA       sta L00DB
            inc L00DA
            bne L3CE2
            inc L00DB
L3CE2       lda #$00
            cpy #$9B
            beq L3CF8
            jsr L4172
            sta INITAD
            stx INITAD+1
            ora INITAD+1
            beq L3CF8
            lda #$01
L3CF8       sta L00E0
            cpy #$9B
            beq L3D10
            jsr L4172
            sta RUNAD
            stx RUNAD+1
            ora RUNAD+1
            beq L3D10
            inc L00E0
            inc L00E0
L3D10       pla
L3D11       ldy #$00
            sty L1C6F
            dey
            sty L00D4
            sty L00D5
            ldy #$08
            cmp #$41
            bne L3D25
            dec L1C6F
            iny
L3D25       sty IOCB1+ICAX1
            ldx #$10
            jsr L43C9
            bmi L3D63
            lda L1C6F
            beq L3D5E
            jsr L1B48
            bpl L3D3D
            brk
            .byte $0B
            dec $00,X
L3D3D       bmi L3D63
L3D3F       lda L00DA
            sta IOCB1+ICBLL
            lda L00DB
            sta IOCB1+ICBLH
            lda L00D6
            sta IOCB1+ICBAL
            lda L00D7
            sta IOCB1+ICBAH
            bit L07BE
            bmi L3D5B
            jmp L1BF1
L3D5B       jmp L1BEE
L3D5E       jsr L1C29
            bpl L3D3F
L3D63       jmp L4136
L3D66       sta L00D6
            stx L00D7
            sty L07BE
            rts
            .byte 'Load MEM.SAV from wh'
            .byte 'at file?'
            .byte $9B,$00
            lda L07BE
            ora #$80
            bmi L3DB6
L3D93       jmp L2D10
L3D96       ldy #$B4
L3D98       jmp L4136
            .byte 'Load from what file?'
            .byte $9B,$00
            lda L07BE
            and #$7F
L3DB6       sta L07BE
            jsr L41E2
            sty IOCB1+ICBAL
            sta IOCB1+ICBAH
            ldx L27A2
            beq L3D93
            lda #$04
            sta IOCB1+ICAX1
            ldx #$10
            jsr L43C9
            jsr L1B48
            bpl L3DD8
            brk
            .byte $07
L3DD8       .byte $9F,$27
            bmi L3D98
            lda L279F
            and L27A0
            cmp #$FF
            bne L3D96
            lda L27A2
            beq L3D93
            lda L1C6F
            eor #$4E
            beq L3DF8
            lda #$00
            sta WARMST
            lda #$03
L3DF8       eor #$07
            sta IOCB1+ICAX1
            lda #$27
            sta IOCB1+ICCOM
            lda #$56
            ldx #$E4
            bne L3E38
            brk
            lda LBFFD
            eor #$AA
            sta LBFFD
            cmp LBFFD
            bne L3E2D
            eor #$AA
            sta LBFFD
L3E1B       jsr L442E
            .byte 'NO CARTRIDGE!'
            .byte $9B,$00
L3E2D       ldx LBFFC
            bne L3E1B
            lda LBFFA
            ldx LBFFB
L3E38       sta L00D4
            stx L00D5
            lda L1C71
            sta DOSINI
            lda L1C72
            sta DOSINI+1
            lda L07BE
            and #$BF
            sta L07BE
            jmp L1BA8
            .byte 'Run from what addres'
            .byte 's?'
            .byte $00
            jsr L410E
            lda (L00DE),Y
            cmp #$9B
            beq L3E7E
            jsr L4172
            cpy #$9B
            bne L3E7E
            ldy #$00
            sty WARMST
            beq L3E38
L3E7E       jsr L442E
            .byte 'Address must be 1-4 '
            .byte 'hex digits!'
            .byte $9B,$00
L3EA2       ldx #$0B
            stx IOCB0+ICCOM
            ldx #$00
            stx IOCB0+ICBLL
            stx IOCB0+ICBLH
            jmp CIOV
L3EB2       sta DSKUTL
            stx DSKUTL+1
L3EB6       ldx #$00
            lda (DSKUTL,X)
            beq L3EC7
            jsr L3EA2
L3EBF       inc DSKUTL
            bne L3EB6
            inc DSKUTL+1
            bne L3EB6
L3EC7       rts
L3EC8       pla
            sta DSKUTL
            pla
            sta DSKUTL+1
L3ECE       jsr L3EBF
            lda DSKUTL+1
            pha
            lda DSKUTL
            pha
            rts
L3ED8       jsr L3EFE
            cpy #$00
            bmi L3EF8
            cmp #$7B
            bcs L3EE9
            cmp #$61
            bcc L3EE9
            sbc #$20
L3EE9       pha
            cmp #$9B
            beq L3EF3
            jsr L3EA2
            lda #$9B
L3EF3       jsr L3EA2
            pla
            rts
L3EF8       jsr L3EA2
            jmp L2D10
L3EFE       jsr L3F1E
            jsr L1B46
            .byte $04,$03,$1B,$3F
            jsr L1B48
            bvs L3F0D
L3F0D       brk
            .byte $07
            brk
            brk
            pha
            tya
            pha
            jsr L3F1E
            pla
            tay
            pla
            rts
            .byte $4B,$3A,$9B
L3F1E       jsr L1B48
            bvs L3F23
L3F23       brk
            .byte $0C
            brk
            brk
            rts
L3F28       lda L29A7
L3F2B       clc
L3F2C       sta DUNIT
            lda #$02
            sta L29AB
            php
L3F35       ldx L29AD
            inx
            plp
            php
            jsr L0769
            bpl L3F4D
            cmp #$80
            beq L3F49
            dec L29AB
            bpl L3F35
L3F49       plp
            jmp L4136
L3F4D       plp
            rts
L3F4F       ldx L29A7
            lda IOCB0+ICCOM,X
            cmp #$07
            beq L3F9D
            lda L2979
            cmp #$30
            bcs L3F9E
            ldy IOCB0+ICBLL,X
            cpy #$14
            bcc L3F75
            dec IOCB0+ICBLL,X
            ldy #$E8
L3F6C       lda L289F,Y
            sta L289E,Y
            iny
            bne L3F6C
L3F75       lda L3FB0
            eor #$17
            sta L3FB0
            sta COLCRS
            lda L3FAF
            eor #$BB
            sta L3FAF
            cmp #$9B
            beq L3F9A
            lda L298A
            cmp #$9B
            bne L3F97
            lda #$20
            sta L298A
L3F97       lda L3FAF
L3F9A       sta L298B
L3F9D       rts
L3F9E       lda #$9B
            cmp L3FAF
            beq L3F9D
            dec IOCB0+ICBAL,X
            inc IOCB0+ICBLL,X
            sta L2978
            rts
L3FAF       .byte $9B
L3FB0       ora L00AE,X
            .byte $A7
            and #$BD
            pha
            .byte $03
            ora IOCB0+ICBLH,X
            beq L401C
            lda L29AA
            bpl L3FD1
            lda #$4D
            ldx #$36
            jsr L3EB2
            jsr L3ED8
            ldx L29A8
            jsr L4357
L3FD1       ldx L29A8
            bne L3FDB
            jsr L3F4F
            ldx #$00
L3FDB       lda IOCB0,X
            bpl L3FF6
            ldx L1C6F
            lda #$08
            cpx #$41
            bne L3FEB
            lda #$09
L3FEB       ldx L29A8
            sta IOCB0+ICAX1,X
            jsr L43C9
            bmi L406E
L3FF6       ldx L29A8
            ldy L29A7
            lda IOCB0+ICBLL,Y
            sta IOCB0+ICBLL,X
            lda IOCB0+ICBLH,Y
            sta IOCB0+ICBLH,X
            lda IOCB0+ICBAL,Y
            sta IOCB0+ICBAL,X
            lda IOCB0+ICBAH,Y
            sta IOCB0+ICBAH,X
            lda #$0B
            sta IOCB0+ICCOM,X
            jsr L412F
L401C       ldx L29A7
            lda IOCB0+ICSTA,X
            cmp #$88
            beq L4071
            lda L29AA
            bpl L4049
            lda #$2B
            ldx #$43
            jsr L3EB2
            jsr L3ED8
            ldx L29A7
            jsr L4357
            jmp L4049
L403E       ldx L29A7
            sta IOCB0+ICCOM,X
            lda #$9B
            sta L3FAF
L4049       ldx L29A7
            lda #$00
            sta L298E
            lda L00DA
            ldy L00DB
            jsr L1B36
            lda L00DC
            sta IOCB0+ICBLL,X
            lda L00DD
            sta IOCB0+ICBLH,X
            jsr CIOV
            bpl L406B
            cpy #$88
            bne L406E
L406B       jmp L3FB1
L406E       jmp L4136
L4071       ldx L29A8
            beq L4098
            jsr L1B2C
            lda L441C
            beq L4098
            jsr L1B46
            brk
            and (DSKUTL+1,X)
            .byte $44
            jsr L1B46
            php
            .byte $03
            brk
            rol
            jsr L1B46
            brk
            .byte $0C
            brk
            brk
            lda #$00
            sta L441C
L4098       ldx L29A7
            jmp L1B2C
L409E       lda #$9F
            ldy #$27
            jsr L1B34
            lda #$05
            sta IOCB1+ICCOM
            lda #$20
            sta IOCB1+ICBLL
            lda #$00
            sta IOCB1+ICBLH
            sta L29A4
            jsr L412F
            lda L27A0
            cmp #$3A
            bcs L40C5
            cmp #$30
            bcs L410D
L40C5       beq L40CF
            lda L27A9
            cmp L1C73
            bne L40D2
L40CF       dec L29A4
L40D2       ldx L29AE
            ldy #$02
L40D7       lda L279F,Y
            cmp #$20
            beq L40E7
            sta L29B0,X
            inx
            iny
            cpy #$0A
            bcc L40D7
L40E7       lda #$2E
            sta L29B0,X
            inx
            ldy #$0A
L40EF       lda L279F,Y
            cmp #$20
            beq L40FF
            sta L29B0,X
            iny
            inx
            cpy #$0D
            bcc L40EF
L40FF       lda #$2E
            cmp L29AF,X
            bne L4107
            dex
L4107       lda #$00
            sta L29B0,X
            clc
L410D       rts
L410E       lda #$A2
            sta L00DE
            sta IOCB0+ICBAL
            lda #$27
            sta L00DF
            sta IOCB0+ICBAH
            lda #$05
            sta IOCB0+ICCOM
            ldx #$01
            stx IOCB0+ICBLH
            dex
            stx IOCB0+ICBLL
            ldy #$00
            sty L29A0
L412F       jsr CIOV
            tya
            bmi L4136
            rts
L4136       sty L00D4
            lda #$00
            sta L00D5
            jsr IFP
            jsr FASC
            ldy #$00
            lda (L00F3),Y
            sta L4163
            iny
            lda (L00F3),Y
            sta L4164
            iny
            lda (L00F3),Y
            and #$7F
            sta L4165
            jsr L442E
            .byte 'Error -- '
L4163       .byte '0'
L4164       .byte '0'
L4165       .byte '0'
            .byte $9B,$00
            ldy L27A2
            cpy #$9B
            bne L4172
            rts
L4170       clc
            bit BUFRFL
            ror L00E1
            jsr L4285
            sty L00D4
            sty L00D5
L417C       lda (L00DE),Y
            iny
            cmp #$47
            bcs L4196
            sbc #$2F
            bcc L4193
            cmp #$0A
            bit L00E1
            bpl L419F
            bcc L41CB
            cmp #$11
            bcs L41C9
L4193       sec
            adc #$2F
L4196       sty L29A0
            tay
            lda L00D4
            ldx L00D5
            rts
L419F       bcs L4193
            pha
            asl L00D4
            rol L00D5
            lda L00D4
            ldx L00D5
            asl L00D4
            rol L00D5
            asl L00D4
            rol L00D5
            clc
            adc L00D4
            sta L00D4
            pla
            php
            clc
            adc L00D4
            sta L00D4
            txa
            adc L00D5
            plp
            adc #$00
            sta L00D5
            jmp L417C
L41C9       sbc #$07
L41CB       asl L00D4
            rol L00D5
            asl L00D4
            rol L00D5
            asl L00D4
            rol L00D5
            asl L00D4
            rol L00D5
            ora L00D4
            sta L00D4
            jmp L417C
L41E2       lda #$00
            sta L441C
            jsr L410E
            beq L41EF
L41EC       jsr L4285
L41EF       lda (L00DE),Y
            iny
            cmp #$3F
            beq L41FA
            cmp #$2A
            bne L4201
L41FA       lda #$00
            sta L29A9
            beq L41EF
L4201       cmp #$9B
            beq L423F
            cmp #$2E
            beq L41EF
            cmp #$2F
            bcc L423F
            bne L41EF
L420F       lda (L00DE),Y
            cmp #$53
            bne L421A
            sta L1C73
            beq L4228
L421A       cmp #$58
            bne L4225
            lda #$80
            sta L29AA
            bmi L4228
L4225       sta L1C6F
L4228       dey
            lda #$00
            sta (L00DE),Y
            iny
            iny
            lda (L00DE),Y
            iny
            cmp #$2F
            beq L420F
            cmp #$2E
            bcc L423F
            cmp #$9B
            beq L423F
            dey
L423F       sty L29A0
            dey
            lda (L00DE),Y
            sta L27EF
            lda #$00
            sta (L00DE),Y
            tay
            lda (L00DE),Y
            cmp #$30
            bcc L4276
            cmp #$3A
            beq L4276
            iny
            bcs L4267
            tax
            lda #$3A
            cmp (L00DE),Y
            beq L427B
            dey
            sta (L00DE),Y
            txa
            bne L4278
L4267       lda (L00DE),Y
            beq L4276
            cmp #$3A
            beq L4280
            iny
            lda (L00DE),Y
            cmp #$3A
            beq L4280
L4276       lda #$3A
L4278       jsr L4295
L427B       lda #$44
            jsr L4295
L4280       ldy L00DE
            lda L00DF
            rts
L4285       clc
            lda L29A0
            adc L00DE
            sta L00DE
            lda #$00
            tay
            adc L00DF
            sta L00DF
            rts
L4295       ldy L00DE
            bne L429B
            dec L00DF
L429B       dec L00DE
            inc L29A0
            ldy #$00
            sta (L00DE),Y
L42A4       rts
L42A5       jsr L41EC
            jmp L42AE
L42AB       jsr L41E2
L42AE       sty IOCB1+ICBAL
            sta IOCB1+ICBAH
            ldy #$FF
L42B6       iny
            tax
            lda (L00DE),Y
            bne L42B6
            cpx #$3A
            beq L42A4
            jsr L442E
            .byte 'File name not allowe'
            .byte 'd!'
            .byte $9B,$00
L42DB       cmp #$3A
            bne L42E2
            lda L070B
L42E2       and #$0F
            ldx #$00
            stx DAUX2
            inx
            stx DAUX1
            ldx #$1F
            stx DBUFLO
            ldx #$29
            stx DBUFHI
            jsr L3F2B
            bmi L4327
            jmp L0B9A
L42FF       sty IOCB1+ICBAL
            sta IOCB1+ICBAH
            ldy #$00
            lda (L00DE),Y
            cmp #$44
            beq L4327
            jsr L442E
            .byte 'Not a disk file!'
            .byte $9B,$00
L4322       lda L29AA
            bmi L4328
L4327       rts
L4328       jsr L3EC8
            .byte 'Insert SOURCE disk, '
            .byte 'press '
            .byte $D2,$C5,$D4,$D5,$D2,$CE,$00
            jsr L3ED8
            bit L29AA
            bvs L4327
            ldx L29A7
L4357       ldy IOCB0+ICDNO,X
            sty L299F
            lda IOCB0+ICAX6,X
            beq L4382
            cmp #$03
            bcs L4382
L4366       sta L07C3,Y
            ldx #$0F
L436B       lda L0908,X
            sta L4383,X
            dex
            bpl L436B
            jsr L4393
            ldx #$0F
L4379       lda L4383,X
            sta L0908,X
            dex
            bpl L4379
L4382       rts
L4383       .byte $00,$00,$00,$00,$00,$00,$00,$00
            .byte $00,$00,$00,$00,$00,$00,$00,$00
L4393       ldx #$09
L4395       lda L0B25,X
            sta DCOMND,X
            dex
            bpl L4395
            ldx #$31
            stx DDEVIC
            ldx L299F
            stx DUNIT
            ldy L07C3,X
            lda L07CB,X
            jmp L0B2F
L43B2       sta IOCB2+ICCOM
            lda #$B0
            ldx #$29
            sta IOCB2+ICBAL
            stx IOCB2+ICBAH
            jsr L4400
            ldx #$10
L43C4       lda #$06
            sta IOCB0+ICAX1,X
L43C9       lda #$00
            sta IOCB0+ICAX2,X
            sta IOCB0+ICAX6,X
            lda #$03
            jsr L1B2E
            bpl L43DB
            jmp L4136
L43DB       ldy DUNIT
            lda L07C3,Y
            sta IOCB0+ICAX6,X
            rts
L43E5       jsr L4400
            lda (L00DE),Y
            bne L43FF
            sta L29A9
            sta L29B2,Y
            lda #$2A
            sta L29B0,Y
            sta L29B1,Y
            lda #$9B
            sta L29B2,Y
L43FF       rts
L4400       ldy #$FF
L4402       iny
            lda (L00DE),Y
            sta L29B0,Y
            bne L4402
L440A       dey
            lda L29B0,Y
            cmp #$3A
            beq L4416
            cmp #$3E
            bne L440A
L4416       iny
            sty L29AE
            rts
            .byte 'D'
L441C       .byte $00
            .byte ':'
            .byte $60
            .byte 'OS.SYS'
L4425       .byte ',DOS.SYS'
            .byte $00
L442E       pla
            sta DSKUTL
            pla
            sta DSKUTL+1
            jsr L3EBF
            jmp L2D10
;
         
