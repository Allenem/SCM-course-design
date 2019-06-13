;********************1中断走马灯********************
ExtInt1 EQU P3.3
ORG     0000H
JMP     MAIN                ;主程序入口
ORG     0013H
AJMP    INT1_SER            ;外部中断1服务子程序入口
ORG     001BH
AJMP    TIME1_SER           ;计时器T1服务子程序入口
ORG     0030H
MAIN:   MOV     SP,#60H     ;设置堆栈长度为60byte
        MOV     P0,#8FH
	    SETB    ET1         ;允许计时器T1溢出中断
	    SETB    ExtInt1     ;将p3.3即外部中断1置1
L10:    LCALL   INT1_INIT   ;调用外部中断1初始化子程序
	    LCALL   TIME1_INIT  ;调用计时器1初始化子程序
	    AJMP    L10

;—————————————————————————外部中断1初始化子程序-(课本p72）—————————————————————————
INT1_INIT:
        SETB    IT1          ;INT1中断触发方式为边沿触发
        SETB    EX1          ;外部中断1允许
        SETB    EA           ;全局中断允许
        CLR     TF1          ;溢出标志位清0
        CLR     TR1          ;T1清0，停止计时器T1
	    RET

;—————————————————————————定时器1初始化子程序-（课本P63）—————————————————————————
TIME1_INIT:
        MOV     TMOD,#90H   ;采用方式1，T1受INT1控制
	    MOV     TH1,#00H    ;预置初值高低位全为0
	    MOV     TL1,#00H       
	    SETB    ET1         ;定时器1中断允许
	    SETB    PT1         ;定时中断1优先置1
	    RET

;—————————————————————————中断1服务函数—————————————————————————
INT1_SER:
        MOV     R1,#00
		MOV     R2,#02
	    MOV     R3,#05        ;走马灯来回次数，一个来回记一次
START:  SETB    TR1           ;定时器1开始计数	   
NOT_FINISH:
        JB      TF1,NOT_FINISH;TF=1,则一直循环
	    JNB     ET1,K40	      ;ET1=0,定时器1中断不允许，则结束
        AJMP    START         ;定时器1中断允许，则再次计数
K40:
        CLR     EX1           ;外部中断1清0
        MOV     P0,#00
        RETI

;—————————————————————————定时器1服务函数—————————————————————————
TIME1_SER: 
        DJNZ    R2,RETURN     ;R1递增,R3递减一起控制循环次数
	    MOV     A,R1          
	    MOV     DPTR,#TABLE   ;表头
	    MOVC    A,@A+DPTR     ;按键值与led键值比较
	    MOV     P0,A          ;符合的键值存入P0点亮相应的LED灯
	    MOV     R2,#02        ;每两次循环溢出后才点亮后一盏LED灯，每个灯点亮时间60ms*2=0.12s
	    INC     R1
	    CJNE    R1,#14,RETURN ;R1不为14则退出子程序
	    MOV     R1,#00
	    DJNZ    R3,RETURN
	    CLR     ET1           ;定时器1中断不允许
RETURN: RETI                  ;从中断程序中返回
TABLE:  DB      07FH,0BFH,0DFH,0EFH,0F7H,0FBH,0FDH,0FEH,0FDH,0FBH,0F7H,0EFH,0DFH,0BFH
        ;对应led键字0,1,2,3,4,5,6,7,6,5,4,3,2,1
END	   