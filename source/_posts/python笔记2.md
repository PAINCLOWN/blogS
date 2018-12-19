---
title: python笔记2
date: 2018-12-19 16:51:26
tags: 
categories: python笔记
---

``` 
import random
computer = random.randint(1,3)
player = int(input("请输入您要出的拳 石头（1）／剪刀（2）／布（3）："))
nameNum = ("石头","剪刀","布")
if computer is 1:
    print("电脑选择出:%s" %nameNum[computer - 1])
elif computer is 2:
    print("电脑选择出:%s" % nameNum[computer - 1])
else:
    print("电脑选择出:%s" % nameNum[computer - 1])
#玩家赢的情况
#1石头 》 2剪刀
#2剪刀 》 3布
#3布  》 1石头

if ((player is 1 and computer is 2) or (player is 2 and computer is 3) or (player is 3 and computer is 1)):
    print("玩家获胜")
elif player is computer:
    print("平局")
else:
    print("电脑获胜")
```
