---
title: python笔记12
date: 2018-12-20 16:44:50
tags: 
categories: python笔记
---

```
class MusicPlayer(object):
    #定义一个类属性用于引用标记
    instance = None
    #定义一个类属性，用于实例化时引用标记
    init_index = False
    #创建空间
    #这是一个静态方法
    def __new__(cls, *args, **kwargs):
        #单例模式，只创建一次内存空间
        if cls.instance is None:
            cls.instance = super().__new__(cls)
    #返回单例引用
        return cls.instance
    #只初始化一次
    def __init__(self):
        #判断标记是否为False，为False则没有初始化对象
        if not MusicPlayer.init_index:
            print("初始化")
            #创建对象后修改标记
            MusicPlayer.init_index = True

MP1 = MusicPlayer()
#打印内存地址
print(MP1)

MP2 = MusicPlayer()
#打印内存地址
print(MP2)
```