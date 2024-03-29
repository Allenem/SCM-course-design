#include<reg52.h>
#define N 800

//绑定接口
sbit LED1=P1^0;
sbit LED2=P1^1;
sbit LED3=P1^2;
sbit LED4=P1^3;
sbit LED5=P1^4;
sbit LED6=P1^5;
sbit LED7=P1^6;
sbit LED8=P1^7;

sbit LED9=P0^0;
sbit LED10=P0^1;
sbit LED11=P0^2;
sbit LED12=P0^3;
sbit LED13=P0^4;
sbit LED14=P0^5;
sbit LED15=P0^6;
sbit LED16=P0^7;

sbit LED17=P2^0;
sbit LED18=P2^1;
sbit LED19=P2^2;
sbit LED20=P2^3;
sbit LED21=P2^4;
sbit LED22=P2^5;
sbit LED23=P2^6;
sbit LED24=P2^7;

sbit LED25=P3^0;
sbit LED26=P3^1;
sbit LED27=P3^2;
sbit LED28=P3^3;
sbit LED29=P3^4;
sbit LED30=P3^5;
sbit LED31=P3^6;
sbit LED32=P3^7;

//自定义Delay函数
void Delay(unsigned int a)
{
	unsigned char b;
	for(;a>0;a--)
	{
		for(b=110;b>0;b--);
	}
}

//主函数
void main()
{
	unsigned int i;
	while(1)
	{
		//初始化
		LED1=0,LED2=0,LED3=0,LED4=0,LED5=0,LED6=0,LED7=0,LED8=0,
		LED9=0,LED10=0,LED11=0,LED12=0,LED13=0,LED14=0,LED15=0,LED16=0,
		LED17=0,LED18=0,LED19=0,LED20=0,LED21=0,LED22=0,LED23=0,LED24=0,
		LED25=0,LED26=0,LED27=0,LED28=0,LED29=0,LED30=0,LED31=0,LED32=0;

		//依次点亮各个灯
		LED1=1;
		Delay(N);
		LED2=1;
		Delay(N);
		LED3=1;
		Delay(N);
		LED4=1;
		Delay(N);
		LED5=1;
		Delay(N);
		LED6=1;
		Delay(N);
		LED7=1;
		Delay(N);
		LED8=1;
		Delay(N);
		LED9=1;
		Delay(N);
		LED10=1;
		Delay(N);
		LED11=1;
		Delay(N);
		LED12=1;
		Delay(N);
		LED13=1;
		Delay(N);
		LED14=1;
		Delay(N);
		LED15=1;
		Delay(N);
		LED16=1;
		Delay(N);
		LED17=1;
		Delay(N);
		LED18=1;
		Delay(N);
		LED19=1;
		Delay(N);
		LED20=1;
		Delay(N);
		LED21=1;
		Delay(N);
		LED22=1;
		Delay(N);
		LED23=1;
		Delay(N);
		LED24=1;
		Delay(N);
		LED25=1;
		Delay(N);
		LED26=1;
		Delay(N);
		LED27=1;
		Delay(N);
		LED28=1;
		Delay(N);
		LED29=1;
		Delay(N);
		LED30=1;
		Delay(N);
		LED31=1;
		Delay(N);
		LED32=1;
		Delay(N);

		//初始化
		LED1=0,LED2=0,LED3=0,LED4=0,LED5=0,LED6=0,LED7=0,LED8=0,
		LED9=0,LED10=0,LED11=0,LED12=0,LED13=0,LED14=0,LED15=0,LED16=0,
		LED17=0,LED18=0,LED19=0,LED20=0,LED21=0,LED22=0,LED23=0,LED24=0,
		LED25=0,LED26=0,LED27=0,LED28=0,LED29=0,LED30=0,LED31=0,LED32=0;
		
		//反向依次点亮各个灯
		LED32=1;
		Delay(N);
		LED32=0;
		LED31=1;
		Delay(N);
		LED31=0;
		LED30=1;
		Delay(N);
		LED30=0;
		LED29=1;
		Delay(N);
		LED29=0;
		LED28=1;
		Delay(N);
		LED28=0;
		LED27=1;
		Delay(N);
		LED27=0;
		LED26=1;
		Delay(N);
		LED26=0;
		LED25=1;
		Delay(N);
		LED25=0;
		LED24=1;
		Delay(N);
		LED24=0;
		LED23=1;
		Delay(N);
		LED23=0;
		LED22=1;
		Delay(N);
		LED22=0;
		LED21=1;
		Delay(N);
		LED21=0;
		LED20=1;
		Delay(N);
		LED20=0;
		LED19=1;
		Delay(N);
		LED19=0;
		LED18=1;
		Delay(N);
		LED18=0;
		LED17=1;
		Delay(N);
		LED17=0;
		LED16=1;
		Delay(N);
		LED16=0;
		LED15=1;
		Delay(N);
		LED15=0;
		LED14=1;
		Delay(N);
		LED14=0;
		LED13=1;
		Delay(N);
		LED13=0;
		LED12=1;
		Delay(N);
		LED12=0;
		LED11=1;
		Delay(N);
		LED11=0;
		LED10=1;
		Delay(N);
		LED10=0;
		LED9=1;
		Delay(N);
		LED9=0;
		LED8=1;
		Delay(N);
		LED8=0;
		LED7=1;
		Delay(N);
		LED7=0;
		LED6=1;
		Delay(N);
		LED6=0;
		LED5=1;
		Delay(N);
		LED5=0;
		LED4=1;
		Delay(N);
		LED4=0;
		LED3=1;
		Delay(N);
		LED3=0;
		LED2=1;
		Delay(N);
		LED2=0;
		LED1=1;
		Delay(N);

		//4部分循环亮灯
		for(i=0;i<40;i++)
		{
			//初始化
			LED1=0,LED2=0,LED3=0,LED4=0,LED5=0,LED6=0,LED7=0,LED8=0,
			LED9=0,LED10=0,LED11=0,LED12=0,LED13=0,LED14=0,LED15=0,LED16=0,
			LED17=0,LED18=0,LED19=0,LED20=0,LED21=0,LED22=0,LED23=0,LED24=0,
			LED25=0,LED26=0,LED27=0,LED28=0,LED29=0,LED30=0,LED31=0,LED32=0;
			
			//第一部分亮灯
			if((i%4)==0)
			{
				LED1=1,LED2=1,LED3=1,LED4=1,LED5=1,LED6=1,LED7=1,LED8=1,
				LED9=0,LED10=0,LED11=0,LED12=0,LED13=0,LED14=0,LED15=0,LED16=0,
				LED17=0,LED18=0,LED19=0,LED20=0,LED21=0,LED22=0,LED23=0,LED24=0,
				LED25=0,LED26=0,LED27=0,LED28=0,LED29=0,LED30=0,LED31=0,LED32=0;
				Delay(700);
			}
			//第二部分亮灯			
			else if((i%4)==1)
			{
				LED1=0,LED2=0,LED3=0,LED4=0,LED5=0,LED6=0,LED7=0,LED8=0,
				LED9=1,LED10=1,LED11=1,LED12=1,LED13=1,LED14=1,LED15=1,LED16=1,
				LED17=0,LED18=0,LED19=0,LED20=0,LED21=0,LED22=0,LED23=0,LED24=0,
				LED25=0,LED26=0,LED27=0,LED28=0,LED29=0,LED30=0,LED31=0,LED32=0;
				Delay(700);
			}
			//第三部分亮灯
			else if((i%4)==2)
			{
				LED1=0,LED2=0,LED3=0,LED4=0,LED5=0,LED6=0,LED7=0,LED8=0,
				LED9=0,LED10=0,LED11=0,LED12=0,LED13=0,LED14=0,LED15=0,LED16=0,
				LED17=1,LED18=1,LED19=1,LED20=1,LED21=1,LED22=1,LED23=1,LED24=1,
				LED25=0,LED26=0,LED27=0,LED28=0,LED29=0,LED30=0,LED31=0,LED32=0;
				Delay(700);
			}
			//第四部分亮灯
			else if((i%4)==3)
			{
				LED1=0,LED2=0,LED3=0,LED4=0,LED5=0,LED6=0,LED7=0,LED8=0,
				LED9=0,LED10=0,LED11=0,LED12=0,LED13=0,LED14=0,LED15=0,LED16=0,
				LED17=0,LED18=0,LED19=0,LED20=0,LED21=0,LED22=0,LED23=0,LED24=0,
				LED25=1,LED26=1,LED27=1,LED28=1,LED29=1,LED30=1,LED31=1,LED32=1;
				Delay(700);
			}
		}
		 	
		//一闪一闪亮灯
		for(i=50;i>0;i--)
		 	{

				//亮灯
		 		LED1=1,LED2=1,LED3=1,LED4=1,LED5=1,LED6=1,LED7=1,LED8=1,
		 		LED9=1,LED10=1,LED11=1,LED12=1,LED13=1,LED14=1,LED15=1,LED16=1,
		 		LED17=1,LED18=1,LED19=1,LED20=1,LED21=1,LED22=1,LED23=1,LED24=1,
		 		LED25=1,LED26=1,LED27=1,LED28=1,LED29=1,LED30=1,LED31=1,LED32=1;
		 		Delay(250+i*10);
				
				//灭灯
		 	  LED1=0,LED2=0,LED3=0,LED4=0,LED5=0,LED6=0,LED7=0,LED8=0,
		 		LED9=0,LED10=0,LED11=0,LED12=0,LED13=0,LED14=0,LED15=0,LED16=0,
		 		LED17=0,LED18=0,LED19=0,LED20=0,LED21=0,LED22=0,LED23=0,LED24=0,
		 		LED25=0,LED26=0,LED27=0,LED28=0,LED29=0,LED30=0,LED31=0,LED32=0;
		 		Delay(250+i*10);
			}
			
			
		//全亮
		while(2)
			{
				LED1=1,LED2=1,LED3=1,LED4=1,LED5=1,LED6=1,LED7=1,LED8=1,
				LED9=1,LED10=1,LED11=1,LED12=1,LED13=1,LED14=1,LED15=1,LED16=1,
				LED17=1,LED18=1,LED19=1,LED20=1,LED21=1,LED22=1,LED23=1,LED24=1,
				LED25=1,LED26=1,LED27=1,LED28=1,LED29=1,LED30=1,LED31=1,LED32=1;
			}
	}
}