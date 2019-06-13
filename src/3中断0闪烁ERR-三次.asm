ORG 0000H
	AJMP MAIN
	ORG 000BH		;��ʱ�����
	AJMP TIMER
	ORG 0003H		;�ⲿ�ж�0
	AJMP ERROR
	ORG 0030H
MAIN:
	SETB EA			;ȫ���ж�
	SETB EX0		;�ⲿ�ж�0�ж�
	SETB EX1		;�ⲿ�ж�1�ж�
	SETB PT0		;��ʱ��0�������ȼ�
	CLR PX0			;���ж�0�������ȼ�
	CLR PX1			;���ж�1�������ȼ�
	NOP
	
;=============================================== �������ʾ
TUBE:
	MOV R6,#00H
	MOV P0,R6 
	MOV R4,#08H
	CLR P0.6

PUT_IN:
	RRC A								;����λ�ۼ���ѭ������
	MOV P0.7,C						
	SETB P0.4
	CLR P0.4
	DJNZ R4,PUT_IN					
	AJMP PUT_OUT
PUT_OUT:
	SETB P0.5
	CLR P0.5
	RET
;=============================================	��ʱ��������
DELAYS:
	MOV	R6,#50
D1S1:
	MOV R5,#50
	DJNZ R5,$
	DJNZ R6,D1S1
	RET
;==================================================	����ʱ
DELAYX:
	MOV	R6,#0FFH
D1X1:
	MOV R5,#0FFH
	DJNZ R5,$
	DJNZ R6,D1X1
	RET
;==============================================	��ʱ0.1s
DELAY:
	MOV	TMOD,#01H	;ѡ����ģʽ1����ʱ��0 �Զ���װ��ֵ��8λ��ʱ��
	MOV	TH0,#3CH	;��ֵ���ֽ�
	MOV	TL0,#0B0H	;��ֵ���ֽ�  
	SETB ET0		;��ʱ��T0�ж�����
	SETB TR0		;������ʱ��T0
	CLR F0
	MOV R7,#02H
	RET
;=============================================== ��ʱ���ж�
TIMER:
	MOV	TMOD,#01H
	MOV	TH0,#3CH
	MOV	TL0,#0B0H
	DJNZ R7,RTI
	MOV R7,#02H
	SETB F0
RTI:
	RETI

;====================================�ⲿ�ж�0���������˸Err-
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