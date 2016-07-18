/*************************************************************************
	> File Name: test5.c
	> Author: 
	> Mail: 
	> Created Time: 2016年07月18日 星期一 09时33分05秒
 ************************************************************************/

#include<stdio.h>


int main(){

    int input  = 100;
    int output = 0;
    __asm__ __volatile__("movq %0,%%rax "::"g"(input):);
    __asm__ __volatile__("movq %%rax,%0":"=m"(output):);
    printf("%d\n",output);


}
