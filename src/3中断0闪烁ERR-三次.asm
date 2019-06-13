ORG 0000H
	AJMP MAIN
	ORG 000BH		;定时器溢出
	AJMP TIMER
	ORG 0003H		;外部中断0
	AJMP ERROR
	ORG 0030H
MAIN:
	SETB EA			;全局中断
	SETB EX0		;外部中断0中断
	SETB EX1		;外部中断1中断
	SETB PT0		;定时器0：高优先级
	CLR PX0			;外中断0：低优先级
	CLR PX1			;外中断1：低优先级
	NOP
	
;=============================================== 数码管显示
TUBE:
	MOV R6,#00H
	MOV P0,R6 
	MOV R4,#08H
	CLR P0.6

PUT_IN:
	RRC A								;带进位累加器循环右移
	MOV P0.7,C						
	SETB P0.4
	CLR P0.4
	DJNZ R4,PUT_IN					
	AJMP PUT_OUT
PUT_OUT:
	SETB P0.5
	CLR P0.5
	RET
;=============================================	延时消除抖动
DELAYS:
	MOV	R6,#50
D1S1:
	MOV R5,#50
	DJNZ R5,$
	DJNZ R6,D1S1
	RET
;==================================================	短延时
DELAYX:
	MOV	R6,#0FFH
D1X1:
	MOV R5,#0FFH
	DJNZ R5,$
	DJNZ R6,D1X1
	RET
;==============================================	延时0.1s
DELAY:
	MOV	TMOD,#01H	;选择工作模式1，定时器0 自动重装初值的8位定时器
	MOV	TH0,#3CH	;初值高字节
	MOV	TL0,#0B0H	;初值低字节  
	SETB ET0		;定时器T0中断允许
	SETB TR0		;启动定时器T0
	CLR F0
	MOV R7,#02H
	RET
;=============================================== 定时器中断
TIMER:
	MOV	TMOD,#01H
	MOV	TH0,#3CH
	MOV	TL0,#0B0H
	DJNZ R7,RTI
	MOV R7,#02H
	SETB F0
RTI:
	RETI

;====================================外部中断0，数码管闪烁Err-
ERROR:
	LCALL DELAY
	MOV	R0,#03H
	MOV	R1,#05H
SHOW:
	MOV R5,#9EH
	MOV A,R5
	LCALL TUBE
	SETB P0.0
	LCALL DELAYS
	CLR P0.0
	MOV R5,#0AH
	MOV A,R5
	LCALL TUBE
	SETB P0.1
	LCALL DELAYS
	CLR P0.1
	MOV R5,#0AH
	MOV A,R5
	LCALL TUBE
	SETB P0.2
	LCALL DELAYS
	CLR P0.2
	MOV R5,#02H
	MOV A,R5
	LCALL TUBE
	SETB P0.3
	LCALL DELAYS
	CLR P0.3
	JNB F0,SHOW
	CLR F0
	DJNZ R1,SHOW
	MOV	R1,#03H
	MOV P0,#00H	
BLANK:
	JNB F0,BLANK
	CLR F0
	DJNZ R1,BLANK
	MOV	R1,#05H
	DJNZ R0,SHOW	
	RETI
;==================================================
END