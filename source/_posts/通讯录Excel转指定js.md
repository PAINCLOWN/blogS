---
title: 通讯录Excel转指定js
date: 2019-4-29
tags: Excel
categories: CODE
---

^[突然有个需求需要把Excel中的人名转换成js保存为指定的格式]

虽然人数不多可以手动复制

但是比较讨厌不听的做重复的动作

然后

就写了一个py脚本

用的是xlrd模块

``` javascript
'''
#通讯录Excel转js#
Author: PA1NCL0WN
'''
import xlrd
#读取excel
excelFile = xlrd.open_workbook("txl.xlsx")
#读取第一个表
table = excelFile.sheets()[0]
#table表总行数
nrows = table.nrows
#初始化一个空元祖
nameList = []
#遍历每一行
for i in range(nrows):
    #前三行为标题，过滤掉
    if i <= 3 :
        #当是第一次运行时保存一个var的开头
        if i == 1:
            file = open("member.js", "w")
            file.writelines(['var member = [\n'])
            file.close()
        else:
            continue
    else:
        #保存第i行的第五个数据（名字）
        nameData =table.cell_value(i,5)
        #打印当前的名字
        print("%s" % nameData)
        file = open("member.js" ,"a")
        file.writelines(['  {\n' , '    "phone": "",\n' , '"name": "%s"\n' % nameData , '  },\n'])
        file.close()
        #操作完置空元祖
        strList =[]
        #如果最后一个名字也保存完，就直接写入一个}作为结尾
    if i == nrows:
        file = open("member.js", "a")
        file.writelines(['}\n'])
        file.close()


```