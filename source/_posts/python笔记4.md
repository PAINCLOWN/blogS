---
title: python笔记4
date: 2018-12-19 16:53:26
tags: 
categories: python笔记
---

``` 
#*args —— 存放 元组 参数，前面有一个 *
#**kwargs —— 存放 字典 参数，前面有两个 **
def demo(num,*args,**kwargs):
    print(num)
    print(args)
    print(kwargs)

num = 1
nameTuple = ("q","w","e","r")
nameDict = {
    "name" : "小明",
    "age" : 13
}
demo(num,*nameTuple,**nameDict)
```