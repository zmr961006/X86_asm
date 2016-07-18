/*************************************************************************
	> File Name: test_switch.c
	> Author: 
	> Mail: 
	> Created Time: 2016年07月16日 星期六 11时02分21秒
 ************************************************************************/

#include<stdio.h>


int fun(){
    int a ;
    switch(a){
        case 1: {
            a++;  
        }

        case 2:{
            a--;
        }

        case 3:{
            
            a++;
        }
        
        case 4:{
            a--;    
        }
        
        case 5:{
            a += 11;
        }
        
        case 6:{
            a -= 10;
        }

        case 7:{
            a*= 11;
        }
        
        case 8:{
            a*= 19;
        }
        default:{
            a++;
        }

    }

}

int main(){
    fun();
}
