        ORG 0000H         ;主程序入口
        AJMP MAIN
        ORG 0003H         ;外部中断0
        AJMP ERR_FLASH
        ORG 00BH          ;定时器0溢出
        AJMP TIMER0
        ORG 0013H         ;外部中断0
        AJMP FLOW_LIGHT
        ORG 0030H
MAIN:
        SETB EA           ;全局中断允许
        SETB EX0          ;外部中断0中断允许
        SETB EX1          ;外部中断1中断允许
        SETB PT0          ;定时器0：高优先级
        CLR PX0           ;外中断0：低优先级
        CLR PX1           ;外中断1：低优先级
		LCALL SCAN        ;扫描键盘
		CJNE R0,#0E7H,COM 
		AJMP CHECK1       ;按键为左下角第一个则选择CHECK1数码管显示数字功能
COM:
		CJNE R0,#0EBH,MAIN;不为这两个按键则返回主程序重新扫描
		AJMP CHECK2		  ;按键为左下角从左到右第二个则选择CHECK2按键控制相应LED灯亮功能

;===============功能1：数码管显示数值===============
;——————————将键值转换成数码管码值——————————
CHECK1: 
        LCALL SCAN
		MOV A,#00H
        MOV R1,#00H
NEXT1:  
        MOV A,R1
        INC A             ;A不断增加直到与R0相等才不再循环，最终A为键值，R5为按键数值
        MOV R1,A          
        MOV DPTR,#TABLE1  ;装入键值表头
        MOVC A,@A+DPTR    ;按键值与键值表比较
        CLR CY            ;进位标志CY清0
        SUBB A,R0         ;(A)<-(A)-(R0)-(CY)
        JNZ NEXT1         ;A不等于0则循环查表
NOW:    
        MOV P0,#01H       ;
        MOV R3,#0FH       ;R3高位置0，控制串行输入循环
        MOV DPTR,#TABLE2  ;装入数码管表头
        MOV A,R1          ;将按键数值存入A
        MOVC A,@A+DPTR    ;按键值与数码管表比较并将数码管值存入A

;延时1+2*20=41US
DLY1:   
        MOV R6,#20H
DLY2:   
        DJNZ R6,DLY2

;——————————SN74HC595操作——————————
LOCK:   
        CPL P0.4          ;P0.4位位取反
        JB P0.4,NEXT2     ;P0.4=1,则跳至NEXT2
        RL A              ;A左移，即A*2
        MOV C,ACC.7       ;把A的第8位给74HC595的串行输入端P0.7
        MOV P0.7,C
NEXT2:  
        DJNZ R3,DLY1      ;R3自减不为0则循环向P0.7输出
        SETB P0.5         ;P0.5置1
        CLR P0.5          ;P0.5清0
		AJMP CHECK1       ;返回CHECK1循环扫描
		
;===============功能2：按键控制LED灯显示===============
;——————————将键值传至LED——————————
CHECK2: 
        LCALL SCAN
		MOV A,#00H
        MOV R2,#00H
NEXT3:  
        MOV A,R2
        INC A
        MOV R2,A          ;将符合的键值暂存入R2
        MOV DPTR,#TABLE1  ;装入键值表头
        MOVC A,@A+DPTR    ;按键值与键值表比较
        CLR CY            ;进位标志CY清0
        SUBB A,R0         ;(A)<-(A)-(R0)-(CY)
        JNZ NEXT3         ;A不等于0则循环查表
NOW1:   
        MOV DPTR,#TABLE3  ;装入LED表头
        MOV A,R2          ;将键值存入A
        MOVC A,@A+DPTR    ;按键值与数码管表比较
        MOV P0,A          ;符合的键值存入P0点亮LED灯
        AJMP CHECK2       ;返回CHECK2循环扫描


;===============功能3：外部中断0，数码管err-闪烁3次===============
ERR_FLASH:
        LCALL DLY4
        MOV R0,#03H       ;闪烁次数
        MOV R1,#05H
SHOW:
        MOV R5,#9EH       ;赋值E     
        MOV A,R5
        LCALL TUBE
        SETB P0.0
        LCALL DLY3
        CLR P0.0
        
        MOV R5,#08CH      ;赋值r 
        MOV A,R5
        LCALL TUBE
        SETB P0.1
        LCALL DLY3
        CLR P0.1
        
        MOV R5,#08CH      ;赋值r 
        MOV A,R5
        LCALL TUBE
        SETB P0.2
        LCALL DLY3
        CLR P0.2
        
        MOV R5,#02H       ;赋值-
        MOV A,R5
        LCALL TUBE
        SETB P0.3
        LCALL DLY3
        CLR P0.3
        
        JNB F0,SHOW
        CLR F0
        DJNZ R1,SHOW
        MOV R1,#03H
        MOV P0,#00H        ;灭数码管灯
BLANK:
        JNB F0,BLANK
        CLR F0
        DJNZ R1,BLANK
        MOV R1,#05H
        DJNZ R0,SHOW        
        RETI

;===============功能4：外部中断1，LED演示走马灯===============
FLOW_LIGHT:
        LCALL DLY4
        MOV R3,#80        ;共右移80次
        MOV A,#07FH       ;设置初始值左边第一个灯亮

RUN:                                                                                                         
        MOV P0,A
        JNB F0,RUN
        CLR F0
        RR A              ;循环右移
        DJNZ R3,RUN
        CLR TR0
        MOV P0,#0FFH
        RETI

;===============反极法扫描键盘函数===============
SCAN: 
        NOP
;——————————列查询——————————
KEYC:   
        MOV P2,#0FH       ;按键高四位即行清0
        MOV A,P2
        ANL A,#0FH        ;累加器A高四位即行清0
        CJNE A,#0FH,KC1   ;判断是否按下按键，是则跳至KC1存值，否则再次扫描
        AJMP KEYC
KC1:    
        LCALL DLY3        ;调用延时子程序
        MOV A,P2          ;将键值存入A
        ANL A,#0FH        ;累加器A高四位即行再次清0
        CJNE A,#0FH,KC2   ;再次判断是否按下按键，是则跳至KC2存值，否则再次扫描
        AJMP KEYC
KC2:    
        MOV R0,A          ;将列键值A存入R0
;——————————行查询——————————
KEYR:   
        MOV P2,#0F0H      ;按键低四位即列清0
        MOV A,P2
        ANL A,#0F0H       ;累加器A低四位即列清0
        CJNE A,#0F0H,KR1
        AJMP KEYR
KR1:    
        LCALL DLY3
        MOV A,P2
        ANL A,#0F0H
        CJNE A,#0F0H,KR2
        AJMP KEYR
KR2:    
        ORL A,R0          
        MOV R0,A          ;将行键值A与原R0或，存入R0包含行与列
        RET
;===============扫描键盘结束===============

;——————————4个数码管显示——————————
TUBE:
        MOV R6,#00H
        MOV P0,R6 
        MOV R4,#08H
        CLR P0.6
PUT_IN:
        RRC A             ;带进位累加器循环右移
        MOV P0.7,C                                                
        SETB P0.4
        CLR P0.4
        DJNZ R4,PUT_IN                                        
        AJMP PUT_OUT
PUT_OUT:
        SETB P0.5
        CLR P0.5
        RET
;——————————定时器0中断——————————
TIMER0:
        MOV TMOD,#01H
        MOV TH0,#3CH
        MOV TL0,#0B0H
        DJNZ R7,RTI
        MOV R7,#02H
        SETB F0
RTI:
        RETI
;——————————延时消除抖动——————————
DLY3:
        MOV R6,#50
D1S1:
        MOV R5,#50
        DJNZ R5,$
        DJNZ R6,D1S1
        RET
;——————————延时0.1S——————————
DLY4:
        MOV TMOD,#01H     ;选择工作模式1，定时器0 自动重装初值的8位定时器
        MOV TH0,#3CH      ;初值高字节
        MOV TL0,#0B0H     ;初值低字节  
        SETB ET0          ;定时器T0中断允许
        SETB TR0          ;启动定时器T0
        CLR F0
        MOV R7,#02H
        RET

;——————————矩阵键盘、数码管、LED灯码值表——————————
TABLE1: 
        DB 0E7H,0EBH,0EDH,0EEH,0D7H,0DBH,0DDH,0DEH,0B7H,0BBH,0BDH,0BEH,77H,7BH,7DH,7EH
		;矩阵键盘：0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F
TABLE2: 
        DB 3FH,06H,5BH,4FH,66H,6DH,7DH,07H,7FH,6FH,05FH,07CH,039H,05EH,079H,071H
        ;数码管：0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F
TABLE3: 
        DB 07FH,0BFH,0DFH,0EFH,0F7H,0FBH,0FDH,0FEH,07FH,0BFH,0DFH,0EFH,0F7H,0FBH,0FDH,0FEH     
		;对应LED键字0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7
        END