/*************************************************************************
	> File Name: test4.c
	> Author: 
	> Mail: 
	> Created Time: 2016年07月18日 星期一 09时24分22秒
 ************************************************************************/

#include<stdio.h>

int fun(){
    printf("hello world\n");
    return 10;
}


int main(){

    int foo;
    __asm__ __volatile__("call fun\n\tmovl %%ebx,%0":"=m"(foo));


}
