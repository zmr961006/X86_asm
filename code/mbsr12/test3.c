/*************************************************************************
	> File Name: test3.c
	> Author: 
	> Mail: 
	> Created Time: 2016年07月18日 星期一 08时19分23秒
 ************************************************************************/

#include<stdio.h>


int main(){

    int eax = 0,ebx,ecx,edx;
    int one = 1;
    __asm__ __volatile__("movl $1,%eax");
    __asm__ __volatile__("cpuid");
    __asm__ __volatile__("movl %%eax,%0":"=m"(eax)::);
                         /*;\n\tmovl %%ebx,%2;\n\tmovl %%ecx,%1;\n\tmovl %%edx,%0;\n\t"
                         :"=m"(edx),"=m"(ecx),"=m"(ebx),"=m"(eax):);*/
    //printf("%s %s %s %s\n",eax,ebx,ecx,edx);
    
    int a[4] ;
    printf("%d\n",eax);
    a[0] = eax & 0x000000ff;
    a[1] = eax & 0x0000ff00;
    a[1] = a[1] >> 8;
    a[2] = eax & 0x00ff0000;
    a[2] = a[2] >> 16;
    a[3] = eax & 0xff000000;
    a[3] = eax >> 24;
    
    printf("%d %d %d %d \n",a[0],a[1],a[2],a[3]);
    

}
