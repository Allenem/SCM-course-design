;********************按键显示********************
        ORG 0000H
        AJMP MAIN 
        ORG 000BH
MAIN:   NOP

;—————————————————————————反极法扫描键盘—————————————————————————
;—————————————————————————按键列查询—————————————————————————
KEYC:   MOV P2,#0FH       ;按键高四位即行清0
        MOV A,P2
        ANL A,#0FH        ;累加器A高四位即行清0
        CJNE A,#0FH,KC1   ;判断是否按下按键，是则跳至KC1存值，否则再次扫描
        AJMP KEYC
KC1:    LCALL DLY         ;调用延时子程序
        MOV A,P2          ;将键值存入A
        ANL A,#0FH        ;累加器A高四位即行再次清0
        CJNE A,#0FH,KC2   ;判断是否按下按键，是则跳至KC2存值，否则再次扫描
        AJMP KEYC
KC2:    MOV R0,A          ;将列键值A存入R0

;—————————————————————————按键行查询—————————————————————————
KEYR:   MOV P2,#0F0H      ;按键低四位即列清0
        MOV A,P2
        ANL A,#0F0H       ;累加器A低四位即列清0
        CJNE A,#0F0H,KR1
        AJMP KEYR
KR1:    LCALL DLY
        MOV A,P2
        ANL A,#0F0H
        CJNE A,#0F0H,KR2
        AJMP KEYR
KR2:    ORL A,R0          
        MOV R0,A          ;将行键值A与原R0或，存入R0包含行与列
        AJMP CHECK

;—————————————————————————延时子程序1—————————————————————————
;1+30+2*150*30+2*30+2=9151US
DLY:    MOV R7,#30
DLY1:   MOV R6,#150
DLY2:   DJNZ R6,DLY2
        DJNZ R7,DLY1
        RET

;—————————————————————————将键值转换成数码管码值—————————————————————————
CHECK:  MOV A,#00H
        MOV R5,#00H
NEXT1:  MOV A,R5
        INC A             ;A不断增加直到与R0相等才不再循环，最终A为键值，R5为按键数值
        MOV R5,A          
        MOV DPTR,#TABLE1  ;装入键值表头
        MOVC A,@A+DPTR    ;按键值与键值表比较
        CLR CY            ;进位标志CY清0
        SUBB A,R0         ;(A)<-(A)-(R0)-(CY)
        JNZ NEXT1         ;A不等于0则循环查表
NOW:    MOV P0,#01H       ;
        MOV R3,#0FH       ;R3高位置0，控制串行输入循环
        MOV DPTR,#TABLE2  ;装入数码管表头
        MOV A,R5          ;将按键数值存入A
        MOVC A,@A+DPTR    ;按键值与数码管表比较并将数码管值存入A

;—————————————————————————延时2—————————————————————————
;1+2*20=41US
DLY3:   MOV R6,#20H
DLY4:   DJNZ R6,DLY4

;—————————————————————————SN74HC595操作—————————————————————————
LOCK:   CPL P0.4          ;P0.4位位取反
        JB P0.4,NEXT2     ;P0.4=1,则跳至NEXT2
        RL A              ;A左移，即A*2
        MOV C,ACC.7	      ;把A的第8位给74HC595的串行输入端P0.7
        MOV P0.7,C
NEXT2:  DJNZ R3,DLY3      ;R3自减不为0则循环向P0.7输出
        SETB P0.5         ;P0.5置1
        CLR P0.5          ;P0.5清0
        AJMP KEYC         ;循环按键列查询

;—————————————————————————键值表与数码管表—————————————————————————
;TABLE1: DB 00H
;        DB 0E7H,0D7H,0B7H,77H,0EBH,0DBH,0BBH,7BH,0EDH,0DDH,0BDH,7DH,0EEH,0DEH,0BEH,7EH
;        4X4矩阵键盘：0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F(左下到右上）
TABLE1: DB 0E7H,0EBH,0EDH,0EEH,0D7H,0DBH,0DDH,0DEH,0B7H,0BBH,0BDH,0BEH,77H,7BH,7DH,7EH
TABLE2: DB 3FH,06H,5BH,4FH,66H,6DH,7DH,07H,7FH,6FH,077H,07CH,039H,05EH,079H,071H
        ;数码管：0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F
END
