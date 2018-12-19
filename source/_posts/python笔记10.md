---
title: python笔记10
date: 2018-12-19 16:59:26
tags: 
categories: python笔记
---

``` 
class DemoOne(object):
    def __init__ (self,name,age):
        #可以改通过demo.来访问
        self.name = name
        #私有属性不可通过demo1.来访问
        self.__age = age
    def printAge(self):
        print("%d" % self.__age)
    def agePlus(self):
        self.__age += 1

demo1 = DemoOne("Tom",20)



class DemoTwo(DemoOne):
    def __init__(self,name,age,sex):
        self.sex = sex
        #注意重写父类的格式，强制调用父类方法
        # super(子类名,self)
        super(DemoTwo,self).__init__(name,age)
    def printSex(self):
        print("我的性别是：%s" % self.sex)
demo2 = DemoTwo("jack",12,"男")
demo2.printSex()


```