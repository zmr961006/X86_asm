/*************************************************************************
	> File Name: test.cpp
	> Author: 
	> Mail: 
	> Created Time: 2016年07月17日 星期日 20时36分03秒
 ************************************************************************/

#include<iostream>
using namespace std;


int main(){

    for(int i = 1;i > 0;i++){
        __asm__ __volatile__ ("hlt;");
    }
}
