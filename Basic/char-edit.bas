10 REM CHARACTER EDIT BY JUSTIN BALDOCK 2022
20 REM HTTPS://GITHUB.COM/JUSTINBALDOCK/X16-SPRITEEDIT
30 GOSUB 60000: REM SETUP VARIABLES AND FUNCTIONS
40 GOSUB 41000: REM DRAW UI
50 GOSUB 30000: REM DRAW CHAR-SET

100 REM MAIN LOOP
110 REM GET STATUS
120 REM GET CURSOR AND UPDATE
130 GOSUB 3000: REM PROCESS KEYBOARD 
140 GOTO 100
150 END

3000 REM FUNCTION GET KEYBOARD AND PROCESS
3010 GET KP$: REM KP$= KEY PRESS
3020 REM PROCESS CURSOR KEYS
3030 IF KP$=CHR$(157) THEN CX=-1: CY=0: GOSUB 21000: REM LEFT
3040 IF KP$=CHR$(29) THEN CX=1: CY=0: GOSUB 21000: REM RIGHT
3050 IF KP$=CHR$(17) THEN CX=0: CY=1: GOSUB 21000: REM DOWN
3060 IF KP$=CHR$(145) THEN CX=0: CY=-1: GOSUB 21000: REM UP
3070 REM PROCESS 123 KEYS
3080 IF KP$=CHR$(49) THEN UI=1: GOSUB 20000: REM 1 KEY
3090 IF KP$=CHR$(50) THEN UI=2: GOSUB 20000: REM 2 KEY
3100 IF KP$=CHR$(51) THEN UI=3: GOSUB 20000: REM 3 KEY
3110 REM CONTROL KEYS
3120 IF KP$=CHR$(81) THEN END: REM Q KEY TO QUIT
3130 IF KP$=CHR$(83) THEN : REM S KEY TO SAVE
3140 IF KP$=CHR$(76) THEN : REM L KEY TO LOAD
3150 RETURN

20000 REM MANAGE UI SELECTION
20010 IF UI=1 THEN GOSUB 20100
20020 IF UI=2 THEN GOSUB 20300
20030 IF UI=3 THEN GOSUB 20500
20040 RETURN

20100 REM UPDATE UI = 1 = CHAR
20101 REM CURSOR IS ARRAY CC(0)=X CC(1)=Y
20110 REM SET CURSOR SPRITE
20120 X = (CC(0)*8+8): REM SCREEN X
20130 Y = (CC(1)*8+8): REM SCREEN Y
20140 VPOKE 1,CD+2,X: VPOKE 1,CD+3,0:REM X
20150 VPOKE 1,CD+4,Y: VPOKE 1,CD+5,0:REM Y 
20160 REM UPDATE BIT SELECTED
20170 BS = CC(0)+(CC(1)*7)
20180 RETURN

20300 REM UPDATE UI = 2 = FONT-SET
20301 REM CURSOR IS ARRAY FC(0)=X FC(1)=Y
20310 REM SET CURSOR SPRITE
20320 X = (FC(0)*8) + 8 : REM SCREEN X
20330 Y = (FC(1)*8) + 88: REM SCREEN Y
20340 VPOKE 1,CD+2,FN LB(X): VPOKE 1,CD+3,FN HB(X):REM X
20350 VPOKE 1,CD+4,FN LB(Y): VPOKE 1,CD+5,FN HB(Y):REM Y
20380 REM UPDATE CHAR SELECTED SO FUNCTIONS KNOW WHICH CHAR TO DRAW
20370 CS = FC(0)+(FC(1)*31)
20400 RETURN

20500 REM UPDATE UI = 3 = SCRATCH-SPACE

20700 REM UPDATE UI = 4 = COLOUR PAL

21000 REM MANAGE CURSOR MOVEMENT
21010 IF UI=1 THEN GOSUB 21100
21020 IF UI=2 THEN GOSUB 21300
21030 IF UI=3 THEN GOSUB 21500
21090 RETURN

21100 REM UPDATE CHAR BOX CURSOR
21110 

21300 REM UPDATE FONT-SET BOX CURSOR
21310 FC(0)=FC(0)+CX
21320 IF FC(0)<0 THEN FC(0)=0
21330 IF FC(0)>31 THEN FC(0)=31
21340 FC(1)=FC(1)+CY
21350 IF FC(1)<0 THEN FC(1)=0
21360 IF FC(1)>7 THEN FC(1)=7
21370 REM UPDATE SPRITE
21380 GOSUB 20300
21390 RETURN

21500 REM UDPATE SCRATCH-SPACE BOX CURSOR

30000 REM DRAW FONT-SET
30010 FOR Y = 0 TO 7
30020 FOR X = 0 TO 31
30030 VPOKE 0,$B02+(Y*$100)+(X*2),X+(31*Y)
30040 NEXT X
30050 NEXT Y
30100 RETURN

31000 REM DRAW CHAR
31010 REM DEFAULT FONT SET IS AT $F800
31020 NU=VPEEK(0,$F800+(CS*8)
31030 GOSUB 35000
31040 FOR X = 7 TO 0
31050 IF BY(X)=1 THEN VPOKE 0,$0802+(X*2),64
31060 NEXT X
31070 RETURN

33000 REM DRAW SCRATCH-SPACE

35000 REM CONVERT DEC TO BIN
35010 REM REQUIRES VALUE NU AND STORES 8-BITS IN ARRAY BY()
35020 BY(7)=INT(NU/128): NU=NU-(INT(NU/128)*128)
35030 BY(6)=INT(NU/64): NU=NU-(INT(NU/64)*64)
35040 BY(5)=INT(NU/32): NU=NU-(INT(NU/32)*32)
35050 BY(4)=INT(NU/16): NU=NU-(INT(NU/16)*16)
35060 BY(3)=INT(NU/8): NU=NU-(INT(NU/8)*8)
35070 BY(2)=INT(NU/4): NU=NU-(INT(NU/4)*4)
35080 BY(1)=INT(NU/2): NU=NU-(INT(NU/2)*2)
35090 BY(0)=INT(NU)
35100 RETURN

41000 REM DRAW MAIN SCREEN
41010 SCREEN($00)
41020 OPEN 1,8,2,"CHAR-EDIT-IF,SEQ,R": REM INTERFACE FILE CREATED BY PETISDRAW
41030 GET#1,D$: IF ST=64 THEN RETURN
41040 GET#1,D$: REM FIRST 2 BYTES ARE NOT USEFUL
41050 FOR Y=0 TO 29
41060 FOR X=0 TO 79
41070 GET#1,D$
41080 VPOKE 0,0+((Y*256)+X),ASC(D$)
41090 NEXT X
41100 NEXT Y 
41110 CLOSE 1
41120 RETURN

60000 REM VARIABLES
60005 REM WHICH UI BOX ARE WE IN?
60006 0=NONE, 1=CHAR, 2=FONT-SET, 3=SCRATCH, 4=PALETTE?
60010 LET UI = 0
60020 DIM CC(1):REM = CHAR BOX CURSOR X,Y, CC(0)=X CC(1)=Y
60030 DIM FC(1):REM = FONT BOX CURSOR X,Y FC(0)=X, FC(1)=Y
60040 DIM SC(1):REM = SCRATCH BOX CURSOR X,Y
60050 LET CD = $FC08: REM CD = CURSOR DATA
60060 LET CS = 0: REM CS = CHAR SELECTED IN FONT-SET BOX, 0-255
60070 LET BS = 0: REM BS = BIT SELECTED IN CHAR BOX 0-31
60080 DIM BY(7):REM USED TO CONVERT DEC TO BIN, STORES 8-BIT BYTE
60090 LET CX = 0: LET CY = 0: REM USED TO STORE DIRECTION CURSOR MOVES
60100 GOSUB 61000: REM CREATE CURSOR SPRITE
60500: 
60510 REM HIGHBYTE/HB FUNCTION, REQUIRES ADDRESS AD
60520 DEF FN HB(AD)=INT(AD/256)
60530 :
60540 REM LOWBYTE/LB FUNCTION, REQUIRES ADDRESS AD
60550 DEF FN LB(AD)=AD-256*INT(AD/256)
60560 :
60600 RETURN

61000 REM CURSOR SPRITE
61010 VPOKE 1,CD+0,%00000000: VPOKE 1,CD+1,%00000100: REM $8000
61020 VPOKE 1,CD+2,08: VPOKE 1,CD+3,00 :REM X
61030 VPOKE 1,CD+4,08: VPOKE 1,CD+5,00 :REM Y
61040 VPOKE 1,CD+6,%00001100: REM NO MASK, ON TOP ALL, NO FLIP
61050 VPOKE 1,CD+7,%00000000: REM 8X8 SPRITE WITH NO PAL OFFSET
61060 POKE $9F29,PEEK($9F29) OR %01000000: REM ENABLE SPRITES
61070 FOR I = 0 TO 31
61080 READ D
61090 VPOKE 0,$8000+I,D
61100 NEXT I
61200 RETURN

62000 REM CURSOR SPRITE DATA 8 BPP
62010 REM DATA 00,07,07,07,07,07,07,00
62020 REM DATA 07,00,00,00,00,00,00,07
62030 REM DATA 07,00,00,00,00,00,00,07
62040 REM DATA 07,00,00,00,00,00,00,07
62050 REM DATA 07,00,00,00,00,00,00,07
62060 REM DATA 07,00,00,00,00,00,00,07
62070 REM DATA 07,00,00,00,00,00,00,07 
62080 REM DATA 00,07,07,07,07,07,07,00

62100 REM CUSROR SPRITE DATA 4 BPP
62110 DATA $A7,$77,$77,$7A
62120 DATA $70,$00,$00,$07
62130 DATA $70,$00,$00,$07
62140 DATA $70,$00,$00,$07
62150 DATA $70,$00,$00,$07
62160 DATA $70,$00,$00,$07
62170 DATA $70,$00,$00,$07
62180 DATA $A7,$77,$77,$7A
