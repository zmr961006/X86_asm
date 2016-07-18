/*************************************************************************
	> File Name: test_struct.c
	> Author: 
	> Mail: 
	> Created Time: 2016年07月16日 星期六 11时46分29秒
 ************************************************************************/

#include<stdio.h>


struct node{
    int a;
    short b;
    double x;

};


int main(){
    
    struct node node = {1,12,1.00};
    printf("%d\n",node.a);


}
