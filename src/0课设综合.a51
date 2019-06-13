        ORG 0000H         ;���������
        AJMP MAIN
        ORG 0003H         ;�ⲿ�ж�0
        AJMP ERR_FLASH
        ORG 00BH          ;��ʱ��0���
        AJMP TIMER0
        ORG 0013H         ;�ⲿ�ж�0
        AJMP FLOW_LIGHT
        ORG 0030H
MAIN:
        SETB EA           ;ȫ���ж�����
        SETB EX0          ;�ⲿ�ж�0�ж�����
        SETB EX1          ;�ⲿ�ж�1�ж�����
        SETB PT0          ;��ʱ��0�������ȼ�
        CLR PX0           ;���ж�0�������ȼ�
        CLR PX1           ;���ж�1�������ȼ�
		LCALL SCAN        ;ɨ�����
		CJNE R0,#0E7H,COM 
		AJMP CHECK1       ;����Ϊ���½ǵ�һ����ѡ��CHECK1�������ʾ���ֹ���
COM:
		CJNE R0,#0EBH,MAIN;��Ϊ�����������򷵻�����������ɨ��
		AJMP CHECK2		  ;����Ϊ���½Ǵ����ҵڶ�����ѡ��CHECK2����������ӦLED��������

;===============����1���������ʾ��ֵ===============
;������������������������ֵת�����������ֵ��������������������
CHECK1: 
        LCALL SCAN
		MOV A,#00H
        MOV R1,#00H
NEXT1:  
        MOV A,R1
        INC A             ;A��������ֱ����R0��ȲŲ���ѭ��������AΪ��ֵ��R5Ϊ������ֵ
        MOV R1,A          
        MOV DPTR,#TABLE1  ;װ���ֵ��ͷ
        MOVC A,@A+DPTR    ;����ֵ���ֵ��Ƚ�
        CLR CY            ;��λ��־CY��0
        SUBB A,R0         ;(A)<-(A)-(R0)-(CY)
        JNZ NEXT1         ;A������0��ѭ�����
NOW:    
        MOV P0,#01H       ;
        MOV R3,#0FH       ;R3��λ��0�����ƴ�������ѭ��
        MOV DPTR,#TABLE2  ;װ������ܱ�ͷ
        MOV A,R1          ;��������ֵ����A
        MOVC A,@A+DPTR    ;����ֵ������ܱ�Ƚϲ��������ֵ����A

;��ʱ1+2*20=41US
DLY1:   
        MOV R6,#20H
DLY2:   
        DJNZ R6,DLY2

;��������������������SN74HC595������������������������
LOCK:   
        CPL P0.4          ;P0.4λλȡ��
        JB P0.4,NEXT2     ;P0.4=1,������NEXT2
        RL A              ;A���ƣ���A*2
        MOV C,ACC.7       ;��A�ĵ�8λ��74HC595�Ĵ��������P0.7
        MOV P0.7,C
NEXT2:  
        DJNZ R3,DLY1      ;R3�Լ���Ϊ0��ѭ����P0.7���
        SETB P0.5         ;P0.5��1
        CLR P0.5          ;P0.5��0
		AJMP CHECK1       ;����CHECK1ѭ��ɨ��
		
;===============����2����������LED����ʾ===============
;������������������������ֵ����LED��������������������
CHECK2: 
        LCALL SCAN
		MOV A,#00H
        MOV R2,#00H
NEXT3:  
        MOV A,R2
        INC A
        MOV R2,A          ;�����ϵļ�ֵ�ݴ���R2
        MOV DPTR,#TABLE1  ;װ���ֵ��ͷ
        MOVC A,@A+DPTR    ;����ֵ���ֵ��Ƚ�
        CLR CY            ;��λ��־CY��0
        SUBB A,R0         ;(A)<-(A)-(R0)-(CY)
        JNZ NEXT3         ;A������0��ѭ�����
NOW1:   
        MOV DPTR,#TABLE3  ;װ��LED��ͷ
        MOV A,R2          ;����ֵ����A
        MOVC A,@A+DPTR    ;����ֵ������ܱ�Ƚ�
        MOV P0,A          ;���ϵļ�ֵ����P0����LED��
        AJMP CHECK2       ;����CHECK2ѭ��ɨ��


;===============����3���ⲿ�ж�0�������err-��˸3��===============
ERR_FLASH:
        LCALL DLY4
        MOV R0,#03H       ;��˸����
        MOV R1,#05H
SHOW:
        MOV R5,#9EH       ;��ֵE     
        MOV A,R5
        LCALL TUBE
        SETB P0.0
        LCALL DLY3
        CLR P0.0
        
        MOV R5,#08CH      ;��ֵr 
        MOV A,R5
        LCALL TUBE
        SETB P0.1
        LCALL DLY3
        CLR P0.1
        
        MOV R5,#08CH      ;��ֵr 
        MOV A,R5
        LCALL TUBE
        SETB P0.2
        LCALL DLY3
        CLR P0.2
        
        MOV R5,#02H       ;��ֵ-
        MOV A,R5
        LCALL TUBE
        SETB P0.3
        LCALL DLY3
        CLR P0.3
        
        JNB F0,SHOW
        CLR F0
        DJNZ R1,SHOW
        MOV R1,#03H
        MOV P0,#00H        ;������ܵ�
BLANK:
        JNB F0,BLANK
        CLR F0
        DJNZ R1,BLANK
        MOV R1,#05H
        DJNZ R0,SHOW        
        RETI

;===============����4���ⲿ�ж�1��LED��ʾ�����===============
FLOW_LIGHT:
        LCALL DLY4
        MOV R3,#80        ;������80��
        MOV A,#07FH       ;���ó�ʼֵ��ߵ�һ������

RUN:                                                                                                         
        MOV P0,A
        JNB F0,RUN
        CLR F0
        RR A              ;ѭ������
        DJNZ R3,RUN
        CLR TR0
        MOV P0,#0FFH
        RETI

;===============������ɨ����̺���===============
SCAN: 
        NOP
;���������������������в�ѯ��������������������
KEYC:   
        MOV P2,#0FH       ;��������λ������0
        MOV A,P2
        ANL A,#0FH        ;�ۼ���A����λ������0
        CJNE A,#0FH,KC1   ;�ж��Ƿ��°�������������KC1��ֵ�������ٴ�ɨ��
        AJMP KEYC
KC1:    
        LCALL DLY3        ;������ʱ�ӳ���
        MOV A,P2          ;����ֵ����A
        ANL A,#0FH        ;�ۼ���A����λ�����ٴ���0
        CJNE A,#0FH,KC2   ;�ٴ��ж��Ƿ��°�������������KC2��ֵ�������ٴ�ɨ��
        AJMP KEYC
KC2:    
        MOV R0,A          ;���м�ֵA����R0
;���������������������в�ѯ��������������������
KEYR:   
        MOV P2,#0F0H      ;��������λ������0
        MOV A,P2
        ANL A,#0F0H       ;�ۼ���A����λ������0
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
        MOV R0,A          ;���м�ֵA��ԭR0�򣬴���R0����������
        RET
;===============ɨ����̽���===============

;��������������������4���������ʾ��������������������
TUBE:
        MOV R6,#00H
        MOV P0,R6 
        MOV R4,#08H
        CLR P0.6
PUT_IN:
        RRC A             ;����λ�ۼ���ѭ������
        MOV P0.7,C                                                
        SETB P0.4
        CLR P0.4
        DJNZ R4,PUT_IN                                        
        AJMP PUT_OUT
PUT_OUT:
        SETB P0.5
        CLR P0.5
        RET
;����������������������ʱ��0�жϡ�������������������
TIMER0:
        MOV TMOD,#01H
        MOV TH0,#3CH
        MOV TL0,#0B0H
        DJNZ R7,RTI
        MOV R7,#02H
        SETB F0
RTI:
        RETI
;����������������������ʱ����������������������������
DLY3:
        MOV R6,#50
D1S1:
        MOV R5,#50
        DJNZ R5,$
        DJNZ R6,D1S1
        RET
;����������������������ʱ0.1S��������������������
DLY4:
        MOV TMOD,#01H     ;ѡ����ģʽ1����ʱ��0 �Զ���װ��ֵ��8λ��ʱ��
        MOV TH0,#3CH      ;��ֵ���ֽ�
        MOV TL0,#0B0H     ;��ֵ���ֽ�  
        SETB ET0          ;��ʱ��T0�ж�����
        SETB TR0          ;������ʱ��T0
        CLR F0
        MOV R7,#02H
        RET

;��������������������������̡�����ܡ�LED����ֵ��������������������
TABLE1: 
        DB 0E7H,0EBH,0EDH,0EEH,0D7H,0DBH,0DDH,0DEH,0B7H,0BBH,0BDH,0BEH,77H,7BH,7DH,7EH
		;������̣�0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F
TABLE2: 
        DB 3FH,06H,5BH,4FH,66H,6DH,7DH,07H,7FH,6FH,05FH,07CH,039H,05EH,079H,071H
        ;����ܣ�0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F
TABLE3: 
        DB 07FH,0BFH,0DFH,0EFH,0F7H,0FBH,0FDH,0FEH,07FH,0BFH,0DFH,0EFH,0F7H,0FBH,0FDH,0FEH     
		;��ӦLED����0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7
        END