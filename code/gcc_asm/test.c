/*************************************************************************
	> File Name: test.c
	> Author: 
	> Mail: 
	> Created Time: 2016年06月06日 星期一 14时36分39秒
 ************************************************************************/

#include<stdio.h>

int main(){

    int a = 1;
    int b = 2;
    int c = 0;
    __asm__ __volatile__("movl %1,%0":"=r"(b):"r"(a));

    __asm__ __volatile__("addl %1,%0":"=r"(c):"r"(a));

    printf("%d %d %d\n",a,b,c);
    return 1;



}

