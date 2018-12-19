---
title: python笔记9
date: 2018-12-19 16:58:26
tags: 
categories: python笔记
---

``` 
class Dog:
    def __init__(self,newName):
        #根据形参初始化一个名字对象
        self.name = newName
        print("%s,来了" % self.name)
    def __del__(self):
        print("%s,去了" % self.name)
    def __str__(self):
        return "我叫：%s" % self.name
dog = Dog("二狗子")
print(dog)
#创建dog2对象，初始化变量为12
dog2 = Dog(12)
#赋值给dog2对象的name变量
dog2.name = "大狗子"
print(dog2)


```