//
//  nam.h
//  HSWordsPass
//
//  Created by yang on 14-9-1.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#ifndef __HSWordsPass__nam__
#define __HSWordsPass__nam__

#include <iostream>

// 模板函数
template <typename T>
void swap(T a, T b)
{
    T temp = a;
    a = b;
    b = temp;
}

template <typename T>
class Triplet{
private:
    T a, b, c;
    
public:
    Triplet(T a, T b, T c) : a(a), b(b), c(c){};
    
    T getA(){return a;};
    T getB(){return b;};
    T getC(){return c;};
};

namespace mynamespace {
    class netHelper{
        int x;
        int y;
        
        
    public:
        netHelper(int x)/*{
            this->x = x;
            printf("x: %d\n", x);
        }*/;
        netHelper(int x, int y) : x(x), y(y){};
        // 如果有继承的话，那么需要virtual修饰.
        //virtual ~netHelper();
        ~netHelper();
        
        void foo();
        
        // 加号的运算符重载, 两个对象的相加
        netHelper operator+(const netHelper &rhs){
            return netHelper(x + rhs.x, y + rhs.y);
        }
        
        // 加号的运算符重载, 一个对象加上一个常数
        netHelper operator+(const int &rhs){
            return netHelper(x + rhs, y + rhs);
        }
    };
}


#endif /* defined(__HSWordsPass__nam__) */
