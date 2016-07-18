/*************************************************************************
	> File Name: test2.cpp
	> Author: 
	> Mail: 
	> Created Time: 2016年07月17日 星期日 22时09分05秒
 ************************************************************************/

#include<iostream>
using namespace std;

#define F 10

int main(){
    
    int result = 10;
    int input = 0;

    __asm__ __volatile__("mov %1,%0":"=r"(result),"=m"(input));
    __asm__ __volatile__("addl %1,%0":"=r"(result),F);

    printf("%d\n",result);


}


