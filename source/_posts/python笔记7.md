---
title: python笔记7
date: 2018-12-19 16:56:26
tags: 
categories: python笔记
---

``` 
#打开文件
file = open("README1","w")
#写入f = open("文件名", "访问方式")
file.write("你好")
#关闭
file.close()

file = open("README")
#读取
text = file.read()
print(text)
```