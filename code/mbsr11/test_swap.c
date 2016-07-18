/*************************************************************************
	> File Name: test_swap.c
	> Author: 
	> Mail: 
	> Created Time: 2016年07月16日 星期六 15时50分47秒
 ************************************************************************/

#include<stdio.h>


void swap(int *xp,int *yp){
    *xp = *xp + *yp;
    *yp = *xp - *yp;
    *xp = *xp - *yp;
}

int main(){

    int a = 10;
    int *m = &a;
    int *n = &a;
    printf("m = %d,n = %d\n",*m,*n);
    swap(m,n);
    printf("m = %d,n = %d\n",*m,*n);

}
