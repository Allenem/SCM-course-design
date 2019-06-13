;********************按键亮灯********************
org 0000H
        ajmp main 
        org 000bH

main:   nop

;—————————————————————————按键列查询—————————————————————————
keyc:   mov p2,#0FH       ;按键高四位即行清0
        mov a,p2
        anl a,#0FH        ;累加器a高四位即行清0
        cjne a,#0FH,kc1   ;判断是否按下按键，是则跳至kc1存值，否则再次扫描
        ajmp keyc
kc1:    lcall dly         ;调用延时子程序
        mov a,p2          ;将键值存入a
        anl a,#0FH        ;累加器a高四位即行再次清0
        cjne a,#0FH,kc2   ;判断是否按下按键，是则跳至kc2存值，否则再次扫描
        ajmp keyc
kc2:    mov r0,a          ;将列键值a存入r0

;—————————————————————————按键行查询—————————————————————————
keyr:   mov p2,#0F0H      ;按键低四位即列清0
        mov a,p2
        anl a,#0F0H       ;累加器a低四位即列清0
        cjne a,#0F0H,kr1
        ajmp keyr
kr1:    lcall dly
        mov a,p2
        anl a,#0F0H
        cjne a,#0F0H,kr2
        ajmp keyr
kr2:    orl a,r0          
        mov r0,a          ;将行键值a与原r0或，存入r0包含行与列
        ajmp check

;—————————————————————————延时子程序—————————————————————————
;1+30+2*150*30+2*30+2=9151us
dly:    mov r7,#30
dly1:   mov r6,#150
dly2:   djnz r6,dly2
        djnz r7,dly1
        ret

;—————————————————————————将键值传至led—————————————————————————
check:  mov a,#00H
        mov r5,#00H
next1:  mov a,r5
        inc a
        mov r5,a          ;将符合的键值暂存入r5
        mov dptr,#table1  ;装入键值表头
        movc a,@a+dptr    ;按键值与键值表比较
        clr cy            ;进位标志cy清0
        subb a,r0         ;(a)<-(a)-(r0)-(cy)
        jnz next1         ;a不等于0则循环查表
now:    mov dptr,#table3  ;装入led表头
        mov a,r5          ;将键值存入a
        movc a,@a+dptr    ;按键值与数码管表比较
        mov p0,a          ;符合的键值存入P0点亮LED灯
        ajmp keyc         ;循环按键列查询

;—————————————————————————键值表,led表—————————————————————————
;table1: db 00H
;        db 0E7H,0D7H,0B7H,77H,0EBH,0DBH,0BBH,7BH,0EDH,0DDH,0BDH,7DH,0EEH,0DEH,0BEH,7EH
;        4x4矩阵键盘：0,1,2,3,4,5,6,7,8,9,a,b,c,d,e,f(左下到右上）
table1: db 0E7H,0EBH,0EDH,0EEH,0D7H,0DBH,0DDH,0DEH,0B7H,0BBH,0BDH,0BEH,77H,7BH,7DH,7EH
table3: db 07FH,0BFH,0DFH,0EFH,0F7H,0FBH,0FDH,0FEH,07FH,0BFH,0DFH,0EFH,0F7H,0FBH,0FDH,0FEH     ;对应led键字0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7

end