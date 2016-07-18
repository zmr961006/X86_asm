/*************************************************************************
	> File Name: test_jie.c
	> Author: 
	> Mail: 
	> Created Time: 2016年07月16日 星期六 10时48分31秒
 ************************************************************************/

#include<stdio.h>


int fact_while(int n){

    int result = 1;
    while(n > 1){

        result *= n;
        n = n - 1;

    }
    return result;

}

int main(){
    
    int n  = 100;
    fact_while(100);
    return 0;

}
