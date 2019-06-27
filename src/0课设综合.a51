
		ORG 0000H         ;���������
        AJMP MAIN
        ORG 0003H         ;�ⲿ�ж�0
        AJMP ERR_FLASH
        ORG 000BH         ;��ʱ��0
        AJMP TIMER0
        ORG 0013H         ;�ⲿ�ж�1
        AJMP FLOW_LIGHT
        ORG 001BH         ;��ʱ��1
        AJMP TIME1
        ORG 0030H
MAIN:
        SETB EA           ;ȫ���ж�����
        SETB EX0          ;�ⲿ�ж�0�ж�����
        SETB EX1          ;�ⲿ�ж�1�ж�����
        SETB PT0          ;��ʱ��0�������ȼ�
        CLR PT1           ;��ʱ��1�������ȼ�
        CLR PX0           ;���ж�0�������ȼ�
        CLR PX1           ;���ж�1�������ȼ�
        
;��������������������������˸����1�Ρ�������������������
        LCALL DLY4
        MOV R1,#05H       ;��ʱ
SHOW0:
        MOV R5,#0CEH      ;��ֵP    
        MOV A,R5
        LCALL TUBE
        SETB P0.0
        LCALL DLY3
        CLR P0.0
        
        MOV R5,#76H       ;��ֵY 
        MOV A,R5
        LCALL TUBE
        SETB P0.1
        LCALL DLY3
        CLR P0.1
        
        MOV R5,#0EEH      ;��ֵA 
        MOV A,R5
        LCALL TUBE
        SETB P0.2
        LCALL DLY3
        CLR P0.2
        
        MOV R5,#0FCH      ;��ֵO
        MOV A,R5
        LCALL TUBE
        SETB P0.3
        LCALL DLY3
        CLR P0.3
        
        JNB F0,SHOW0
        CLR F0
        DJNZ R1,SHOW0
        MOV R1,#03H
        MOV P0,#00H        ;������ܵ�

;�����������������������ݼ�ֵ�ж�ѡ���ܡ������������������� 
        LCALL SCAN        ;ɨ�����
        CJNE R0,#0E7H,COM1 
        AJMP CHECK1       ;����Ϊ���½ǵ�һ����ѡ��CHECK1�������ʾ���ֹ���
COM1:
        CJNE R0,#0EBH,COM2;
        AJMP CHECK2       ;����Ϊ���½Ǵ����ҵڶ�����ѡ��CHECK2����������ӦLED��������
COM2:
        CJNE R0,#0EDH,MAIN;��Ϊ��3�������򷵻�����������ɨ��
        AJMP ALARM  
        


;===============����1���������ʾ��ֵ===============
CHECK1: 
        LCALL SCAN
        ;LCALL ALARM        
        MOV A,#00H
        MOV R1,#00H
NEXT1:  
        MOV A,R1
        INC A             ;A��������ֱ����R0��ȲŲ���ѭ��������AΪ��ֵ��R1Ϊ������ֵ
        MOV R1,A          
        MOV DPTR,#TABLE1  ;װ���ֵ��ͷ
        MOVC A,@A+DPTR    ;����ֵ���ֵ��Ƚ�
        CLR CY            ;��λ��־CY��0
        SUBB A,R0         ;(A)<-(A)-(R0)-(CY)
        JNZ NEXT1         ;A������0��ѭ�����
NOW:    
        MOV R3,#08H       ;R3��λ��0�����ƴ�������ѭ��
        MOV DPTR,#TABLE2  ;װ������ܱ�ͷ
        MOV A,R1          ;��������ֵ����A
        MOVC A,@A+DPTR    ;����ֵ������ܱ�Ƚϲ��������ֵ����A
        LCALL TUBE        ;���ô������ݸ�����ܹ����ӳ���
        SETB P0.0         ;������һ�������
        SETB P0.3
        LCALL DLY3
        ;CLR P0.0         ;���������Ϊ����һ��
        AJMP CHECK1       ;����CHECK1ѭ��ɨ��
        
;===============����2����������LED����ʾ===============
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


;===============����3���ⲿ�ж�0�������ERR-��˸3��===============
ERR_FLASH:
        LCALL DLY4
        MOV R0,#03H       ;��˸����
        MOV R1,#05H
        MOV R2,#4
        MOV R3,#0
        MOV DPTR,#TABLE4
SHOW:
        MOV A,R3
        MOVC A,@A+DPTR       ;���     
        LCALL TUBE
SHU0:   CJNE R3,#0,SHU1      ;�ж��ǵ�1�����������1�������
        SETB P0.0
        LCALL DLY3
        CLR P0.0
        AJMP CMPR2
SHU1:   CJNE R3,#1,SHU2      ;�ж��ǵ�2�����������2�������
        SETB P0.1
        LCALL DLY3
        CLR P0.1
        AJMP CMPR2
SHU2:   CJNE R3,#2,SHU3      ;�ж��ǵ�3�����������3�������
        SETB P0.2
        LCALL DLY3
        CLR P0.2
        AJMP CMPR2
SHU3:   CJNE R3,#3,CMPR2     ;�ж��ǵ�4�����������4�������
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
        MOV P0,#00H        ;������ܵ�
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

;===============����4���ⲿ�ж�1��LED��ʾ�����(�õ��˶�ʱ�����ܹ���ʱԼ16s��===============
FLOW_LIGHT:
        LCALL DLY4        ;���ö�ʱ����ʱ�ӳ���
        MOV R3,#80        ;������80��
        MOV A,#7FH        ;���ó�ʼֵ��ߵ�һ������

RUN:
        MOV P0,A
        JNB F0,RUN        ;��ʱδ��������ɵ���ԭ���ĵ�
        CLR F0
        RR A              ;ѭ������
        DJNZ R3,RUN
        CLR TR0
        MOV P0,#0FFH
        RETI

;===============����5�����ӹ��ܣ���ѭ���������ո�===============
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
     SWAP A ;����λ�͵���λ����
     ANL A,#0FH
     JNZ SING
     CLR TR1
     JMP D1
SING:
     DEC A
     MOV R6,A
     RL A
     MOV DPTR,#TABLE6
     MOVC A,@A+DPTR       ;���Ԥ�ø�λ
     MOV TH1,A
     MOV 51H,A
     MOV A,R6
     RL A                 ;�趨�ֽڼ��
     INC A
     MOVC A,@A+DPTR       ;���Ԥ�õ�λ
     MOV TL1,A
     MOV 50H,A
     SETB TR1             ;������ʱ��1
D1:
     LCALL DELAYMUSIC
     INC R1
     JMP NEXT
END0:
     CLR TR1
     JMP START0
TIME1:
     PUSH ACC             ;����ACCֵ
     PUSH PSW             ;����PSWֵ
     MOV TH1,51H
     MOV TL1,50H
     CPL P1.3             ;�����������
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
;===============����5����===============


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

;��������������������74HC595�����ݸ�����ܡ�������������������
TUBE:
        MOV P0,#00H
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
        DJNZ R7,TIMER0
        SETB F0
        RETI
;����������������������ʱ����������������������������
DLY3:
        MOV R6,#50
D1S1:
        MOV R5,#50
        DJNZ R5,$
        DJNZ R6,D1S1
        RET
;����������������������ʱ��0��ʱ0.2S��������������������
DLY4:
        MOV TMOD,#01H     ;ѡ����ģʽ1����ʱ��0 
        MOV TH0,#3CH      ;��ֵ���ֽ�
        MOV TL0,#0B0H     ;��ֵ���ֽ�
        MOV R7,#04H
        SETB ET0          ;��ʱ��T0�ж�����
        SETB TR0          ;������ʱ��T0
        CLR F0
        RET

;��������������������������̡�����ܡ�LED����ֵ��������������������
TABLE1: 
        DB 0E7H,0EBH,0EDH,0EEH,0D7H,0DBH,0DDH,0DEH,0B7H,0BBH,0BDH,0BEH,77H,7BH,7DH,7EH
        ;������̣�0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F
TABLE2: 
        DB 0FCH,60H,0DAH,0F2H,66H,0B6H,0BEH,0E0H,0FEH,0F6H,0FAH,3EH,1AH,7AH,9EH,8EH
        ;����ܣ�0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F
TABLE3: 
        DB 07FH,0BFH,0DFH,0EFH,0F7H,0FBH,0FDH,0FEH,07FH,0BFH,0DFH,0EFH,0F7H,0FBH,0FDH,0FEH     
        ;��ӦLED����0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7
TABLE4:
        DB 09EH,0EEH,0EEH,02H,0CEH,76H,0EEH,0FCH
        ;����ܣ�ERR-PYAO
        
;������
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
     ;���ո���ף�5 5 6 5 1 7 - | 5 5 6 5 2 1 | 5 5 5 3 1 7 6 | 4 4 3 1 2 1

;����
TABLE6:
     DW 64260,64400,64524,64580 
     DW 64684,64777,64820,64898
     DW 64968,65030,65058,65110
     DW 65157,65178,65217
     ;��5����6����7����1
     ;��2����3����4����5
     ;��6����7����1����2
     ;��3����4����5
     
     END
