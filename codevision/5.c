#include<mega16.h>
#include<delay.h>
flash unsigned char 
digit[10]={0b01000000,0b011111001,0b00100100,0b00110000,0b00011001,0b00010010,0b00000010,0b01111000,0b00000000,0b00010000}; //---- 0 1 2 3 4 5 6 7 8 9 
flash unsigned char
hell[4]={0b00001001 , 0b00000110 , 0b011000111 ,0b011000111  };       //----- it also could be like :  hel[3]={0b00001001 , 0b00000110 , 0b011000111};
void  main(void)
{
 char i=0;   // in 4 digit nymbers : stands for | [4]321 | &  2 digit nymbers : stands for | [2]1 | 
 char j=0;   // in 4 digit nymbers : stands for | 4[3]21 | &                               | 2[1] |  
 char m=0;   // in 4 digit nymbers : stands for | 43[2]1 |
 char n=0;   // in 4 digit nymbers : stands for | 432[1] |
 int z=0;    // just for show & time set
 char flag=0;  
 
   
 DDRB=0Xff;  // 7seg output 
 PORTB=0X00; //
 
 DDRD=0Xff;  // for  output control 
 PORTD=0X00; //        
   
 DDRA=0X00;  // for tst push btn [a6 a5] &  dip switch [a0 a1 a2 a3 a4]
          
     while(1)
    {         
        //part 1 
        if(PINA.0==1)// dip btn 1 -> pina.0 
        {     
               // j=9;  //for checking dec 
               // i=9;  //
                while(1)
                {  
                A :
                     for (z=0;z<100;z++) // show part 
                     { 
                       PORTD=1;
                       PORTB=digit[i];
                       delay_ms(1);  
                       
                       PORTD=0X02;     
                       PORTB=digit[j];
                       delay_ms(1);
                      }   
                      
                      
                        while(PINA.5==0) goto dec ;  // if you want to check you can comment this line 
                        
                        if(j==9)
                        {  
                          if(i==9)
                          {
                           //if (j==9)
                           {i=-1;}  //  [9](9) -> [0](9not_important_here)  ; i=-1 cuse will be +1 and i will be = 0 IN (*)
                          }
                          
                         j= -1 ;  // j from [9] -> [0]   in **
                         i+=1;  // number + 10 ; if A[9] + 0[1] = [a+1]0    here is [[[[ *  ]]]]
                        }
                        j+=1;   // number + 1            here is [[[[ ** ]]]]]
                        
                       /*  // if clear cm : you have to push btn evrey time for new increase  , but right now it increase automatically
                        while(PINA.5==1)
                        { 
                         for (z=0;z<25;z++) // show part 
                         { 
                         PORTD=1;
                         PORTB=digit[i];
                         delay_ms(1);  
                            
                         PORTD=0X02;     
                         PORTB=digit[j];
                         delay_ms(1);
                         }
                        }  
                       */
                        ////////////////////////////////////////////////////////////////////////    
                         
                dec:
                     
                      while(PINA.6==0) goto A ;  // if you want to check you can comment this line 
                      
                        if(j==0)
                        {  
                          if(i==0)
                          {
                           //if (j==0)
                           { i=10; }  //  [0](0) ->
                          }
                          
                         j= 10 ;  // j from [0] will be -> [9 ]   in **
                         i-=1;  // number - 10 ; if [j]A - [1]0 = [j-1]A    here is [[[[ *  ]]]]
                        }
                        j-=1;   // number + 1            here is [[[[ ** ]]]]]
                        
                        while(PINA.6==1)
                        { 
                         for (z=0;z<25;z++) // show part 
                         { 
                         PORTD=1;
                         PORTB=digit[i];
                         delay_ms(1);  
                            
                         PORTD=0X02;     
                         PORTB=digit[j];
                         delay_ms(1);
                         }
                        }
                         
                         

                    }
                    
                   
                                   
           }
        //end part 1
         
           //part2     HELL
           if(PINA.1==1) //dip btn 2 -> pina.1
           {
            for (z=0;z<250;z++)
            {
                PORTD=1;
                PORTB=hell[0];
                delay_ms(1);
                
                 PORTD=0X02;
                 PORTB=hell[1];
                 delay_ms(1);
                    
                 PORTD=0X04;
                 PORTB=hell[2];
                 delay_ms(1);
                
                 PORTD=0X08;
                 PORTB=hell[3];//    or  PORTB=hell[2]; again 
                 delay_ms(1);
            }
           }
          
        //part 3     0 TO 9999
        if(PINA.2==1)// dip btn 3 -> pina.2 
        {
         for (i=0;i<10;i++)
         {
            for(j=0;j<10;j++)
            {     
              for(m=0;m<10;m++)
              {
                 for(n=0;n<10;n++)
                 {
                   for (z=0;z<25;z++)
                   {
                     PORTD=1;
                     PORTB=digit[i];
                     delay_ms(1);  
                     
                     PORTD=0X02;     
                     PORTB=digit[j];
                     delay_ms(1);
                         
                     PORTD=0X04;
                     PORTB=digit[m];
                     delay_ms(1);
                     
                     PORTD=0X08;
                     PORTB=digit[n];
                     delay_ms(1);               
                                        
                   }
                 }
              }    
            }
          }
        }
            
        //part 4      9999 TO 0 
        if(PINA.3==1)// dip btn 4 -> pin.a3 
        {          
         if(flag==0)
         {
         flag+=1;
         i=9;
         j=9;
         m=9;
         n=9;
         }  
                   for (z=0;z<25;z++)
                   {
                     PORTD=1;
                     PORTB=digit[i];
                     delay_ms(1);  
                     
                     PORTD=0X02;     
                     PORTB=digit[j];
                     delay_ms(1);
                         
                     PORTD=0X04;
                     PORTB=digit[m];
                     delay_ms(1);
                     
                     PORTD=0X08;
                     PORTB=digit[n];
                     delay_ms(1);                          
                    }
                     
                      
                    
                  if(n==0)
                  {
                   if(m==0)
                   { 
                     if(j==0)
                     {  
                        if(i==0)
                        {
                         i = 10;  
                        }
                        j = 10 ;   
                        i-=1;   
                     }
                     m = 10;
                     j-=1;
                   }   
                   n= 10;
                   m-=1;      
                  }
                  n-=1;               
             
        } 
      
        //part 5      MY PHONE NUMBER
        if(PINA.4==1)// dip btn 5 -> pina.4 
        {      
              while(1)
              {
                 for (z=0;z<250;z++) //--0912
                 {
                     PORTD=1;
                     PORTB=digit[0];
                     delay_ms(1);  
                     
                     PORTD=0X02;     
                     PORTB=digit[9];
                     delay_ms(1);
                         
                     PORTD=0X04;
                     PORTB=digit[1];
                     delay_ms(1);
                     
                     PORTD=0X08;
                     PORTB=digit[2];
                     delay_ms(1);                          
                 }                
                  
                    for (z=0;z<250;z++) //--933
                    {
                     PORTD=1;
                     PORTB=digit[9];
                     delay_ms(1);  
                     
                     PORTD=0X02;     
                     PORTB=digit[3];
                     delay_ms(1);
                         
                     PORTD=0X04;
                     PORTB=digit[3];
                     delay_ms(1);
                    }               
                  
                    for (z=0;z<250;z++) //--6709
                    {
                       
                     PORTD=1;
                     PORTB=digit[6];
                     delay_ms(1); 
                     
                     PORTD=0x02;
                     PORTB=digit[7];
                     delay_ms(1);  
                     
                     PORTD=0X04;     
                     PORTB=digit[0];
                     delay_ms(1);
                         
                     PORTD=0X08;
                     PORTB=digit[9];
                     delay_ms(1);                           
                    }
              }                       
        }
                
    }
 }