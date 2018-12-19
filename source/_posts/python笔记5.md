---
title: python笔记5
date: 2018-12-19 16:54:26
tags: 
categories: python笔记
---

``` 
#函数递归
#累加 计算 1 + 2 + ... num 的结果
def sumNums(num):
    if num is 1:
        return num
    tmpNum = sumNums(num - 1)
    return num + tmpNum

print(sumNums(3))
```