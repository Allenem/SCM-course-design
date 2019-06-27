
		ORG 0000H         ;主程序入口
        AJMP MAIN
        ORG 0003H         ;外部中断0
        AJMP ERR_FLASH
        ORG 000BH         ;定时器0
        AJMP TIMER0
        ORG 0013H         ;外部中断1
        AJMP FLOW_LIGHT
        ORG 001BH         ;定时器1
        AJMP TIME1
        ORG 0030H
MAIN:
        SETB EA           ;全局中断允许
        SETB EX0          ;外部中断0中断允许
        SETB EX1          ;外部中断1中断允许
        SETB PT0          ;定时器0：高优先级
        CLR PT1           ;定时器1：低优先级
        CLR PX0           ;外中断0：低优先级
        CLR PX1           ;外中断1：低优先级
        
;——————————开机闪烁作者1次——————————
        LCALL DLY4
        MOV R1,#05H       ;延时
SHOW0:
        MOV R5,#0CEH      ;赋值P    
        MOV A,R5
        LCALL TUBE
        SETB P0.0
        LCALL DLY3
        CLR P0.0
        
        MOV R5,#76H       ;赋值Y 
        MOV A,R5
        LCALL TUBE
        SETB P0.1
        LCALL DLY3
        CLR P0.1
        
        MOV R5,#0EEH      ;赋值A 
        MOV A,R5
        LCALL TUBE
        SETB P0.2
        LCALL DLY3
        CLR P0.2
        
        MOV R5,#0FCH      ;赋值O
        MOV A,R5
        LCALL TUBE
        SETB P0.3
        LCALL DLY3
        CLR P0.3
        
        JNB F0,SHOW0
        CLR F0
        DJNZ R1,SHOW0
        MOV R1,#03H
        MOV P0,#00H        ;灭数码管灯

;——————————根据键值判断选择功能—————————— 
        LCALL SCAN        ;扫描键盘
        CJNE R0,#0E7H,COM1 
        AJMP CHECK1       ;按键为左下角第一个则选择CHECK1数码管显示数字功能
COM1:
        CJNE R0,#0EBH,COM2;
        AJMP CHECK2       ;按键为左下角从左到右第二个则选择CHECK2按键控制相应LED灯亮功能
COM2:
        CJNE R0,#0EDH,MAIN;不为这3个按键则返回主程序重新扫描
        AJMP ALARM  
        


;===============功能1：数码管显示数值===============
CHECK1: 
        LCALL SCAN
        ;LCALL ALARM        
        MOV A,#00H
        MOV R1,#00H
NEXT1:  
        MOV A,R1
        INC A             ;A不断增加直到与R0相等才不再循环，最终A为键值，R1为按键数值
        MOV R1,A          
        MOV DPTR,#TABLE1  ;装入键值表头
        MOVC A,@A+DPTR    ;按键值与键值表比较
        CLR CY            ;进位标志CY清0
        SUBB A,R0         ;(A)<-(A)-(R0)-(CY)
        JNZ NEXT1         ;A不等于0则循环查表
NOW:    
        MOV R3,#08H       ;R3高位置0，控制串行输入循环
        MOV DPTR,#TABLE2  ;装入数码管表头
        MOV A,R1          ;将按键数值存入A
        MOVC A,@A+DPTR    ;按键值与数码管表比较并将数码管值存入A
        LCALL TUBE        ;调用传输数据给数码管功能子程序
        SETB P0.0         ;点亮第一个数码管
        SETB P0.3
        LCALL DLY3
        ;CLR P0.0         ;加上这句则为闪亮一下
        AJMP CHECK1       ;返回CHECK1循环扫描
        
;===============功能2：按键控制LED灯显示===============
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


;===============功能3：外部中断0，数码管ERR-闪烁3次===============
ERR_FLASH:
        LCALL DLY4
        MOV R0,#03H       ;闪烁次数
        MOV R1,#05H
        MOV R2,#4
        MOV R3,#0
        MOV DPTR,#TABLE4
SHOW:
        MOV A,R3
        MOVC A,@A+DPTR       ;查表     
        LCALL TUBE
SHU0:   CJNE R3,#0,SHU1      ;判断是第1个字则点亮第1个数码管
        SETB P0.0
        LCALL DLY3
        CLR P0.0
        AJMP CMPR2
SHU1:   CJNE R3,#1,SHU2      ;判断是第2个字则点亮第2个数码管
        SETB P0.1
        LCALL DLY3
        CLR P0.1
        AJMP CMPR2
SHU2:   CJNE R3,#2,SHU3      ;判断是第3个字则点亮第3个数码管
        SETB P0.2
        LCALL DLY3
        CLR P0.2
        AJMP CMPR2
SHU3:   CJNE R3,#3,CMPR2     ;判断是第4个字则点亮第4个数码管
        SETB P0.3
        LCALL DLY3
        CLR P0.3
CMPR2:  
        INC R3
        DJNZ R2,SHOW
        MOV R2,#4
        MOV R3,#0
        JNB F0,SHOW
        CLR F0
        MOV R2,#4
        MOV R3,#0
        DJNZ R1,SHOW
        MOV R1,#03H
        MOV P0,#00H        ;灭数码管灯
BLANK:
        JNB F0,BLANK
        CLR F0
        DJNZ R1,BLANK
        MOV R1,#05H
        MOV R2,#4
        MOV R3,#0
        DJNZ R0,SHOW
        CLR TR0        
        RETI

;===============功能4：外部中断1，LED演示走马灯(用到了定时器，总共用时约16s）===============
FLOW_LIGHT:
        LCALL DLY4        ;调用定时器计时子程序
        MOV R3,#80        ;共右移80次
        MOV A,#7FH        ;设置初始值左边第一个灯亮

RUN:
        MOV P0,A
        JNB F0,RUN        ;计时未完成则依旧点亮原来的灯
        CLR F0
        RR A              ;循环右移
        DJNZ R3,RUN
        CLR TR0
        MOV P0,#0FFH
        RETI

;===============功能5（附加功能）：循环播放生日歌===============
ALARM:
     MOV TMOD,#10H
     MOV IE,#88H
START0:
     MOV R1,#00H
NEXT:
     MOV A,R1
     MOV DPTR,#TABLE5
     MOVC A,@A+DPTR
     MOV R2,A 
     JZ END0
     ANL A,#0FH
     MOV R5,A
     MOV A,R2
     SWAP A ;高四位和低四位互换
     ANL A,#0FH
     JNZ SING
     CLR TR1
     JMP D1
SING:
     DEC A
     MOV R6,A
     RL A
     MOV DPTR,#TABLE6
     MOVC A,@A+DPTR       ;查表预置高位
     MOV TH1,A
     MOV 51H,A
     MOV A,R6
     RL A                 ;设定字节间隔
     INC A
     MOVC A,@A+DPTR       ;查表预置低位
     MOV TL1,A
     MOV 50H,A
     SETB TR1             ;启动定时器1
D1:
     LCALL DELAYMUSIC
     INC R1
     JMP NEXT
END0:
     CLR TR1
     JMP START0
TIME1:
     PUSH ACC             ;保护ACC值
     PUSH PSW             ;保护PSW值
     MOV TH1,51H
     MOV TL1,50H
     CPL P1.3             ;波形输出反相
     POP PSW
     POP ACC
     RETI
DELAYMUSIC:
     MOV R7,#02
D2:  
     MOV R4,#187
D3:  
     MOV R3,#248
     DJNZ R3,$
     DJNZ R4,D3
     DJNZ R7,D2
     DJNZ R5,DELAYMUSIC
     RET
;===============功能5结束===============


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

;——————————74HC595传数据给数码管——————————
TUBE:
        MOV P0,#00H
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
        DJNZ R7,TIMER0
        SETB F0
        RETI
;——————————延时消除抖动——————————
DLY3:
        MOV R6,#50
D1S1:
        MOV R5,#50
        DJNZ R5,$
        DJNZ R6,D1S1
        RET
;——————————定时器0延时0.2S——————————
DLY4:
        MOV TMOD,#01H     ;选择工作模式1，定时器0 
        MOV TH0,#3CH      ;初值高字节
        MOV TL0,#0B0H     ;初值低字节
        MOV R7,#04H
        SETB ET0          ;定时器T0中断允许
        SETB TR0          ;启动定时器T0
        CLR F0
        RET

;——————————矩阵键盘、数码管、LED灯码值表——————————
TABLE1: 
        DB 0E7H,0EBH,0EDH,0EEH,0D7H,0DBH,0DDH,0DEH,0B7H,0BBH,0BDH,0BEH,77H,7BH,7DH,7EH
        ;矩阵键盘：0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F
TABLE2: 
        DB 0FCH,60H,0DAH,0F2H,66H,0B6H,0BEH,0E0H,0FEH,0F6H,0FAH,3EH,1AH,7AH,9EH,8EH
        ;数码管：0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F
TABLE3: 
        DB 07FH,0BFH,0DFH,0EFH,0F7H,0FBH,0FDH,0FEH,07FH,0BFH,0DFH,0EFH,0F7H,0FBH,0FDH,0FEH     
        ;对应LED键字0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7
TABLE4:
        DB 09EH,0EEH,0EEH,02H,0CEH,76H,0EEH,0FCH
        ;数码管：ERR-PYAO
        
;歌曲表单
TABLE5:
     DB 82H,01H,81H,94H,84H,0B4H,0A4H,04H
     DB 82H,01H,81H,94H,84H,0C4H,0B4H,04H
     DB 82H,01H,81H,0F4H,0D4H,0B4H,0A4H,94H
     DB 0E2H,01H,0E1H,0D4H,0B4H,0C4H,0B4H

     DB 82H,01H,81H,94H,84H,0B4H,0A4H,04H
     DB 82H,01H,81H,94H,84H,0C4H,0B4H,04H
     DB 82H,01H,81H,0F4H,0D4H,0B4H,0A4H,94H
     DB 0E2H,01H,0E1H,0D4H,0B4H,0C4H,0B4H,04H
     DB 00H
     ;生日歌简谱：5 5 6 5 1 7 - | 5 5 6 5 2 1 | 5 5 5 3 1 7 6 | 4 4 3 1 2 1

;音调
TABLE6:
     DW 64260,64400,64524,64580 
     DW 64684,64777,64820,64898
     DW 64968,65030,65058,65110
     DW 65157,65178,65217
     ;低5，低6，低7，中1
     ;中2，中3，中4，中5
     ;中6，中7，高1，高2
     ;高3，高4，高5
     
     END
