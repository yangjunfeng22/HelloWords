//
//  nam.cpp
//  HSWordsPass
//
//  Created by yang on 14-9-1.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#include "nam.h"

#include <vector>
#include <list>

using namespace mynamespace;

netHelper::netHelper(int x):x(x),y(0)
{
    this->x = x;
    printf("x: %d\n", x);
}

netHelper::~netHelper()
{
    printf("netHelper release.\n");
}

void netHelper::foo()
{
    // stackInt 使用栈空间,程序返回后，用来存储“5”的这块内存空间就会自动释放。
    // 在Objective-C中，你只能在堆上创建对象,这就是为什么在Objective-C代码上会看到星号，
    // 所有的对象都在堆上创建，并且所有对象都有指针。
    // 使用栈对象时，你需要点运算符(.)；使用堆对象时，你需要使用箭头操作符（-->）。
    int stackInt = 5;
    int *heapInt = (int *)malloc(sizeof(int));
    *heapInt = 5;
    free(heapInt);
    printf("%d", stackInt);
    
    int *help = new int();
    *help = 5;
    delete help;
    
    // 使用模板函数
    int ix = 1;
    int iy = 2;
    swap(ix, iy);
    
    Triplet<int> intTriplet(1, 2, 3);
    Triplet<float> floatTriplet(1.1, 2.1, 3.1);
    //Triplet<netHelper> netHelperTriplet(netHelper(1), netHelper(2), netHelper(3));
    
    // 容器的用法
    // vector中将是从1到5的有序序列
    // 所有的容器都是可变的，没有可变或者不可变的变量。
    // vector被实现为一个单一的或连续的内存块。
    // vector的空间大小等于所存储的对象的大小乘以vector中对象数
    //（存储4字节或者8字节的整数取决于你使用的体系结构是32位还是64位的）。
    std::vector<int> v;
    v.push_back(1);
    v.push_back(2);
    v.push_back(3);
    v.push_back(4);
    v.push_back(5);
    
    // 使用容器
    // 这两种方法都能有效地访问vector中的元素。
    // at()函数需要检查是否在vector范围内索引，超出范围的话会抛出异常。
    int first = v[1];
    int outOfBounds = v.at(2);
    
    // 双向链表的用法
    std::list<int> l;
    l.push_back(1);
    l.push_back(2);
    l.push_back(3);
    l.push_back(4);
    l.push_back(5);
    
    // 使用双向链表
    // 需要用一个迭代器（iterators）去遍历list。
    std::list<int>::iterator i;
    for (i = l.begin(); i != l.end(); i++)
    {
        int thisInt = *i;
        printf("i: %d", thisInt);
    }
    
    
    printf("\nfirst: %d, out: %d\n", first, outOfBounds);
    
    
    printf("I'm so foo!\n");
}

