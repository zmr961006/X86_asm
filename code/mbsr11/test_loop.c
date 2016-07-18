/*************************************************************************
	> File Name: test_loop.c
	> Author: 
	> Mail: 
	> Created Time: 2016年07月16日 星期六 10时35分51秒
 ************************************************************************/

#include<stdio.h>

int dw_loop(int x,int y,int n){

    do{
        x += n;
        y *= n;
        n--;
    }while((n > 0) && (y < n));
    return x;

}

int main(){
    int a = 100;
    int b = 101;
    int n = 102;
    dw_loop(a,b,n);
    return 0;

}
